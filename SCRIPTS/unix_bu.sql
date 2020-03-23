REM FILE NAME: 	unix_bu.sql
REM LOCATION:  	Backup Recovery\Hot Backup
REM FUNCTION:  	Hot Unix backup
REM REQUIRES:
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM
REM******************** Knowledge Xpert for Oracle Administration ********************
REM
REM NOTICES:  If the system is slow and the archive log switch doesn't complete before 
REM           the tar/compress of the archivelog directory you will have problems.
REM           This can make a backup UNRECOVERABLE.  We have added a sleep for 30 
REM           seconds, to make sure it had enough time to archive the redo logs. 
REM           This should be enough in most shops.
REM
REM           CAUTION should be exercised if you are using links to datafiles. The TAR
REM           command does NOT follow links, so all you will be backing up is the link 
REM           and NOT the datafiles!!!
REM
REM           We strongly recommend that you test a backup and recovery on your system 
REM           before you rely on this script. 
REM
REM***********************************************************************************
REM

CREATE TABLE bu_temp (line_no NUMBER,line_txt VARCHAR2(2000))
STORAGE (INITIAL 1m NEXT 1m PCTINCREASE 0);
TRUNCATE TABLE bu_temp;
SET verify off embedded off
DEFINE dest_dir=&1;
DECLARE
   rec_written       NUMBER          := 0;
   line_text_total   VARCHAR2 (2000);
   line_text_temp    VARCHAR2 (2000);

   
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
   CURSOR tar1_com (tbsp VARCHAR2)
   IS
      SELECT    ' &&dest_dir/temp.tar '
             || file_name
        FROM dba_data_files
       WHERE tablespace_name = tbsp;

   
-- and file_id=(select min(file_id) from dba_data_files
-- where tablespace_name=tbsp);

--
   CURSOR comp_com (tbsp VARCHAR2)
   IS
      SELECT    'host compress -c &&dest_dir/temp.tar>&&dest_dir/'
             || tablespace_name
             || '_'
             || TO_CHAR (SYSDATE, 'dd_mon_yy')
             || '.Z'
             || CHR (10)
        FROM dba_tablespaces
       WHERE tablespace_name = tbsp;

   
--
-- Cursor to create END BACKUP command
--
   CURSOR ebu_com (tbsp VARCHAR2)
   IS
      SELECT    'alter tablespace '
             || tablespace_name
             || ' end backup;'
        FROM dba_tablespaces
       WHERE tablespace_name = tbsp;

   
--
-- Cursor to create redo log HOST backup commands
--
--
   CURSOR tar2_rdo
   IS
      SELECT    ' '
             || MEMBER
             || ' '
        FROM v$logfile;

   
--
   CURSOR comp_rdo
   IS
      SELECT    'host compress -c  &&dest_dir/temp.tar>&&dest_dir/redo_logs_'
             || TO_CHAR (SYSDATE, 'dd_mon_yy')
             || '.Z'
             || CHR (10)
        FROM DUAL;

   
--
-- Temporary variable declarations
--
   tbsp_name         VARCHAR2 (64);
   line_num          NUMBER          := 0;
   line_text         VARCHAR2 (2000);
   min_value         NUMBER;
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

   SELECT 'REM Script uses UNIX tar format backup commands'
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

   SELECT 'REM developed for AGCO by Mike Ault - DMR Consulting Group 7-Oct-1998'
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

      line_num :=   line_num
                  + 1;
      CLOSE bbu_com;
      
--
-- The actual backup commands are per datafile, open cursor and loop
--
      OPEN tar1_com (tbsp_name);
      OPEN comp_com (tbsp_name);
      min_value := line_num;
      line_text := 'host /bin/tar -cvf ';

      LOOP
         FETCH tar1_com INTO line_text_temp;
         EXIT WHEN tar1_com%NOTFOUND;
         line_text :=    line_text
                      || line_text_temp;

         INSERT INTO bu_temp
              VALUES (line_num, line_text);

         line_text := 'host /bin/tar -uvf ';
      END LOOP;

      FETCH comp_com INTO line_text;

      INSERT INTO bu_temp
           VALUES (line_num, line_text);

      line_num :=   line_num
                  + 1;
      CLOSE tar1_com;
      CLOSE comp_com;
      
