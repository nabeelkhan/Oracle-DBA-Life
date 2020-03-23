REM FILE NAME: 	Vms_oline_bu.sql  
REM LOCATION:   Backup Recovery\Hot Backup
REM FUNCTION:  	Hot VMS Backup  
REM PLATFORM:   non-specific
REM REQUIRES:   
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM

CREATE TABLE bu_temp (line_no NUMBER,line_txt VARCHAR2(2000)) TABLESPACE tools;
TRUNCATE TABLE bu_temp;
SET verify off embedded off
DEFINE dest_dir=&1;
COLUMN dup new_value dup_it noprint
SELECT    ''
       || CHR (39)
       || 'backup/ignore=(noback, interlock,label)/log '
       || CHR (39)
       || '' dup
  FROM DUAL;

DECLARE
   --
   -- Declare cursors
   --
   -- Cursor to get all tablespace names
   --
   CURSOR get_tbsp
   IS
      SELECT tablespace_name
        FROM dba_tablespaces;

   --
   -- cursor to create BEGIN BACKUP command
   --
   CURSOR bbu_com (tbsp VARCHAR2)
   IS
      SELECT    'alter tablespace '
             || tablespace_name
             || ' begin backup;'
        FROM dba_tablespaces
       WHERE tablespace_name = tbsp;

   --
   -- Cursor to create HOST backup commands
   --
   CURSOR bu_com (tbsp VARCHAR2)
   IS
      SELECT    'host '
             || &&dup_it
             || file_name
             || ' - '
             || CHR (10)
             || ' mua0:ora_'
             || tbsp
             || file_id
             || '.bck/sav'
        FROM dba_data_files
       WHERE tablespace_name = tbsp;

   --
   -- Cursor to create END BACKUP command
   --
   CURSOR ebu_com (tbsp VARCHAR2)
   IS
      SELECT    'alter tablespace '
             || tablespace_name
             || ' end backup;'
             || CHR (10)
        FROM dba_tablespaces
       WHERE tablespace_name = tbsp;

   --
   -- Cursor to create redo log HOST backup commands
   --
   CURSOR bu_rdo (num NUMBER)
   IS
      SELECT      'host '
               || &&dup_it
               || MEMBER
               || ' - '
               || CHR (10)
               || ' mua0:ora_redo'
               || SUBSTR (MEMBER,   INSTR (MEMBER, 'log', -1, 1)
                                  + 3, 2)
               || '.bck/sav'
          FROM v$logfile
      ORDER BY group#;

   --
   -- Temporary variable declarations
   --
   tbsp_name   VARCHAR2 (64);
   line_num    NUMBER          := 0;
   line_text   VARCHAR2 (2000);
   num         NUMBER          := 0;
