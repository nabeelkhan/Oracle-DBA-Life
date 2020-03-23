REM FILE NAME:  tbsp_exp.sql
REM LOCATION:   Backup Recovery\Utilities
REM FUNCTION:   Creates a basic shell script to perform tablespace level exports
REM TESTED ON:  8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_tables, dba_tablespaces, v$database
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM
REM NOTES:    Each tablespace is given its own export that handles
REM           its tables and their related indexes, grants and
REM           constraints
REM
REM***********************************************************************************


SET verify off echo off termout on feedback off 
PROMPT ...creating tablespace level export script
SET termout on
DROP TABLE exp_temp;

CREATE TABLE exp_temp (file# NUMBER, line_no NUMBER, line_txt LONG);

DECLARE
   CURSOR count_tabs (tbsp IN VARCHAR2)
   IS
      SELECT COUNT (*)
        FROM dba_tables
       WHERE tablespace_name = tbsp;

   CURSOR get_tbsp
   IS
      SELECT tablespace_name
        FROM dba_tablespaces
       WHERE tablespace_name != 'SYSTEM';

   CURSOR get_owners (tbsp IN VARCHAR2)
   IS
      SELECT DISTINCT (owner)
                 FROM dba_tables
                WHERE tablespace_name = tbsp;

   CURSOR get_tabs (tbsp IN VARCHAR2, owner IN VARCHAR2)
   IS
      SELECT table_name
        FROM dba_tables
       WHERE tablespace_name = tbsp AND owner = owner;

   row_cntr        INTEGER                                := 0;
   tablespace_nm   dba_tablespaces.tablespace_name%TYPE;
   owner           dba_tables.owner%TYPE;
   table_nm        dba_tables.table_name%TYPE;
   ln_txt          exp_temp.line_txt%TYPE;
   own_cnt         INTEGER;
   tab_cnt         INTEGER;
   file_no         INTEGER;
   tab_count       INTEGER;
   dbname          v$database.NAME%TYPE;

   PROCEDURE insert_tab (file_no NUMBER, row_cntr NUMBER, ln_txt VARCHAR2)
   IS
   BEGIN
      INSERT INTO exp_temp
                  (file#, line_no, line_txt)
           VALUES (file_no, row_cntr, ln_txt);
   END;
BEGIN
   /*
    initialize various counters
   */
   row_cntr := 0;
   tab_count := 0;
   file_no := 1;

   /*
    Get database name
   */
   SELECT NAME
     INTO dbname
     FROM v$database;

   ln_txt :=    '# Tablespace level export script for instance: '
             || dbname;
   row_cntr :=   row_cntr
               + 1;
   insert_tab (file_no, row_cntr, ln_txt);
   /*
    Set command in script to set SID
   */
   ln_txt :=    'ORACLE_SID='
             || LOWER (dbname);
   row_cntr :=   row_cntr
               + 1;
   insert_tab (file_no, row_cntr, ln_txt);

   /*
   First run to build export script header
    Get all tablespace names other than system
   */
   IF get_tbsp%ISOPEN
   THEN
      CLOSE get_tbsp;
      OPEN get_tbsp;
   ELSE
      OPEN get_tbsp;
   END IF;

   LOOP
      FETCH get_tbsp INTO tablespace_nm;
      EXIT WHEN get_tbsp%NOTFOUND;

      /*
      See if tablespace has tables
      */
      IF count_tabs%ISOPEN
      THEN
         CLOSE count_tabs;
         OPEN count_tabs (tablespace_nm);
      ELSE
         OPEN count_tabs (tablespace_nm);
      END IF;

      FETCH count_tabs INTO tab_count;

      IF tab_count = 0
      THEN
         GOTO end_loop1;
      END IF;

      row_cntr :=   row_cntr
                  + 1;
      ln_txt := '#';
      insert_tab (file_no, row_cntr, ln_txt);
      row_cntr :=   row_cntr
                  + 1;
      ln_txt := '#';
      insert_tab (file_no, row_cntr, ln_txt);

      SELECT    '# Tablespace: '
             || tablespace_nm
        INTO ln_txt
        FROM DUAL;

      row_cntr :=   row_cntr
                  + 1;
      insert_tab (file_no, row_cntr, ln_txt);

      SELECT    '#   Export DMP file name: '
             || tablespace_nm
             || '_'
             || TRUNC (SYSDATE)
             || '.dmp'
        INTO ln_txt
        FROM DUAL;

      row_cntr :=   row_cntr
                  + 1;
      insert_tab (file_no, row_cntr, ln_txt);
      row_cntr :=   row_cntr
                  + 1;
      ln_txt :=    '#   Owners for '
                || tablespace_nm;
      insert_tab (file_no, row_cntr, ln_txt);

      SELECT ''
        INTO ln_txt
        FROM DUAL;

      own_cnt := 0;

      /*
      Get tablespace table owners
      */
      IF get_owners%ISOPEN
      THEN
         CLOSE get_owners;
         OPEN get_owners (tablespace_nm);
      ELSE
         OPEN get_owners (tablespace_nm);
      END IF;

      tab_cnt := 0;

      LOOP
         FETCH get_owners INTO owner;
         EXIT WHEN get_owners%NOTFOUND;
         /*
         Get tablespace tables
         */
         ln_txt :=    '#   Tables for tablespace: '
                   || tablespace_nm;
         row_cntr :=   row_cntr
                     + 1;
         insert_tab (file_no, row_cntr, ln_txt);
         ln_txt := '';

         IF get_tabs%ISOPEN
         THEN
            CLOSE get_tabs;
            OPEN get_tabs (tablespace_nm, owner);
         ELSE
            OPEN get_tabs (tablespace_nm, owner);
         END IF;

         LOOP
            FETCH get_tabs INTO table_nm;
            EXIT WHEN get_tabs%NOTFOUND;
            tab_cnt :=   tab_cnt
                       + 1;

            IF tab_cnt = 1
            THEN
               ln_txt :=    '/*    '
                         || ln_txt
                         || owner
                         || '.'
                         || table_nm;
            ELSE
               ln_txt :=    ln_txt
                         || ', '
                         || owner
                         || '.'
                         || table_nm;
            END IF;
         END LOOP;

         CLOSE get_tabs;
         row_cntr :=   row_cntr
                     + 1;
         ln_txt :=    ln_txt
                   || ' */';
         insert_tab (file_no, row_cntr, ln_txt);
      END LOOP;

      CLOSE get_owners;

      <<end_loop1>>
      NULL;
   END LOOP;

   CLOSE get_tbsp;
   ln_txt := '####### End of Header -- Start of actual export script ########';
   row_cntr :=   row_cntr
               + 1;
   insert_tab (file_no, row_cntr, ln_txt);
   ln_txt := 'set -x ';
   row_cntr :=   row_cntr
               + 1;
   insert_tab (file_no, row_cntr, ln_txt);

   SELECT    'script tablespace_exp_'
          || SYSDATE
          || '.log'
     INTO ln_txt
     FROM DUAL;

   row_cntr :=   row_cntr
               + 1;
   insert_tab (file_no, row_cntr, ln_txt);

   /*
   Now build actual export command sets
   */
   /*
    Get all tablespace names other than system
   */
   IF get_tbsp%ISOPEN
   THEN
      CLOSE get_tbsp;
      OPEN get_tbsp;
   ELSE
      OPEN get_tbsp;
   END IF;

   LOOP
      FETCH get_tbsp INTO tablespace_nm;
      EXIT WHEN get_tbsp%NOTFOUND;

      /*
      See if tablespace has tables
      */
      IF count_tabs%ISOPEN
      THEN
         CLOSE count_tabs;
         OPEN count_tabs (tablespace_nm);
      ELSE
         OPEN count_tabs (tablespace_nm);
      END IF;

      FETCH count_tabs INTO tab_count;

      IF tab_count = 0
      THEN
         GOTO end_loop;
      END IF;

      row_cntr :=   row_cntr
                  + 1;
      ln_txt := '#';
      insert_tab (file_no, row_cntr, ln_txt);
      row_cntr :=   row_cntr
                  + 1;
      ln_txt := '#';
      insert_tab (file_no, row_cntr, ln_txt);

      SELECT    '# Export script for tablespace '
             || tablespace_nm
        INTO ln_txt
        FROM DUAL;

      row_cntr :=   row_cntr
                  + 1;
      insert_tab (file_no, row_cntr, ln_txt);

      SELECT    '# created on '
             || SYSDATE
        INTO ln_txt
        FROM DUAL;

      row_cntr :=   row_cntr
                  + 1;
      insert_tab (file_no, row_cntr, ln_txt);
      ln_txt :=    'if ( -r  '
                || tablespace_nm
                || '.par'
                || ' ) then';
      row_cntr :=   row_cntr
                  + 1;
      insert_tab (file_no, row_cntr, ln_txt);
      ln_txt :=    '   rm '
                || tablespace_nm
                || '.par';
      row_cntr :=   row_cntr
                  + 1;
      insert_tab (file_no, row_cntr, ln_txt);
      ln_txt := 'end if';
      row_cntr :=   row_cntr
                  + 1;
      insert_tab (file_no, row_cntr, ln_txt);
      ln_txt :=    'touch '
                || tablespace_nm
                || '.par';
      row_cntr :=   row_cntr
                  + 1;
      insert_tab (file_no, row_cntr, ln_txt);

      /*
      Set up basic export commands
      */
      SELECT    'echo '
             || CHR (39)
             || 'grants=y indexes=y constraints=y compress=y'
             || CHR (39)
             || '>>'
             || tablespace_nm
             || '.par'
        INTO ln_txt
        FROM DUAL;

      row_cntr :=   row_cntr
                  + 1;
      insert_tab (file_no, row_cntr, ln_txt);

      SELECT ''
        INTO ln_txt
        FROM DUAL;

      own_cnt := 0;
      ln_txt :=    'echo '
                || CHR (39)
                || 'tables=('
                || CHR (39)
                || '>>'
                || tablespace_nm
                || '.par';
      row_cntr :=   row_cntr
                  + 1;
      insert_tab (file_no, row_cntr, ln_txt);

      /*
      Get tablespace table owners
      */
      IF get_owners%ISOPEN
      THEN
         CLOSE get_owners;
         OPEN get_owners (tablespace_nm);
      ELSE
         OPEN get_owners (tablespace_nm);
      END IF;

      tab_cnt := 0;

      LOOP
         FETCH get_owners INTO owner;
         EXIT WHEN get_owners%NOTFOUND;

         /*
         Get tablespace tables
         */
         IF get_tabs%ISOPEN
         THEN
            CLOSE get_tabs;
            OPEN get_tabs (tablespace_nm, owner);
         ELSE
            OPEN get_tabs (tablespace_nm, owner);
         END IF;

         LOOP
            FETCH get_tabs INTO table_nm;
            EXIT WHEN get_tabs%NOTFOUND;
            tab_cnt :=   tab_cnt
                       + 1;

            IF tab_cnt = 1
            THEN
               ln_txt :=    'echo '
                         || CHR (39)
                         || owner
                         || '.'
                         || table_nm
                         || CHR (39)
                         || '>>'
                         || tablespace_nm
                         || '.par';
            ELSE
               ln_txt :=    'echo '
                         || CHR (39)
                         || ', '
                         || owner
                         || '.'
                         || table_nm
                         || CHR (39)
                         || '>>'
                         || tablespace_nm
                         || '.par';
            END IF;

            row_cntr :=   row_cntr
                        + 1;
            insert_tab (file_no, row_cntr, ln_txt);
         END LOOP;

         CLOSE get_tabs;
      END LOOP;

      CLOSE get_owners;
      ln_txt :=
              'echo '
           || CHR (39)
           || ')'
           || CHR (39)
           || '>>'
           || tablespace_nm
           || '.par';
      row_cntr :=   row_cntr
                  + 1;
      insert_tab (file_no, row_cntr, ln_txt);

      /*
      Set file name for export file
      */
      SELECT    'echo '
             || CHR (39)
             || 'file='
             || tablespace_nm
             || '_'
             || TRUNC (SYSDATE)
             || '.dmp'
             || CHR (39)
             || '>>'
             || tablespace_nm
             || '.par'
        INTO ln_txt
        FROM DUAL;

      row_cntr :=   row_cntr
                  + 1;
      insert_tab (file_no, row_cntr, ln_txt);

      SELECT    'exp system/angler parfile='
             || tablespace_nm
             || '.par'
        INTO ln_txt
        FROM DUAL;

      row_cntr :=   row_cntr
                  + 1;
      insert_tab (file_no, row_cntr, ln_txt);

      SELECT    'compress '
             || tablespace_nm
             || '_'
             || TRUNC (SYSDATE)
             || '.dmp '
        INTO ln_txt
        FROM DUAL;

      row_cntr :=   row_cntr
                  + 1;
      insert_tab (file_no, row_cntr, ln_txt);
      file_no :=   file_no
                 + 1;

      <<end_loop>>
      NULL;
   END LOOP;

   CLOSE get_tbsp;
   COMMIT;
END;
/
SET heading off feedback off long 4000 lines 80 pages 0 verify off
SET recsep off embedded on echo off termout off
COLUMN file# noprint
COLUMN line_no noprint
COLUMN line_txt format a80 word_wrapped 
SPOOL rep_out\tbsp_exp.sh
SELECT   *
    FROM exp_temp
ORDER BY file#, line_no;
SPOOL off
SET heading on feedback on long 2000 lines 80 pages 22 verify on
SET recsep on embedded off echo off termout on
CLEAR columns
PROMPT  Tablespace Export Procedure completed.