--
-- Build end backup command for this tablespace
--
      OPEN ebu_com (tbsp_name);
      FETCH ebu_com INTO line_text;

      INSERT INTO bu_temp
           VALUES (line_num, line_text);

      line_num :=   line_num
                  + 1;
      
/*  select 'host rm &&dest_dir/temp.tar '
  into line_text
  from dual;
  insert into bu_temp values (line_num,line_text);
  line_num:=line_num+1; */

      CLOSE ebu_com;
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
   OPEN tar2_rdo;
   OPEN comp_rdo;
   min_value := line_num;
   rec_written := 0;
   line_text := 'host /bin/tar -cvf &&dest_dir/temp.tar ';

   LOOP
      FETCH tar2_rdo INTO line_text_temp;
      EXIT WHEN tar2_rdo%NOTFOUND;
      line_text_total :=    line_text_total
                         || line_text;
      line_text :=    line_text
                   || line_text_temp;

      INSERT INTO bu_temp
           VALUES (line_num, line_text);

      line_text := 'host /bin/tar -uvf &&dest_dir/temp.tar ';
   END LOOP;

   FETCH comp_rdo INTO line_text;

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   line_text := NULL;
   line_num :=   line_num
               + 1;
   rec_written := 0;
   CLOSE tar2_rdo;
   CLOSE comp_rdo;

   
--
-- Now get all archive logs, performing a switch to be sure all
-- required archives are written out
--
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

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   line_num :=   line_num
               + 1;

   SELECT 'host sleep 30'
     INTO line_text
     FROM DUAL;

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   line_num :=   line_num
               + 1;

   
--  select 'archive log all;' into line_text from dual;
--  insert into bu_temp values (line_num,line_text);
--  line_num:=line_num+1;
--
-- The next command builds the actual backup command based on the
-- value of the log_archive_dest initialization parameter, it looks for the
-- last right square bracket in the name and just uses that section with
-- a wildcard
--
--  select 'host compress '||substr (value,1,instr(value,'/',-1,1))||'*'
   SELECT    'host tar -cvf &&dest_dir/arcs_tar_'
          || TO_CHAR (SYSDATE, 'dd_mon_yy')
          || '.tar '
          || VALUE
          || '*'
     INTO line_text
     FROM v$parameter
    WHERE NAME = 'log_archive_dest';

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   line_num :=   line_num
               + 1;

   SELECT 'host compress &&dest_dir/arcs*.tar '
     INTO line_text
     FROM v$parameter
    WHERE NAME = 'log_archive_dest';

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   line_num :=   line_num
               + 1;

   
--
-- Next, backup a control file just to be sure
-- we have a good one available that is current with this backup
--
   SELECT    'alter database backup controlfile to '''
          || '&&dest_dir'
          || '/ora_conbackup_'
          || TO_CHAR (SYSDATE, 'dd_mon_yy')
          || '.bac'';'
     INTO line_text
     FROM DUAL;

   INSERT INTO bu_temp
        VALUES (line_num, line_text);

   line_num :=   line_num
               + 1;
END;
/
REM
REM Now generate output based on bu_temp table contents
REM
SET verify off feedback off heading off termout off pages 0 trimspool on
SET embedded on lines 5500
COLUMN line_no noprint
COLUMN dbname new_value db noprint
SELECT NAME dbname
  FROM v$database;
SPOOL rep_out/unix_bu.sql
SELECT   *
    FROM bu_temp
ORDER BY line_no;
SPOOL off
REM directory syntax for UNIX
REM
REM host  sed '1,$ s/ *$//g' thot_bu.sql>unix_bu.sql
REM
DROP TABLE bu_temp;
SET verify on feedback on heading on termout on pages 22
SET embedded off lines 80
CLEAR columns
UNDEF dest_dir