--
-- Begin build of commands into temporary table
--
BEGIN
   --
   -- first, create script header
   --
   line_num :=   line_num
               + 1;

   SELECT    'REM Online Backup Script for '
          || NAME
          || ' instance'
     INTO line_text
     FROM v$database;

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   line_num :=   line_num
               + 1;

   SELECT 'REM Script uses OpenVMS format backup commands'
     INTO line_text
     FROM DUAL;

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   line_num :=   line_num
               + 1;

   SELECT    'REM created on '
          || TO_CHAR (SYSDATE, 'dd-mon-yyyy hh24:mi')
          || ' by user '
          || USER
     INTO line_text
     FROM DUAL;

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   line_num :=   line_num
               + 1;

   SELECT 'REM developed for TVA by Mike Ault - DMR Consulting Group 23-Jun-1998'
     INTO line_text
     FROM DUAL;

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   line_num :=   line_num
               + 1;

   SELECT 'REM Script expects to be fed backup directory location on execution.'
     INTO line_text
     FROM DUAL;

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   line_num :=   line_num
               + 1;

   SELECT 'REM Script should be re-run anytime physical structure of database altered.'
     INTO line_text
     FROM DUAL;

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   line_num :=   line_num
               + 1;

   SELECT 'REM '
     INTO line_text
     FROM DUAL;

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   line_num :=   line_num
               + 1;
   --
   -- Now get tablespace names and loop through until all are handled
   --
   OPEN get_tbsp;

   LOOP
      -- 
      -- Get name
      --
      FETCH get_tbsp INTO tbsp_name;
      EXIT WHEN get_tbsp%NOTFOUND;

      --
      -- Add comments to script showing which tablespace
      --
      SELECT 'REM'
        INTO line_text
        FROM DUAL;

      INSERT INTO bu_temp
           VALUES (line_num, line_text);

      line_num :=   line_num
                  + 1;

      SELECT    'REM Backup for tablespace '
             || tbsp_name
        INTO line_text
        FROM DUAL;

      INSERT INTO bu_temp
           VALUES (line_num, line_text);

      line_num :=   line_num
                  + 1;

      SELECT 'REM'
        INTO line_text
        FROM DUAL;

      INSERT INTO bu_temp
           VALUES (line_num, line_text);

      line_num :=   line_num
                  + 1;
      --
      -- Get begin backup command built for this tablespace
      --
      OPEN bbu_com (tbsp_name);
      FETCH bbu_com INTO line_text;

      INSERT INTO bu_temp
           VALUES (line_num, line_text);

      CLOSE bbu_com;
      --
      -- The actual backup commands are per datafile, open cursor and loop
      --
      OPEN bu_com (tbsp_name);

      LOOP
         FETCH bu_com INTO line_text;
         EXIT WHEN bu_com%NOTFOUND;
         line_num :=   line_num
                     + 1;

         INSERT INTO bu_temp
              VALUES (line_num, line_text);
      END LOOP;

      CLOSE bu_com;
      --
      -- Build end backup command for this tablespace
      --
      OPEN ebu_com (tbsp_name);
      FETCH ebu_com INTO line_text;

      INSERT INTO bu_temp
           VALUES (line_num, line_text);

      CLOSE ebu_com;
      line_num :=   line_num
                  + 1;

      SELECT ' '
        INTO line_text
        FROM DUAL;

      INSERT INTO bu_temp
           VALUES (line_num, line_text);
   END LOOP;

   CLOSE get_tbsp;

   --
   -- Backup redo logs, normally you won't recover redo logs you
   -- will use your current redo logs so current SCN information not lost
   -- commands just here for completeness
   --
   SELECT 'REM'
     INTO line_text
     FROM DUAL;

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   line_num :=   line_num
               + 1;

   SELECT 'REM Backup for redo logs'
     INTO line_text
     FROM DUAL;

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   line_num :=   line_num
               + 1;

   SELECT 'REM Normally you will not recover redo logs'
     INTO line_text
     FROM DUAL;

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   line_num :=   line_num
               + 1;

   SELECT 'REM'
     INTO line_text
     FROM DUAL;

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   line_num :=   line_num
               + 1;
   --
   -- Create host backup commands for all redo logs
   --
   OPEN bu_rdo (num);

   LOOP
      IF num = 3
      THEN
         num := 0;
      END IF;

      FETCH bu_rdo INTO line_text;
      EXIT WHEN bu_rdo%NOTFOUND;
      num :=   num
             + 1;
      line_num :=   line_num
                  + 1;

      INSERT INTO bu_temp
           VALUES (line_num, line_text);
   END LOOP;

   CLOSE bu_rdo;
   --
   -- Now get all archive logs, performing a switch to be sure all
   -- required archives are written out
   --
   line_num :=   line_num
               + 1;

   SELECT 'REM'
     INTO line_text
     FROM DUAL;

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   line_num :=   line_num
               + 1;

   SELECT 'REM Backup for archive logs'
     INTO line_text
     FROM DUAL;

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   line_num :=   line_num
               + 1;

   SELECT 'REM'
     INTO line_text
     FROM DUAL;

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   line_num :=   line_num
               + 1;

   SELECT 'alter system switch logfile;'
     INTO line_text
     FROM DUAL;

   line_num :=   line_num
               + 1;

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   line_num :=   line_num
               + 1;

   SELECT 'archive log all;'
     INTO line_text
     FROM DUAL;

   line_num :=   line_num
               + 1;

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   --
   -- The next command builds the actual backup command based on the 
   -- value of the log_archive_dest initialization parameter, it looks for the
   -- last right square bracket in the name and just uses that section with
   -- a wildcard
   --
   SELECT    'host '
          || &&dup_it
          || SUBSTR (VALUE, 1, INSTR (VALUE, ']', -1, 1))
          || '*/DELETE'
          || ' - '
          || CHR (10)
          || ' mua0:ora_archive.bck/sav'
     INTO line_text
     FROM v$parameter
    WHERE NAME = 'log_archive_dest';

   line_num :=   line_num
               + 1;

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   --
   -- Next, backup a control file just to be sure
   -- we have a good one available that is current with this backup
   -- 
   SELECT    'alter database backup control file to '
          || '&&dest_dir'
          || 'ora_conbackup.bac;'
     INTO line_text
     FROM DUAL;

   line_num :=   line_num
               + 1;

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   SELECT    'host '
          || &&dup_it
          || '&&dest_dir'
          || 'ora_conbackup.bac - '
          || CHR (10)
          || ' mua0:ora_control.bck/sav'
     INTO line_text
     FROM DUAL;

   line_num :=   line_num
               + 1;

   INSERT INTO bu_temp
        VALUES (line_num, line_text);
END;
/

REM
REM Now generate output based on bu_temp table contents
REM
SET verify off feedback off heading off termout off pages 0
SET embedded on lines 132
COLUMN line_no noprint
SPOOL rep_out/vms_bu.sql
SELECT   *
    FROM bu_temp
ORDER BY line_no;
SPOOL off
DROP TABLE bu_temp;
SET verify on feedback on heading on termout on pages 22
SET embedded off lines 80
CLEAR columns
UNDEF dest_dir
