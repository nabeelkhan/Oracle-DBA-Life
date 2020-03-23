-- FILE NAME:  dbms_revealnet.sql
-- LOCATION:   Object Management\Tablespaces and DataFiles\Reports
-- FUNCTION:   Create various monitoring and utility procedures and functions
-- TESTED ON:  8.1.5, 8.1.7, 9.0.1
-- PLATFORM:   non-specific
-- REQUIRES:   The following created by crea_tab.sql script
--             DBA_TEMP
--             TEMP_SIZE_TABLE
--             HIT_RATIOS
--             DBA_RUNNING_STATS
--             REVEALNET_KEPT_OBJECTS
--             REVEALNET_UPDATE_TABLES
--             View: FREE_SPACE
--             View: ROLLBACK1
--             View: ROLLBACK2
--             View: SQL_SUMMARY
--             View: TRANS_PER_ROLLBACK
--             View: PROC_COUNT
--
-- Tables are used with statistics and redo_pin, and, update_tables, update_column
-- procedures for cascade updates.
--
--    This is a part of the Knowledge Xpert for Oracle Administration library. 
--  Copyright (C) 2001 Quest Software 
--  All rights reserved. 
-- 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM
-- 
CREATE OR REPLACE PACKAGE dbms_revealnet
AS
   
--
-- Function start_it is just a null function to load the package
--
   FUNCTION start_it
      RETURN NUMBER;

   
--
-- Function return_version returns the RDBMS version
--
   FUNCTION return_version
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (return_version, WNDS);

   
--
-- Procedure startup date returns a date value that is equivalent to the instance
-- statup date and time
--
   PROCEDURE startup_date (good_date OUT DATE);

   
--
-- Function change_role uses the dbms_sql package to allow dynamic reallocation
-- of a role during operation 
--
   PROCEDURE change_role (ROLE IN VARCHAR2, newpass IN VARCHAR2);

   
--
-- Function change_pwd uses the dbms_sql package to allow the user to
-- change passwords with a function call.
--
   PROCEDURE change_pwd (newpass IN VARCHAR2);

   
--
-- Procedure kill_session uses the dbms_sql package to issue a session kill
-- command against the specified session/serial number combination.
--
   PROCEDURE kill_session (session_id IN VARCHAR2, serial_num IN VARCHAR2);

   
--
-- Procedure just_statistics is similar to calculate_statistics but it returns
-- no object related data, just statistics.
--
   PROCEDURE just_statistics;

   
--
-- Function get_avble_bytes gets the total free bytes available in
-- all datafiles for the specified tablespace.
--
   FUNCTION get_avble_bytes (tbsp_name VARCHAR2)
      RETURN NUMBER;

   PRAGMA RESTRICT_REFERENCES (get_avble_bytes, WNDS);

   
--
-- Function get_start returns the integer byte position that the specified
-- column id would start at if a non-delimited flat file contained a record
-- identical to the table in structure. For use with SQLLOADER.
--
   FUNCTION get_start (tab_name VARCHAR2, col_id NUMBER)
      RETURN NUMBER;

   PRAGMA RESTRICT_REFERENCES (get_start, WNDS);

   
--
-- Function get_end returns the integer byte position that the specified
-- column id would end at if a non-delimited flat file contained a record
-- identical to the table in structure. For use with SQLLOADER
--
   FUNCTION get_end (tab_name VARCHAR2, col_id NUMBER)
      RETURN NUMBER;

   PRAGMA RESTRICT_REFERENCES (get_end, WNDS);

   
--
-- Function get_bytes returns the number of bytes allocated to all datafiles for
-- the specified tablespace. 
--
   FUNCTION get_bytes (tbsp_name VARCHAR2)
      RETURN NUMBER;

   PRAGMA RESTRICT_REFERENCES (get_bytes, WNDS);

   
--
-- Procedure get_count gets the row count for the specified table.
--
   PROCEDURE get_count (tab_name IN VARCHAR2, ROWS OUT NUMBER);

   
--
-- Next packages are used for cascade updates
--
-- First package is update_column
-- This package actually does the work
-- using DBMS_SQL to dynamically rebuild the 
-- UPDATEs at run time for each table
--
   PROCEDURE update_column (
      old_value       IN   VARCHAR2,
      new_value       IN   VARCHAR2,
      table_name      IN   VARCHAR2,
      update_column   IN   VARCHAR2
   );

   
--
-- Next procedure is update_tables
-- It is the loop control procedure for
-- the trigger and calls update_column
--
-- The calling trigger has to be of the form:
--
--    create or replace trigger cascade_update_<tabname>
--   after update of <column> on <table>      
--   referencing new as upd old as prev
--     for each row
--       begin
--    dbms_revealnet.update_tables('<table>',:prev.<column>,:upd.<column>);
--       end;
--
-- Note how the table name is passed to the procedure, this must be done.
--
   PROCEDURE update_tables (
      source_table   IN   VARCHAR2,
      old_value      IN   VARCHAR2,
      new_value      IN   VARCHAR2
   );

   
-- Procedure check_tables is used to check a given users tables to see if 
-- they have changed by 20%, if so 
-- they are analyzed, if not they aren't. Uses the get_count procedure.
--
   PROCEDURE check_tables (owner_name IN VARCHAR2);

   
--
-- Procedure redo_pin allows the user to set up a table of objects that should be pinned
-- in the shared pool. The procedure accesses the list to unpin/flush/repin the objects
-- this allows for changes in status monitoring to kick off a repin.
--
   PROCEDURE redo_pin;

   
--
--Procedure chk_pin checks the status of the objects in revealnet_kept_objects and if
-- it finds an invalid object issues a call to redo_pin.
--
   PROCEDURE chk_pin;

   
--
--Procedure running_stats inserts statistics on a predefined time schedule using dbms_jobs
--
   PROCEDURE running_stats (is_interactive IN BOOLEAN default false);

   
--
--Procedure flush_it used to periodically flush shared pool on ad-hoc systems
--
   PROCEDURE flush_it (p_free IN NUMBER);

   
-- Procedure hitratio calculates a periodic rather than cumulative hit ratio as well as usage 
-- and number of users and places the results in the hit_ratios table.
--
   PROCEDURE hitratio;

   
--
-- Function GEN_PWORD returns a 6 place password that is unique
--
   FUNCTION gen_pword
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (gen_pword, WNDS);

   
--
-- Procedure auto_defrag checks tablespaces for excessive fragmentation and 
-- issues the alter tablespace ...coalesce command to defrag as needed.
-- useful for when we have tablespace with pctincrease defined as zero
--
   PROCEDURE auto_defrag;
--
-- end of package header 
--
END dbms_revealnet;
/

CREATE OR REPLACE PACKAGE BODY dbms_revealnet
AS
   
--
--
   FUNCTION start_it
      RETURN NUMBER
   AS
      ret   NUMBER := 0;
   BEGIN
      NULL;
      RETURN ret;
   END start_it;

   
--
--
   FUNCTION return_version
      RETURN VARCHAR2
   AS
      CURSOR get_version
      IS
         SELECT banner
           FROM v$version
          WHERE banner LIKE '% 7.%'
             OR banner LIKE '% 8.%';

      version         VARCHAR2 (64);
      short_version   VARCHAR2 (9);
   BEGIN
      OPEN get_version;
      FETCH get_version INTO version;
      short_version := SUBSTR (version, 24, 9);
      RETURN short_version;
   END;

   
--
--
   PROCEDURE startup_date (good_date OUT DATE)
   AS
      jdate          DATE;
      startup_date   VARCHAR2 (32);
      version        VARCHAR2 (9);
      jsec           NUMBER;
      hr             VARCHAR2 (2);
      sec            VARCHAR2 (2);
      MINUTE         VARCHAR2 (2);
      show_date      DATE;
   BEGIN
      version := dbms_revealnet.return_version;

      IF SUBSTR (version, 1, 5) IN ('7.2.3', '7.3.0', '7.3.1', '7.3.2', '7.3.3')
      THEN
         BEGIN
            
/*
SELECT
TO_DATE(TO_NUMBER(value,'99999999'),'J')
  INTO
jdate
  FROM
   v$instance
  WHERE
   key='STARTUP TIME - JULIAN';
 SELECT
   (TO_NUMBER(value,'9999999'))
  INTO
   jsec
  FROM
   v$instance
  WHERE
   key='STARTUP TIME - SECONDS';
 hr:=TO_CHAR(TRUNC(jsec/3600,0));
 minute:= TO_CHAR(TRUNC(((jsec/3600)-hr)*60,0));
 sec:= TO_CHAR(TRUNC((((((jsec/3600)-hr)*60)-minute)*60),0));
 IF length(hr)=1 THEN
   hr:='0'||hr;
END IF;
IF length(minute)=0 THEN
   minute:='0'||minute;
END IF;
IF length(sec)=1 THEN
   sec:='0'||sec;
END IF;
startup_date:=jdate||' '||hr||':'||minute||':'||sec;
dbms_output.put_line('date:'||startup_date);
good_date := TO_DATE(startup_date, 'dd-mon-yy hh24:mi:ss');
show_date := TO_DATE(startup_date, 'dd-mon-yy hh24:mi:ss');
dbms_output.put_line('date:'||to_char(show_date, 'dd-mon-yy hh24:mi:ss'));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
 dbms_output.put_line('Startup Date: unknown');
*/
            NULL;
         END;
      ELSE
         NULL;

         SELECT startup_time
           INTO jdate
           FROM v$instance;

         good_date := jdate;
      END IF;
   END;

   
--
--
   PROCEDURE change_role (ROLE IN VARCHAR2, newpass IN VARCHAR2)
   AS
      p_password    VARCHAR2 (32)  := newpass;
      p_role        VARCHAR (32)   := ROLE;
      no_of_rows    NUMBER;
      cursor_name   INTEGER;
      sqlstmt       VARCHAR2 (300);
   
--
   BEGIN
      cursor_name := DBMS_SQL.open_cursor;
      sqlstmt :=    'BEGIN dbms_session.set_role('
                 || CHR (39)
                 || p_role
                 || ' IDENTIFIED BY '
                 || p_password
                 || CHR (39)
                 || '); END;';
      DBMS_OUTPUT.put_line (sqlstmt);
      DBMS_SQL.parse (cursor_name, sqlstmt, DBMS_SQL.v7);
      no_of_rows := DBMS_SQL.EXECUTE (cursor_name);
      DBMS_SQL.close_cursor (cursor_name);
   END;

   
--
--
   PROCEDURE change_pwd (newpass IN VARCHAR2)
   AS
      p_user        VARCHAR2 (32);
      p_password    VARCHAR2 (32)  := newpass;
      no_of_rows    NUMBER;
      cursor_name   INTEGER;
      sqlstmt       VARCHAR2 (300);
   
--
   BEGIN
      SELECT USER
        INTO p_user
        FROM DUAL;

      cursor_name := DBMS_SQL.open_cursor;
      sqlstmt :=
                 'ALTER USER '
              || p_user
              || ' IDENTIFIED BY '
              || p_password
              || ';';
      DBMS_OUTPUT.put_line (sqlstmt);
      DBMS_SQL.parse (cursor_name, sqlstmt, DBMS_SQL.v7);
      no_of_rows := DBMS_SQL.EXECUTE (cursor_name);
      DBMS_SQL.close_cursor (cursor_name);
   END;

   
--
--
   PROCEDURE kill_session (session_id IN VARCHAR2, serial_num IN VARCHAR2)
   AS
      cur      INTEGER;
      ret      INTEGER;
      STRING   VARCHAR2 (100);
   
--
   BEGIN
      STRING :=    'ALTER SYSTEM KILL SESSION '
                || ''''
                || session_id
                || ','
                || serial_num
                || '''';
      cur := DBMS_SQL.open_cursor;
      DBMS_SQL.parse (cur, STRING, DBMS_SQL.v7);
      ret := DBMS_SQL.EXECUTE (cur);
      DBMS_SQL.close_cursor (cur);
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20001, 'Error IN execution', TRUE);

         IF DBMS_SQL.is_open (cur)
         THEN
            DBMS_SQL.close_cursor (cur);
         END IF;
   END;

   
--
--
/* PROCEDURE: PLSQL Procedure just_statistics used by do_calst.sql*/
   PROCEDURE just_statistics
   AS
      start_date   DATE;
      dd_ratio     NUMBER        := 0;
      r_calls      NUMBER        := 0;
      h_ratio      NUMBER        := 0;
      suhw_cont    NUMBER        := 0;
      subw_cont    NUMBER        := 0;
      uhw_cont     NUMBER        := 0;
      ubw_cont     NUMBER        := 0;
      db_gets      NUMBER        := 0;
      con_gets     NUMBER        := 0;
      p_reads      NUMBER        := 0;
      suh_waits    NUMBER        := 0;
      sub_waits    NUMBER        := 0;
      uh_waits     NUMBER        := 0;
      ub_waits     NUMBER        := 0;
      u_calls      NUMBER        := 0;
      calls_u      NUMBER        := 0;
      rlog_wait    NUMBER        := 0;
      stat_name    VARCHAR2 (64);
      temp_name    VARCHAR2 (64);
      stat_val     NUMBER        := 0;
      temp_value   NUMBER        := 0;
      version      VARCHAR2 (9);

      
--
      CURSOR get_contend1
      IS
         SELECT CLASS, waits
           FROM contend
          WHERE waits > 0;

      
--
      CURSOR get_contend2
      IS
         SELECT CLASS, elapsed_time
           FROM contend
          WHERE waits > 0;

      
--
--
      CURSOR get_latch
      IS
         SELECT a.NAME, 100. * b.sleeps / b.gets
           FROM v$latchname a, v$latch b
          WHERE a.latch# = b.latch# AND b.sleeps > 0;

      
--
      CURSOR get_totals
      IS
         SELECT   object_type, COUNT (*)
             FROM dba_objects
            WHERE owner NOT IN ('SYS', 'SYSTEM')
         GROUP BY object_type
         ORDER BY object_type;

      
--
      CURSOR get_stat (stat IN VARCHAR2)
      IS
         SELECT NAME, VALUE
           FROM v$sysstat
          WHERE NAME = stat;

      
--
      CURSOR get_count (stat IN VARCHAR2)
      IS
         SELECT CLASS, "COUNT"
           FROM v$waitstat
          WHERE CLASS = stat_name;

      
--
      CURSOR get_good
      IS
         SELECT   AVG (
                     b.good / (  b.good
                               + a.garbage
                              )
                  )
                * 100
           FROM sql_garbage a, sql_garbage b
          WHERE a.users = b.users
            AND a.garbage IS NOT NULL
            AND b.good IS NOT NULL;

      
--
      PROCEDURE write_one (
         name_text   IN   VARCHAR2,
         stat_val    IN   NUMBER,
         rep_order   IN   INTEGER
      )
      IS
      BEGIN
         INSERT INTO dba_temp
              VALUES (name_text, stat_val, rep_order);
      END write_one;
   
--
   BEGIN
      DELETE      dba_temp;

      BEGIN
         dbms_revealnet.startup_date (start_date);

         IF start_date IS NOT NULL
         THEN
            stat_name :=    'Startup Date: '
                         || TO_CHAR (start_date, 'dd-mon-yy hh24:mi:ss');
            write_one (stat_name, 0, 1);
         ELSE
            stat_name := 'Startup Date: unknown';
            write_one (stat_name, 0, 1);
         END IF;
      END;

      BEGIN
         stat_name := 'recursive calls';
         OPEN get_stat (stat_name);
         FETCH get_stat INTO temp_name, r_calls;
         CLOSE get_stat;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            CLOSE get_stat;
      END;

      BEGIN
         stat_name := 'Data Dictionary Miss Percent';

         SELECT stat_name,   (SUM (getmisses) / SUM (gets))
                           * 100
           INTO temp_name, dd_ratio
           FROM v$rowcache;

         write_one (stat_name, dd_ratio, 17);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_one (stat_name, 0, 17);
            COMMIT;
      END;

      BEGIN
         stat_name := 'user calls';
         OPEN get_stat (stat_name);
         FETCH get_stat INTO temp_name, u_calls;
         CLOSE get_stat;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            CLOSE get_stat;
      END;

      BEGIN
         stat_name := 'db block gets';
         OPEN get_stat (stat_name);
         FETCH get_stat INTO temp_name, db_gets;
         CLOSE get_stat;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            CLOSE get_stat;
      END;

      BEGIN
         stat_name := 'consistent gets';
         OPEN get_stat (stat_name);
         FETCH get_stat INTO temp_name, con_gets;
         CLOSE get_stat;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            CLOSE get_stat;
      END;

      BEGIN
         stat_name := 'physical reads';
         OPEN get_stat (stat_name);
         FETCH get_stat INTO temp_name, p_reads;
         CLOSE get_stat;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            CLOSE get_stat;
      END;

      BEGIN
         stat_name := 'system undo header';
         OPEN get_count (stat_name);
         FETCH get_count INTO temp_name, suh_waits;
         CLOSE get_count;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            CLOSE get_count;
      END;

      BEGIN
         stat_name := 'system undo block';
         OPEN get_count (stat_name);
         FETCH get_count INTO temp_name, sub_waits;
         CLOSE get_count;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            CLOSE get_count;
      END;

      BEGIN
         stat_name := 'undo header';
         OPEN get_count (stat_name);
         FETCH get_count INTO temp_name, uh_waits;
         CLOSE get_count;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            CLOSE get_count;
      END;

      BEGIN
         stat_name := 'undo block';
         OPEN get_count (stat_name);
         FETCH get_count INTO temp_name, ub_waits;
         CLOSE get_count;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            CLOSE get_count;
      END;

      BEGIN
         calls_u := (r_calls / u_calls);
         h_ratio :=
                ((  db_gets
                  + con_gets
                 ) / (  db_gets
                      + con_gets
                      + p_reads
                     )
                );
         suhw_cont := (suh_waits / (  db_gets
                                    + con_gets
                                   ) * 100
                      );
         subw_cont := (sub_waits / (  db_gets
                                    + con_gets
                                   ) * 100
                      );
         uhw_cont := (uh_waits / (  db_gets
                                  + con_gets
                                 ) * 100
                     );
         ubw_cont := (ub_waits / (  db_gets
                                  + con_gets
                                 ) * 100
                     );
         stat_name := 'RECURSIVE CALLS PER USER';
         write_one (stat_name, calls_u, 18);
         stat_name := 'CUMMULATIVE HIT RATIO';
         write_one (stat_name, h_ratio, 2);
         stat_name := 'SYS UNDO HDR WAIT CONTENTION';
         write_one (stat_name, suhw_cont, 3);
         stat_name := 'SYS UNDO BLK WAIT CONTENTION';
         write_one (stat_name, subw_cont, 3);
         stat_name := 'UNDO HDR WAIT CONTENTION';
         write_one (stat_name, uhw_cont, 3);
         stat_name := 'UNDO BLK WAIT CONTENTION';
         write_one (stat_name, ubw_cont, 3);
         stat_name := 'freelist';
         OPEN get_count (stat_name);
         FETCH get_count INTO temp_name, stat_val;
         CLOSE get_count;
         stat_name := 'Free List Contention Ratio';
         write_one (stat_name, stat_val / (  db_gets
                                           + con_gets
                                          ), 18);
      EXCEPTION
         WHEN ZERO_DIVIDE
         THEN
            write_one (stat_name, 0, 32);
            CLOSE get_count;
            COMMIT;
         WHEN NO_DATA_FOUND
         THEN
            write_one (stat_name, 0, 32);
            CLOSE get_count;
            COMMIT;
      END;

      
/* If post 7.2 uncomment this next block */
      BEGIN
         version := dbms_revealnet.return_version;

         IF SUBSTR (version, 1, 5) IN ('7.2.3',
                                       '7.3.0',
                                       '7.3.1',
                                       '7.3.2',
                                       '7.3.3',
                                       '7.3.4',
                                       '8.0.4',
                                       '8.0.5'
                                      )
         THEN
            stat_name := 'Latch Miss%';

            SELECT (  1
                    -   (  (  SUM (sleeps)
                            + SUM (immediate_misses)
                           )
                         / (  SUM (gets)
                            + SUM (immediate_misses)
                            + SUM (immediate_gets)
                           )
                        )
                      * 100
                   )
              INTO stat_val
              FROM v$latch;

            write_one (stat_name, stat_val, 4);
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_one (stat_name, 0, 4);
            COMMIT;
      END;

      BEGIN
         stat_name := 'Rollback Wait %';

         SELECT (SUM (waits) / SUM (gets)) * 100
           INTO stat_val
           FROM v$rollstat;

         write_one (stat_name, stat_val, 5);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_one (stat_name, 0, 5);
            COMMIT;
      END;

      BEGIN
         stat_name := 'Library Reload %';

         SELECT SUM (reloads) / SUM (pins) * 100
           INTO stat_val
           FROM v$librarycache;

         write_one (stat_name, stat_val, 5);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_one (stat_name, 0, 5);
            COMMIT;
      END;

      BEGIN
         stat_name := 'table fetch by rowid';
         OPEN get_stat (stat_name);
         FETCH get_stat INTO temp_name, stat_val;
         CLOSE get_stat;
         write_one (stat_name, stat_val, 9);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_one (stat_name, 0, 9);
            CLOSE get_stat;
            COMMIT;
      END;

      BEGIN
         stat_name := 'Non-Index Lookups Ratio';

         SELECT a.VALUE / (  a.VALUE
                           + b.VALUE
                          )
           INTO stat_val
           FROM v$sysstat a, v$sysstat b
          WHERE a.NAME = 'table scans (long tables)'
            AND b.NAME = 'table scans (short tables)';

         write_one (stat_name, stat_val, 8);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_one (stat_name, 0, 8);
            CLOSE get_stat;
            COMMIT;
      END;

      BEGIN
         stat_name := 'table fetch continued row';
         OPEN get_stat (stat_name);
         FETCH get_stat INTO temp_name, stat_val;
         CLOSE get_stat;
         write_one (stat_name, stat_val, 14);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_one (stat_name, 0, 14);
            CLOSE get_stat;
            COMMIT;
      END;

      BEGIN
         stat_name := 'sorts (memory)';
         OPEN get_stat (stat_name);
         FETCH get_stat INTO temp_name, stat_val;
         CLOSE get_stat;
         write_one (stat_name, stat_val, 15);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_one (stat_name, 0, 15);
            CLOSE get_stat;
            COMMIT;
      END;

      BEGIN
         stat_name := 'sorts (disk)';
         OPEN get_stat (stat_name);
         FETCH get_stat INTO temp_name, stat_val;
         CLOSE get_stat;
         write_one (stat_name, stat_val, 16);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_one (stat_name, 0, 16);
            CLOSE get_stat;
            COMMIT;
      END;

      BEGIN
         stat_name := 'redo log space requests';
         OPEN get_stat (stat_name);
         FETCH get_stat INTO temp_name, stat_val;
         CLOSE get_stat;
         write_one (stat_name, stat_val, 6);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_one (stat_name, 0, 6);
            CLOSE get_stat;
            COMMIT;
      END;

      BEGIN
         stat_name := 'redo log space wait time';
         OPEN get_stat (stat_name);
         FETCH get_stat INTO temp_name, stat_val;
         CLOSE get_stat;
         write_one (stat_name, stat_val, 6);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_one (stat_name, 0, 6);
            CLOSE get_stat;
            COMMIT;
      END;

      BEGIN
         stat_name := 'TOTAL ALLOCATED MEG';

         SELECT SUM (bytes) / 1048576
           INTO stat_val
           FROM dba_data_files
          WHERE status = 'AVAILABLE';

         write_one (stat_name, stat_val, 25);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_one (stat_name, 0, 25);
            COMMIT;
      END;

      BEGIN
         stat_name := 'TOTAL USED MEG';

         SELECT SUM (bytes) / 1048576
           INTO stat_val
           FROM dba_extents;

         write_one (stat_name, stat_val, 26);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_one (stat_name, 0, 26);
            COMMIT;
      END;

      BEGIN
         stat_name := 'TOTAL SGA SIZE';

         SELECT stat_name, SUM (b.VALUE)
           INTO temp_name, stat_val
           FROM v$sga b;

         write_one (stat_name, stat_val, 31);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_one (stat_name, 0, 31);
            COMMIT;
      END;

      BEGIN
         stat_name := 'Shared Pool Used';

         SELECT SUM (bytes) / 1048576
           INTO stat_val
           FROM v$sgastat
          WHERE NAME IN ('reserved stopper',
                         'table definiti',
                         'dictionary cache',
                         'library cache',
                         'sql area',
                         'PL/SQL DIANA',
                         'SEQ S.O.'
                        );

         write_one (stat_name, stat_val, 37);
         COMMIT;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_one (stat_name, 0, 37);
            COMMIT;
      END;

      BEGIN
         stat_name := 'Shared Pool Available';

         SELECT ((  MAX (b.VALUE)
                  - SUM (a.bytes)
                 ) / (1024 * 1024)
                )
           INTO stat_val
           FROM v$sgastat a, v$parameter b
          WHERE a.NAME IN ('reserved stopper',
                           'table definiti',
                           'dictionary cache',
                           'library cache',
                           'sql area',
                           'PL/SQL DIANA',
                           'SEQ S.O.'
                          )
            AND b.NAME = 'shared_pool_size';

         write_one (stat_name, stat_val, 37);
         COMMIT;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_one (stat_name, 0, 37);
            COMMIT;
      END;

      BEGIN
         stat_name := 'Shared SQL%';
         OPEN get_good;
         FETCH get_good INTO stat_val;
         write_one (stat_name, stat_val, 37);
         CLOSE get_good;
         COMMIT;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_one (stat_name, 0, 37);
            COMMIT;
      END;

      BEGIN
         OPEN get_latch;

         LOOP
            FETCH get_latch INTO stat_name, stat_val;
            EXIT WHEN get_latch%NOTFOUND;
            write_one (stat_name, stat_val, 33);
         END LOOP;

         CLOSE get_latch;
         COMMIT;
      END;

      BEGIN
         OPEN get_contend1;

         LOOP
            FETCH get_contend1 INTO stat_name, stat_val;
            EXIT WHEN get_contend1%NOTFOUND;
            write_one (   stat_name
                       || ' waits', stat_val, 36);
         END LOOP;

         CLOSE get_contend1;
         COMMIT;
      END;

      BEGIN
         OPEN get_contend2;

         LOOP
            FETCH get_contend2 INTO stat_name, stat_val;
            EXIT WHEN get_contend2%NOTFOUND;
            write_one (   stat_name
                       || ' time', stat_val, 36);
         END LOOP;

         CLOSE get_contend2;
         COMMIT;
      END;

      BEGIN
         OPEN get_totals;

         LOOP
            FETCH get_totals INTO stat_name, stat_val;
            EXIT WHEN get_totals%NOTFOUND;
            write_one (stat_name, stat_val, 34);
         END LOOP;

         CLOSE get_totals;
         COMMIT;
      END;

      COMMIT;
   END;

   
--
--
   FUNCTION get_avble_bytes (tbsp_name VARCHAR2)
      RETURN NUMBER
   AS
      tbsp_avail   NUMBER;
   BEGIN
      SELECT SUM (bytes)
        INTO tbsp_avail
        FROM dba_free_space
       WHERE tablespace_name = tbsp_name;

      RETURN tbsp_avail;
   END;

   
--
--
   FUNCTION get_start (tab_name VARCHAR2, col_id NUMBER)
      RETURN NUMBER
   AS
      start_val   NUMBER;
   BEGIN
      IF col_id = 1
      THEN
         start_val := 1;
      ELSE
         SELECT   SUM (NVL (data_precision, data_length))
                + 1
           INTO start_val
           FROM dba_tab_columns
          WHERE table_name = tab_name AND column_id < col_id;
      END IF;

      RETURN start_val;
   END;

   
--
--   
   FUNCTION get_end (tab_name VARCHAR2, col_id NUMBER)
      RETURN NUMBER
   AS
      end_val   NUMBER;
   BEGIN
      SELECT SUM (NVL (data_precision, data_length))
        INTO end_val
        FROM dba_tab_columns
       WHERE table_name = tab_name AND column_id <= col_id;

      RETURN end_val;
   END;

   
--
--  
   FUNCTION get_bytes (tbsp_name VARCHAR2)
      RETURN NUMBER
   AS
      tbsp_size   NUMBER;
   BEGIN
      SELECT SUM (bytes)
        INTO tbsp_size
        FROM dba_data_files
       WHERE tablespace_name = tbsp_name AND status = 'AVAILABLE';

      RETURN tbsp_size;
   END;

   
--
--
   PROCEDURE get_count (tab_name IN VARCHAR2, ROWS OUT NUMBER)
   AS
      cur          INTEGER;
      ret          INTEGER;
      com_string   VARCHAR2 (100);
      row_count    NUMBER;
   BEGIN
      com_string :=    'SELECT count(1) row_count FROM '
                    || tab_name;
      cur := DBMS_SQL.open_cursor;
      DBMS_SQL.parse (cur, com_string, DBMS_SQL.v7);
      DBMS_SQL.define_column (cur, 1, row_count);
      ret := DBMS_SQL.EXECUTE (cur);
      ret := DBMS_SQL.fetch_rows (cur);
      DBMS_SQL.column_value (cur, 1, row_count);
      DBMS_SQL.close_cursor (cur);
      DBMS_OUTPUT.put_line (   'Count='
                            || TO_CHAR (row_count));
      ROWS := row_count;
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END;

   
--
--                                                                               
   PROCEDURE update_column (
      old_value       IN   VARCHAR2,
      new_value       IN   VARCHAR2,
      table_name      IN   VARCHAR2,
      update_column   IN   VARCHAR2
   )
   AS
      
--
-- define state variables for dbms_sql procedures
--
      cur              INTEGER;
      rows_processed   INTEGER;
   
--
-- start processing
-- (dbms_output calls are for debugging
-- commented out during normal runtime)
--
   BEGIN
      
-- dbms_output.put_line('Table name: '||table_name||' Column: '||update_column);
   -- 
   -- initialize the dynamic cursor location for 
   -- the dbms_sql process
   --
      cur := DBMS_SQL.open_cursor;
      
   --
   -- populate the initialized location with the statement to be
   -- processed
   --
-- DBMS_OUTPUT.PUT_LINE(
-- 'UPDATE '||table_name||' SET '||update_column||'='||chr(39)||new_value||chr(39)||chr(10)||
-- ' WHERE '||update_column||'='||chr(39)||old_value||chr(39)||'AND 1=1');
   --
      DBMS_SQL.parse (
         cur,
            'UPDATE '
         || table_name
         || ' SET '
         || update_column
         || '='
         || CHR (39)
         || new_value
         || CHR (39)
         || CHR (10)
         || ' WHERE '
         || update_column
         || '='
         || CHR (39)
         || old_value
         || CHR (39)
         || 'AND 1=1',
         DBMS_SQL.v7
      );
      -- 
      -- execute the dynamically parsed statement
      --
      rows_processed := DBMS_SQL.EXECUTE (cur);
      --
      -- close dynamic cursor to prepare for next table
      --
      DBMS_SQL.close_cursor (cur);
   
-- 
-- end procedure
--
   END update_column;

   PROCEDURE update_tables (
      source_table   IN   VARCHAR2,
      old_value      IN   VARCHAR2,
      new_value      IN   VARCHAR2
   )
   AS
      
--
-- Create the cursor to read records
-- from revealnet_update_tables
-- Use * to prohibit missing a column
--
      CURSOR get_table_name
      IS
         SELECT *
           FROM revealnet_update_tables
          WHERE main_table = source_table;

      
--
-- Define rowtype variable to hold record from
-- revealnet_upd_tables. Use rowtype to allow for
-- future changes.
--
      update_rec   revealnet_update_tables%ROWTYPE;
   
--
-- start processing
--
   BEGIN
      
--
-- Open and fetch values with cursor
--
      OPEN get_table_name;
      FETCH get_table_name INTO update_rec;

      
-- 
-- now that cursor status is open and values in 
-- variables can begin loop
--
      LOOP
         
--
-- using the notfound status we had to pre-populate
-- record
--
         EXIT WHEN get_table_name%NOTFOUND;
         
--
-- Initiate call to the update_column procedure
--
         dbms_revealnet.update_column (
            old_value,
            new_value,
            update_rec.table_name,
            update_rec.column_name
         );
         
-- 
-- Now get next record from table
--
         FETCH get_table_name INTO update_rec;
      
--
-- processing returns to loop statement
--
      END LOOP;

      
--
-- close cursor and exit
--
      CLOSE get_table_name;
   
--
-- end of procedure
--
   END update_tables;

   
--
--
   PROCEDURE check_tables (owner_name IN VARCHAR2)
   AS
      
--
      CURSOR get_tab_count (own VARCHAR2)
      IS
         SELECT table_name, NVL (num_rows, 1)
           FROM dba_tables
          WHERE owner = UPPER (own);

      
--
      tab_name     VARCHAR2 (64);
      ROWS         NUMBER;
      STRING       VARCHAR2 (255);
      cur          INTEGER;
      ret          INTEGER;
      row_count    NUMBER;
      com_string   VARCHAR2 (255);

      
--
      PROCEDURE write_out (
         par_name    IN   VARCHAR2,
         par_value   IN   NUMBER,
         rep_ord     IN   NUMBER,
         m_date      IN   DATE,
         par_delta   IN   NUMBER
      )
      IS
      BEGIN
         INSERT INTO dba_running_stats
              VALUES (par_name, par_value, rep_ord, m_date, par_delta);
      END;
   
--
   BEGIN
      DBMS_SESSION.set_close_cached_open_cursors (TRUE);
      OPEN get_tab_count (owner_name);

      LOOP
         BEGIN
            FETCH get_tab_count INTO tab_name, ROWS;
            tab_name :=    owner_name
                        || '.'
                        || tab_name;

            IF ROWS = 0
            THEN
               ROWS := 1;
            END IF;

            EXIT WHEN get_tab_count%NOTFOUND;
            DBMS_OUTPUT.put_line (
                  'Table name: '
               || tab_name
               || ' rows: '
               || TO_CHAR (ROWS)
            );
            dbms_revealnet.get_count (tab_name, row_count);

            IF row_count = 0
            THEN
               row_count := 1;
            END IF;

            DBMS_OUTPUT.put_line (
                  'Row count for '
               || tab_name
               || ': '
               || TO_CHAR (row_count)
            );
            DBMS_OUTPUT.put_line (   'Ratio: '
                                  || TO_CHAR (row_count / ROWS));

            IF    (row_count / ROWS) > 1.1
               OR (ROWS / row_count) > 1.1
            THEN
               BEGIN
                  IF (row_count < 10000)
                  THEN
                     STRING :=    'ANALYZE TABLE '
                               || tab_name
                               || ' COMPUTE STATISTICS ';
                  ELSE
                     STRING :=    'ANALYZE TABLE '
                               || tab_name
                               || ' ESTIMATE STATISTICS SAMPLE 30 PERCENT';
                  END IF;

                  cur := DBMS_SQL.open_cursor;
                  DBMS_OUTPUT.put_line ('Beginning analysis');
                  DBMS_SQL.parse (cur, STRING, DBMS_SQL.v7);
                  ret := DBMS_SQL.EXECUTE (cur);
                  DBMS_SQL.close_cursor (cur);
                  DBMS_OUTPUT.put_line (
                        ' Table: '
                     || tab_name
                     || ' had to be analyzed.'
                  );
                  write_out (
                        ' Table: '
                     || tab_name
                     || ' had to be analyzed.',
                     row_count / ROWS,
                     33,
                     SYSDATE,
                     0
                  );
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     raise_application_error (
                        -20002,
                           'Error in analyze: '
                        || TO_CHAR (SQLCODE)
                        || ' on '
                        || tab_name,
                        TRUE
                     );
                     write_out (
                           ' Table: '
                        || tab_name
                        || ' error during analyze. '
                        || TO_CHAR (SQLCODE),
                        row_count / ROWS,
                        33,
                        SYSDATE,
                        0
                     );

                     IF DBMS_SQL.is_open (cur)
                     THEN
                        DBMS_SQL.close_cursor (cur);
                     END IF;
               END;
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL;
         END;

         COMMIT;
      END LOOP;

      CLOSE get_tab_count;
   END;

   
--
--
   PROCEDURE redo_pin
   AS
      com         VARCHAR2 (100);
      com_cur     INTEGER;
      processed   INTEGER;
      i           BINARY_INTEGER := 1;
      j           BINARY_INTEGER := 0;

      TYPE objects IS TABLE OF revealnet_kept_objects.object_name%TYPE
         INDEX BY BINARY_INTEGER;

      OBJECT      objects;

      
--
--
      CURSOR get_objects
      IS
         SELECT object_name
           FROM revealnet_kept_objects;
   BEGIN
      OPEN get_objects;
      FETCH get_objects INTO OBJECT (i);

      LOOP
         EXIT WHEN get_objects%NOTFOUND;
         DBMS_OUTPUT.put_line (   'UNKEEPING: '
                               || OBJECT (i));
         DBMS_SHARED_POOL.unkeep (OBJECT (i));
         i :=   i
              + 1;
         FETCH get_objects INTO OBJECT (i);
      END LOOP;

      CLOSE get_objects;
      com_cur := DBMS_SQL.open_cursor;
      com := 'ALTER SYSTEM FLUSH SHARED_POOL';
      DBMS_SQL.parse (com_cur, com, DBMS_SQL.v7);
      processed := DBMS_SQL.EXECUTE (com_cur);
      COMMIT;
      processed := DBMS_SQL.EXECUTE (com_cur);
      DBMS_SQL.close_cursor (com_cur);
      COMMIT;
      i :=   i
           - 1;

      FOR j IN 1 .. i
      LOOP
         IF OBJECT (j) IS NOT NULL
         THEN
            DBMS_OUTPUT.put_line (   'KEPT: '
                                  || OBJECT (j));
            DBMS_SHARED_POOL.KEEP (OBJECT (j));
         ELSE
            EXIT;
         END IF;
      END LOOP;
   END;

   
--
--
   PROCEDURE chk_pin
   AS
      object_name     revealnet_kept_objects.object_name%TYPE;
      object_status   dba_objects.status%TYPE;
      temp_name       revealnet_kept_objects.object_name%TYPE;

      CURSOR get_status (NAME VARCHAR2)
      IS
         SELECT status
           FROM dba_objects
          WHERE object_name = NAME
            AND object_type IN ('PACKAGE', 'PACKAGE BODY', 'PROCEDURE');

      
--
      CURSOR get_objects
      IS
         SELECT object_name
           FROM revealnet_kept_objects;
   
--
   BEGIN
      OPEN get_objects;
      FETCH get_objects INTO object_name;

      LOOP
         EXIT WHEN get_objects%NOTFOUND;
         temp_name := SUBSTR (object_name,   INSTR (object_name, '.')
                                           + 1);
         OPEN get_status (temp_name);
         FETCH get_status INTO object_status;

         LOOP
            EXIT WHEN get_status%NOTFOUND;
            DBMS_OUTPUT.put_line (
                  RTRIM (object_name)
               || ' '
               || object_status
            );

            IF object_status = 'INVALID'
            THEN
               dbms_revealnet.redo_pin;
               EXIT;
            END IF;

            FETCH get_status INTO object_status;
         END LOOP;

         CLOSE get_status;

         IF object_status = 'INVALID'
         THEN
            EXIT;
         END IF;

         FETCH get_objects INTO object_name;
      END LOOP;

      CLOSE get_objects;
   END;

   
--
--
   PROCEDURE running_stats (is_interactive IN BOOLEAN DEFAULT FALSE)
   AS
      start_date   DATE;
      meas_date    DATE;
      comp_date    DATE;
      dd_ratio     NUMBER        := 0;
      r_calls      NUMBER        := 0;
      h_ratio      NUMBER        := 0;
      suhw_cont    NUMBER        := 0;
      subw_cont    NUMBER        := 0;
      uhw_cont     NUMBER        := 0;
      ubw_cont     NUMBER        := 0;
      db_gets      NUMBER        := 0;
      con_gets     NUMBER        := 0;
      p_reads      NUMBER        := 0;
      suh_waits    NUMBER        := 0;
      sub_waits    NUMBER        := 0;
      uh_waits     NUMBER        := 0;
      ub_waits     NUMBER        := 0;
      u_calls      NUMBER        := 0;
      calls_u      NUMBER        := 0;
      rlog_wait    NUMBER        := 0;
      stat_name    VARCHAR2 (64);
      temp_name    VARCHAR2 (64);
      stat_val     NUMBER        := 0;
      temp_value   NUMBER        := 0;
      version      VARCHAR2 (9);
      delta        NUMBER        := 0;

      
--
      CURSOR get_contend1
      IS
         SELECT CLASS, waits
           FROM contend
          WHERE waits > 0;

      
--
      CURSOR get_contend2
      IS
         SELECT CLASS, elapsed_time
           FROM contend
          WHERE elapsed_time > 0;

      
--
      CURSOR get_latch
      IS
         SELECT a.NAME, 100. * b.sleeps / b.gets
           FROM v$latchname a, v$latch b
          WHERE a.latch# = b.latch# AND b.sleeps > 0;

      
--
      CURSOR get_totals
      IS
         SELECT   object_type, COUNT (*)
             FROM dba_objects
            WHERE owner NOT IN ('SYS', 'SYSTEM')
         GROUP BY object_type
         ORDER BY object_type;

      
--
      CURSOR get_stat (stat IN VARCHAR2)
      IS
         SELECT NAME, VALUE
           FROM v$sysstat
          WHERE NAME = stat;

      
--
      CURSOR get_count (stat IN VARCHAR2)
      IS
         SELECT CLASS, "COUNT"
           FROM v$waitstat
          WHERE CLASS = stat_name;

      CURSOR get_delta (
         stat        IN   NUMBER,
         stat_name   IN   VARCHAR2,
         comp_date   IN   DATE
      )
      IS
         SELECT   stat
                - a.VALUE
           FROM dba_running_stats a
          WHERE a.NAME = stat_name
            AND a.meas_date BETWEEN   comp_date
                                    - 35 / 1440
                                AND   comp_date
                                    - 25 / 1440;

      CURSOR get_good
      IS
         SELECT   AVG (
                     b.good / (  b.good
                               + a.garbage
                              )
                  )
                * 100
           FROM sql_garbage a, sql_garbage b
          WHERE a.users = b.users
            AND a.garbage IS NOT NULL
            AND b.good IS NOT NULL;

      
--
      PROCEDURE write_out (
         par_name         IN   VARCHAR2,
         par_value        IN   NUMBER,
         rep_ord          IN   NUMBER,
         m_date           IN   DATE,
         par_delta        IN   NUMBER,
         is_interactive   IN   BOOLEAN
      )
      IS
      BEGIN
         IF NOT is_interactive
         THEN
            INSERT INTO dba_running_stats
                 VALUES (par_name, par_value, rep_ord, m_date, par_delta);
         ELSE
            INSERT INTO dba_temp
                 VALUES (par_name, par_value, rep_ord);
         END IF;
      END;
   --
   BEGIN
      IF NOT is_interactive
      THEN
         DELETE      dba_temp;
      END IF;

      SELECT SYSDATE
        INTO meas_date
        FROM DUAL;

      comp_date := meas_date;

      BEGIN
         dbms_revealnet.startup_date (start_date);

         IF start_date IS NOT NULL
         THEN
            stat_name :=    'Startup Date: '
                         || TO_CHAR (start_date, 'dd-mon-yy hh24:mi:ss');
            write_out (stat_name, 0, 1, meas_date, 0, is_interactive);
         ELSE
            stat_name := 'Startup Date: unknown';
            write_out (stat_name, 0, 1, meas_date, 0, is_interactive);
         END IF;
      END;

      BEGIN
         stat_name := 'recursive calls';
         OPEN get_stat (stat_name);
         FETCH get_stat INTO temp_name, r_calls;
         CLOSE get_stat;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            CLOSE get_stat;
      END;

      BEGIN
         stat_name := 'Data Dictionary Miss Percent';

         SELECT stat_name,   (SUM (getmisses) / SUM (gets))
                           * 100
           INTO temp_name, dd_ratio
           FROM v$rowcache;

         OPEN get_delta (dd_ratio, stat_name, comp_date);
         FETCH get_delta INTO delta;
         CLOSE get_delta;
         write_out (stat_name, dd_ratio, 2, meas_date, delta, is_interactive);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_out (stat_name, 0, 2, meas_date, 0, is_interactive);
            COMMIT;
      END;

      BEGIN
         stat_name := 'user calls';
         OPEN get_stat (stat_name);
         FETCH get_stat INTO temp_name, u_calls;
         CLOSE get_stat;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            CLOSE get_stat;
      END;

      BEGIN
         stat_name := 'db block gets';
         OPEN get_stat (stat_name);
         FETCH get_stat INTO temp_name, db_gets;
         CLOSE get_stat;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            CLOSE get_stat;
      END;

      BEGIN
         stat_name := 'consistent gets';
         OPEN get_stat (stat_name);
         FETCH get_stat INTO temp_name, con_gets;
         CLOSE get_stat;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            CLOSE get_stat;
      END;

      BEGIN
         stat_name := 'physical reads';
         OPEN get_stat (stat_name);
         FETCH get_stat INTO temp_name, p_reads;
         CLOSE get_stat;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            CLOSE get_stat;
      END;

      BEGIN
         stat_name := 'system undo header';
         OPEN get_count (stat_name);
         FETCH get_count INTO temp_name, suh_waits;
         CLOSE get_count;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            CLOSE get_count;
      END;

      BEGIN
         stat_name := 'system undo block';
         OPEN get_count (stat_name);
         FETCH get_count INTO temp_name, sub_waits;
         CLOSE get_count;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            CLOSE get_count;
      END;

      BEGIN
         stat_name := 'undo header';
         OPEN get_count (stat_name);
         FETCH get_count INTO temp_name, uh_waits;
         CLOSE get_count;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            CLOSE get_count;
      END;

      BEGIN
         stat_name := 'undo block';
         OPEN get_count (stat_name);
         FETCH get_count INTO temp_name, ub_waits;
         CLOSE get_count;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            CLOSE get_count;
      END;

      BEGIN
         calls_u := (r_calls / u_calls);
         h_ratio :=
                ((  db_gets
                  + con_gets
                 ) / (  db_gets
                      + con_gets
                      + p_reads
                     )
                );
         suhw_cont := (suh_waits / (  db_gets
                                    + con_gets
                                   ) * 100
                      );
         subw_cont := (sub_waits / (  db_gets
                                    + con_gets
                                   ) * 100
                      );
         uhw_cont := (uh_waits / (  db_gets
                                  + con_gets
                                 ) * 100
                     );
         ubw_cont := (ub_waits / (  db_gets
                                  + con_gets
                                 ) * 100
                     );
         stat_name := 'RECURSIVE CALLS PER USER';
         OPEN get_delta (calls_u, stat_name, comp_date);
         FETCH get_delta INTO delta;
         CLOSE get_delta;
         write_out (stat_name, calls_u, 3, meas_date, delta, is_interactive);
         stat_name := 'CUMMULATIVE HIT RATIO';
         write_out (stat_name, h_ratio, 3, meas_date, 0, is_interactive);
         stat_name := 'SYS UNDO HDR WAIT CONTENTION';
         write_out (stat_name, suhw_cont, 3, meas_date, 0, is_interactive);
         stat_name := 'SYS UNDO BLK WAIT CONTENTION';
         write_out (stat_name, subw_cont, 3, meas_date, 0, is_interactive);
         stat_name := 'UNDO HDR WAIT CONTENTION';
         write_out (stat_name, uhw_cont, 3, meas_date, 0, is_interactive);
         stat_name := 'UNDO BLK WAIT CONTENTION';
         write_out (stat_name, ubw_cont, 3, meas_date, 0, is_interactive);
         stat_name := 'freelist';
         OPEN get_count (stat_name);
         FETCH get_count INTO temp_name, stat_val;
         CLOSE get_count;
         stat_name := 'Free List Contention Ratio';
         write_out (stat_name, stat_val, 4, meas_date, 0, is_interactive);
      EXCEPTION
         WHEN ZERO_DIVIDE
         THEN
            write_out (stat_name, 0, 4, meas_date, 0, is_interactive);
            CLOSE get_count;
            COMMIT;
         WHEN NO_DATA_FOUND
         THEN
            write_out (stat_name, 0, 4, meas_date, 0, is_interactive);
            COMMIT;
      END;

      BEGIN
         version := dbms_revealnet.return_version;

         IF SUBSTR (version, 1, 5) IN ('7.2.3',
                                       '7.3.0',
                                       '7.3.1',
                                       '7.3.2',
                                       '7.3.3',
                                       '7.3.4',
                                       '8.0.4',
                                       '8.0.5'
                                      )
         THEN
            stat_name := 'Latch Miss%';

            SELECT (  1
                    -   (  (  SUM (sleeps)
                            + SUM (immediate_misses)
                           )
                         / (  SUM (gets)
                            + SUM (immediate_misses)
                            + SUM (immediate_gets)
                           )
                        )
                      * 100
                   )
              INTO stat_val
              FROM v$latch;

            write_out (stat_name, stat_val, 5, meas_date, 0, is_interactive);
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_out (stat_name, 0, 5, meas_date, 0, is_interactive);
            COMMIT;
      END;

      BEGIN
         stat_name := 'Rollback Wait %';

         SELECT (SUM (waits) / SUM (gets)) * 100
           INTO stat_val
           FROM v$rollstat;

         write_out (stat_name, stat_val, 6, meas_date, 0, is_interactive);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_out (stat_name, 0, 6, meas_date, 0, is_interactive);
            COMMIT;
      END;

      BEGIN
         stat_name := 'Library Reload %';

         SELECT SUM (reloads) / SUM (pins) * 100
           INTO stat_val
           FROM v$librarycache;

         write_out (stat_name, stat_val, 7, meas_date, 0, is_interactive);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_out (stat_name, 0, 7, meas_date, 0, is_interactive);
            COMMIT;
      END;

      BEGIN
         stat_name := 'table fetch by rowid';
         OPEN get_stat (stat_name);
         FETCH get_stat INTO temp_name, stat_val;
         CLOSE get_stat;
         OPEN get_delta (stat_val, stat_name, comp_date);
         FETCH get_delta INTO delta;
         CLOSE get_delta;
         write_out (stat_name, stat_val, 8, meas_date, delta, is_interactive);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_out (stat_name, 0, 8, meas_date, 0, is_interactive);
            CLOSE get_stat;
            COMMIT;
      END;

      BEGIN
         stat_name := 'Non-Index Lookups Ratio';

         SELECT a.VALUE / (  a.VALUE
                           + b.VALUE
                          )
           INTO stat_val
           FROM v$sysstat a, v$sysstat b
          WHERE a.NAME = 'table scans (long tables)'
            AND b.NAME = 'table scans (short tables)';

         write_out (stat_name, stat_val, 9, meas_date, 0, is_interactive);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_out (stat_name, 0, 9, meas_date, 0, is_interactive);
            CLOSE get_stat;
            COMMIT;
      END;

      BEGIN
         stat_name := 'table fetch continued row';
         OPEN get_stat (stat_name);
         FETCH get_stat INTO temp_name, stat_val;
         CLOSE get_stat;
         OPEN get_delta (stat_val, stat_name, comp_date);
         FETCH get_delta INTO delta;
         CLOSE get_delta;
         write_out (
            stat_name,
            stat_val,
            10,
            meas_date,
            delta,
            is_interactive
         );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_out (stat_name, 0, 10, meas_date, 0, is_interactive);
            CLOSE get_stat;
            COMMIT;
      END;

      BEGIN
         stat_name := 'sorts (memory)';
         OPEN get_stat (stat_name);
         FETCH get_stat INTO temp_name, stat_val;
         CLOSE get_stat;
         OPEN get_delta (stat_val, stat_name, comp_date);
         FETCH get_delta INTO delta;
         CLOSE get_delta;
         write_out (
            stat_name,
            stat_val,
            11,
            meas_date,
            delta,
            is_interactive
         );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_out (stat_name, 0, 11, meas_date, 0, is_interactive);
            CLOSE get_stat;
            COMMIT;
      END;

      BEGIN
         stat_name := 'sorts (disk)';
         OPEN get_stat (stat_name);
         FETCH get_stat INTO temp_name, stat_val;
         CLOSE get_stat;
         OPEN get_delta (stat_val, stat_name, comp_date);
         FETCH get_delta INTO delta;
         CLOSE get_delta;
         write_out (
            stat_name,
            stat_val,
            12,
            meas_date,
            delta,
            is_interactive
         );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_out (stat_name, 0, 12, meas_date, 0, is_interactive);
            CLOSE get_stat;
            COMMIT;
      END;

      BEGIN
         stat_name := 'table scans (long tables)';
         OPEN get_stat (stat_name);
         FETCH get_stat INTO temp_name, stat_val;
         CLOSE get_stat;
         OPEN get_delta (stat_val, stat_name, comp_date);
         FETCH get_delta INTO delta;
         CLOSE get_delta;
         write_out (
            stat_name,
            stat_val,
            13,
            meas_date,
            delta,
            is_interactive
         );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_out (stat_name, 0, 13, meas_date, 0, is_interactive);
            CLOSE get_stat;
            COMMIT;
      END;

      BEGIN
         stat_name := 'redo log space requests';
         OPEN get_stat (stat_name);
         FETCH get_stat INTO temp_name, stat_val;
         CLOSE get_stat;
         OPEN get_delta (stat_val, stat_name, comp_date);
         FETCH get_delta INTO delta;
         CLOSE get_delta;
         write_out (
            stat_name,
            stat_val,
            14,
            meas_date,
            delta,
            is_interactive
         );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_out (stat_name, 0, 14, meas_date, 0, is_interactive);
            CLOSE get_stat;
            COMMIT;
      END;

      BEGIN
         stat_name := 'redo log space wait time';
         OPEN get_stat (stat_name);
         FETCH get_stat INTO temp_name, stat_val;
         CLOSE get_stat;
         OPEN get_delta (stat_val, stat_name, comp_date);
         FETCH get_delta INTO delta;
         CLOSE get_delta;
         write_out (
            stat_name,
            stat_val,
            15,
            meas_date,
            delta,
            is_interactive
         );
         COMMIT;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_out (stat_name, 0, 15, meas_date, 0, is_interactive);
            CLOSE get_stat;
            COMMIT;
      END;

      BEGIN
         stat_name := 'Shared Pool Used';

         SELECT SUM (bytes) / 1048576
           INTO stat_val
           FROM v$sgastat
          WHERE NAME IN ('reserved stopper',
                         'table definiti',
                         'dictionary cache',
                         'library cache',
                         'sql area',
                         'PL/SQL DIANA',
                         'SEQ S.O.'
                        );

         write_out (stat_name, 0, 37, meas_date, 0, is_interactive);
         COMMIT;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_out (stat_name, 0, 37, meas_date, 0, is_interactive);
            COMMIT;
      END;

      BEGIN
         stat_name := 'Shared Pool Available';

         SELECT ((  MAX (b.VALUE)
                  - SUM (a.bytes)
                 ) / (1024 * 1024)
                )
           INTO stat_val
           FROM v$sgastat a, v$parameter b
          WHERE a.NAME IN ('reserved stopper',
                           'table definiti',
                           'dictionary cache',
                           'library cache',
                           'sql area',
                           'PL/SQL DIANA',
                           'SEQ S.O.'
                          )
            AND b.NAME = 'shared_pool_size';

         write_out (stat_name, 0, 37, meas_date, 0, is_interactive);
         COMMIT;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_out (stat_name, 0, 37, meas_date, 0, is_interactive);
            COMMIT;
      END;

      BEGIN
         stat_name := 'Shared SQL%';
         OPEN get_good;
         FETCH get_good INTO stat_val;
         CLOSE get_good;
         OPEN get_delta (stat_val, stat_name, comp_date);
         FETCH get_delta INTO delta;
         CLOSE get_delta;
         write_out (
            stat_name,
            stat_val,
            18,
            meas_date,
            delta,
            is_interactive
         );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_out (stat_name, 0, 18, meas_date, 0, is_interactive);
            CLOSE get_stat;
            COMMIT;
      END;

      BEGIN
         stat_name := 'TOTAL ALLOCATED MEG';

         SELECT SUM (bytes) / 1048576
           INTO stat_val
           FROM dba_data_files
          WHERE status = 'AVAILABLE';

         OPEN get_delta (stat_val, stat_name, comp_date);
         FETCH get_delta INTO delta;
         CLOSE get_delta;
         write_out (
            stat_name,
            stat_val,
            19,
            meas_date,
            delta,
            is_interactive
         );
         COMMIT;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_out (stat_name, 0, 19, meas_date, 0, is_interactive);
            COMMIT;
      END;

      BEGIN
         stat_name := 'TOTAL USED MEG';

         SELECT SUM (bytes) / 1048576
           INTO stat_val
           FROM dba_extents;

         OPEN get_delta (stat_val, stat_name, comp_date);
         FETCH get_delta INTO delta;
         CLOSE get_delta;
         write_out (
            stat_name,
            stat_val,
            20,
            meas_date,
            delta,
            is_interactive
         );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_out (stat_name, 0, 20, meas_date, 0, is_interactive);
            COMMIT;
      END;

      BEGIN
         stat_name := 'TOTAL SGA SIZE';

         SELECT stat_name, SUM (b.VALUE)
           INTO temp_name, stat_val
           FROM v$sga b;

         write_out (stat_name, stat_val, 21, meas_date, 0, is_interactive);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_out (stat_name, 0, 21, meas_date, 0, is_interactive);
            COMMIT;
      END;

      BEGIN
         OPEN get_latch;

         LOOP
            FETCH get_latch INTO stat_name, stat_val;
            EXIT WHEN get_latch%NOTFOUND;
            OPEN get_delta (stat_val, stat_name, comp_date);
            FETCH get_delta INTO delta;
            CLOSE get_delta;
            write_out (
               stat_name,
               stat_val,
               22,
               meas_date,
               delta,
               is_interactive
            );
         END LOOP;

         CLOSE get_latch;
         COMMIT;
      END;

      BEGIN
         OPEN get_contend1;

         LOOP
            FETCH get_contend1 INTO stat_name, stat_val;
            EXIT WHEN get_contend1%NOTFOUND;
            OPEN get_delta (stat_val,    stat_name
                                      || ' waits', comp_date);
            FETCH get_delta INTO delta;
            CLOSE get_delta;
            write_out (
               stat_name,
               stat_val,
               23,
               meas_date,
               delta,
               is_interactive
            );
         END LOOP;

         CLOSE get_contend1;
         COMMIT;
      END;

      BEGIN
         OPEN get_contend2;

         LOOP
            FETCH get_contend2 INTO stat_name, stat_val;
            EXIT WHEN get_contend2%NOTFOUND;
            OPEN get_delta (stat_val,    stat_name
                                      || ' time', comp_date);
            FETCH get_delta INTO delta;
            CLOSE get_delta;
            write_out (
               stat_name,
               stat_val,
               24,
               meas_date,
               delta,
               is_interactive
            );
         END LOOP;

         CLOSE get_contend2;
         COMMIT;
      END;

      BEGIN
         stat_name := 'undo header';
         OPEN get_count (stat_name);
         FETCH get_count INTO temp_name, uh_waits;
         CLOSE get_count;
         write_out (stat_name, uh_waits, 25, meas_date, 0, is_interactive);
         COMMIT;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_out (stat_name, 0, 25, meas_date, 0, is_interactive);
            COMMIT;
            CLOSE get_count;
      END;

      BEGIN
         stat_name := 'undo block';
         OPEN get_count (stat_name);
         FETCH get_count INTO temp_name, ub_waits;
         CLOSE get_count;
         write_out (stat_name, ub_waits, 26, meas_date, 0, is_interactive);
         COMMIT;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_out (stat_name, 0, 26, meas_date, 0, is_interactive);
            COMMIT;
            CLOSE get_count;
      END;

      BEGIN
         stat_name := 'data block';
         OPEN get_count (stat_name);
         FETCH get_count INTO temp_name, uh_waits;
         CLOSE get_count;
         write_out (stat_name, uh_waits, 27, meas_date, 0, is_interactive);
         COMMIT;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            write_out (stat_name, 0, 27, meas_date, 0, is_interactive);
            COMMIT;
            CLOSE get_count;
      END;

      BEGIN
         OPEN get_totals;

         LOOP
            FETCH get_totals INTO stat_name, stat_val;
            EXIT WHEN get_totals%NOTFOUND;
            OPEN get_delta (stat_val, stat_name, comp_date);
            FETCH get_delta INTO delta;
            CLOSE get_delta;
            write_out (
               stat_name,
               stat_val,
               28,
               meas_date,
               delta,
               is_interactive
            );
         END LOOP;

         CLOSE get_totals;
         COMMIT;
      END;

      COMMIT;
   END running_stats;

   
--
-- Procedure flush_it used to periodically flush the shared pool based on a 
-- calculated ratio of total shared pool to used shared pool. On 7.x systems
-- a ratio of .5 or more usually is where performance starts to hose.
--
   PROCEDURE flush_it (p_free IN NUMBER)
   IS
      
--
      CURSOR get_share
      IS
         SELECT SUM (bytes)
           FROM v$sgastat
          WHERE NAME IN ('reserved stopper',
                         'table definiti',
                         'dictionary cache',
                         'library cache',
                         'sql area',
                         'PL/SQL DIANA',
                         'SEQ S.O.'
                        );

      
--
      CURSOR get_var
      IS
         SELECT VALUE
           FROM v$parameter
          WHERE NAME = 'shared_pool_size';

      
--
      CURSOR get_time
      IS
         SELECT SYSDATE
           FROM DUAL;

      
--
      todays_date    DATE;
      mem_ratio      NUMBER;
      share_mem      NUMBER;
      variable_mem   NUMBER;
      cur            INTEGER;
      sql_com        VARCHAR2 (60);
      row_proc       NUMBER;
   
--
   BEGIN
      OPEN get_share;
      OPEN get_var;
      FETCH get_share INTO share_mem;
      DBMS_OUTPUT.put_line (   'share_mem: '
                            || TO_CHAR (share_mem));
      FETCH get_var INTO variable_mem;
      DBMS_OUTPUT.put_line (   'variable_mem: '
                            || TO_CHAR (variable_mem));
      mem_ratio := share_mem / variable_mem;
      DBMS_OUTPUT.put_line (
            TO_CHAR (mem_ratio, '99.999')
         || ' '
         || TO_CHAR (p_free / 100, '99.999')
      );

      IF mem_ratio > p_free / 100
      THEN
         cur := DBMS_SQL.open_cursor;
         sql_com := 'ALTER SYSTEM FLUSH SHARED_POOL';
         DBMS_SQL.parse (cur, sql_com, DBMS_SQL.v7);
         row_proc := DBMS_SQL.EXECUTE (cur);
         DBMS_SQL.close_cursor (cur);
         OPEN get_time;
         FETCH get_time INTO todays_date;

         INSERT INTO dba_running_stats
              VALUES ('Flush of Shared Pool', mem_ratio, 35, todays_date, 0);

         COMMIT;
      END IF;
   END flush_it;

   
--
-- Procedure hitratio calculates the periodic hit ratio, usage and number of users and
-- places them in the hit_ratios table. It should be run hourly via the dbms_job package.
--
   PROCEDURE hitratio
   IS
      c_date      DATE;
      c_hour      NUMBER        := 0;
      h_ratio     NUMBER (5, 2) := 0;
      con_gets    NUMBER        := 0;
      db_gets     NUMBER        := 0;
      p_reads     NUMBER        := 0;
      stat_name   VARCHAR (64);
      temp_name   VARCHAR (64);
      stat_val    NUMBER        := 0;
      users       NUMBER        := 0;

      CURSOR get_stat (p_name VARCHAR2)
      IS
         SELECT NAME, VALUE
           FROM v$sysstat
          WHERE NAME = p_name;
   BEGIN
      SELECT TO_CHAR (SYSDATE, 'DD-MON-YY')
        INTO c_date
        FROM DUAL;

      SELECT TO_CHAR (SYSDATE, 'HH24')
        INTO c_hour
        FROM DUAL;

      stat_name := 'db block gets';
      OPEN get_stat (stat_name);
      FETCH get_stat INTO temp_name, db_gets;
      CLOSE get_stat;
      DBMS_OUTPUT.put_line (   temp_name
                            || ':'
                            || TO_CHAR (db_gets));
      stat_name := 'consistent gets';
      OPEN get_stat (stat_name);
      FETCH get_stat INTO temp_name, con_gets;
      CLOSE get_stat;
      DBMS_OUTPUT.put_line (   temp_name
                            || ':'
                            || TO_CHAR (con_gets));
      stat_name := 'physical reads';
      OPEN get_stat (stat_name);
      FETCH get_stat INTO temp_name, p_reads;
      CLOSE get_stat;
      DBMS_OUTPUT.put_line (   temp_name
                            || ':'
                            || TO_CHAR (p_reads));

      SELECT COUNT (*)
        INTO users
        FROM v$session
       WHERE username IS NOT NULL;

      h_ratio := (  (  (  db_gets
                        + con_gets
                        - p_reads
                       )
                     / (  db_gets
                        + con_gets
                       )
                    )
                  * 100
                 );
      DBMS_OUTPUT.put_line (   'hit_ratio:'
                            || TO_CHAR (h_ratio));

      INSERT INTO hit_ratios
           VALUES (c_date, c_hour, db_gets, con_gets, p_reads, h_ratio, 0, 0, users);

      COMMIT;

      UPDATE hit_ratios
         SET period_hit_ratio = (SELECT ROUND (
                                             (  (  (  h2.CONSISTENT
                                                    - h1.CONSISTENT
                                                   )
                                                 + (  h2.db_block_gets
                                                    - h1.db_block_gets
                                                   )
                                                 - (  h2.phy_reads
                                                    - h1.phy_reads
                                                   )
                                                )
                                              / (  (  h2.CONSISTENT
                                                    - h1.CONSISTENT
                                                   )
                                                 + (  h2.db_block_gets
                                                    - h1.db_block_gets
                                                   )
                                                )
                                             )
                                           * 100,
                                           2
                                        )
                                   FROM hit_ratios h1, hit_ratios h2
                                  WHERE h2.check_date = hit_ratios.check_date
                                    AND h2.check_hour = hit_ratios.check_hour
                                    AND (   (    h1.check_date =
                                                                h2.check_date
                                             AND   h1.check_hour
                                                 + 1 = h2.check_hour
                                            )
                                         OR (      h1.check_date
                                                 + 1 = h2.check_date
                                             AND h1.check_hour = '23'
                                             AND h2.check_hour = '0'
                                            )
                                        ))
       WHERE period_hit_ratio = 0;

      COMMIT;

      UPDATE hit_ratios
         SET period_usage = (SELECT (  (  h2.CONSISTENT
                                        - h1.CONSISTENT
                                       )
                                     + (  h2.db_block_gets
                                        - h1.db_block_gets
                                       )
                                    )
                               FROM hit_ratios h1, hit_ratios h2
                              WHERE h2.check_date = hit_ratios.check_date
                                AND h2.check_hour = hit_ratios.check_hour
                                AND (   (    h1.check_date = h2.check_date
                                         AND   h1.check_hour
                                             + 1 = h2.check_hour
                                        )
                                     OR (      h1.check_date
                                             + 1 = h2.check_date
                                         AND h1.check_hour = '23'
                                         AND h2.check_hour = '0'
                                        )
                                    ))
       WHERE period_usage = 0;

      COMMIT;
   EXCEPTION
      WHEN ZERO_DIVIDE
      THEN
         INSERT INTO hit_ratios
              VALUES (c_date, c_hour, db_gets, con_gets, p_reads, 0, 0, 0, users);

         COMMIT;
   END hitratio;

   
--
-- Function GEN_PWORD returns a 6 place password that should be unique
--
   FUNCTION gen_pword
      RETURN VARCHAR2
   AS
      pi        NUMBER       := 3.141592653589793238462643;
      seed      NUMBER;
      pwd       VARCHAR2 (6);
      pwd_len   NUMBER       := 6;                    /* length of password */
   BEGIN
      
--dbms_output.enable(1000000);
      SELECT TO_NUMBER (TO_CHAR (hsecs)) / 8640000
        INTO seed
        FROM v$timer;                                     /*  0<= seed  < 1 */

      pwd := NULL;

      FOR j IN 1 .. pwd_len
      LOOP
         seed :=   POWER (  pi
                          + seed, 5)
                 - TRUNC (POWER (  pi
                                 + seed, 5));
         pwd :=    pwd
                || CHR (  64
                        + 1
                        + TRUNC (seed * 26));
      END LOOP;

      
-- dbms_output.put_line (pwd);
      RETURN pwd;
   END;

   
--
-- Procedure auto_defrag
--
   PROCEDURE auto_defrag
   AS
      CURSOR get_frags
      IS
         SELECT   TABLESPACE, COUNT (TABLESPACE), SUM (pieces)
             FROM free_space
         GROUP BY TABLESPACE;

      pieces     NUMBER;
      files      NUMBER;
      tbname     VARCHAR2 (64);
      sql_stmt   VARCHAR2 (255);
      cur        INTEGER;
      ROWS       INTEGER;

      PROCEDURE write_out (
         par_name    IN   VARCHAR2,
         par_value   IN   NUMBER,
         rep_ord     IN   NUMBER,
         m_date      IN   DATE,
         par_delta   IN   NUMBER
      )
      IS
      BEGIN
         INSERT INTO dba_running_stats
              VALUES (par_name, par_value, rep_ord, m_date, par_delta);
      END;
   BEGIN
      OPEN get_frags;

      LOOP
         FETCH get_frags INTO tbname, files, pieces;
         EXIT WHEN get_frags%NOTFOUND;

         IF pieces > files
         THEN
            BEGIN
               write_out (
                     'defragmenting '
                  || tbname,
                  pieces,
                  99,
                  SYSDATE,
                  0
               );
               DBMS_OUTPUT.put_line (
                     'defragmenting '
                  || tbname
                  || ' pieces:'
                  || TO_CHAR (pieces)
               );
               cur := DBMS_SQL.open_cursor;
               sql_stmt :=    'alter tablespace '
                           || tbname
                           || ' coalesce';
               DBMS_SQL.parse (cur, sql_stmt, DBMS_SQL.v7);
               ROWS := DBMS_SQL.EXECUTE (cur);
               DBMS_SQL.close_cursor (cur);
            EXCEPTION
               WHEN OTHERS
               THEN
                  write_out (
                        'error during defrag of '
                     || tbname,
                     pieces,
                     99,
                     SYSDATE,
                     0
                  );
                  DBMS_OUTPUT.put_line (
                        'error defragmenting '
                     || tbname
                     || ' error:'
                     || TO_CHAR (SQLCODE)
                  );
            END;
         END IF;

         COMMIT;
      END LOOP;
   END auto_defrag;
--
-- End of package body
--
END dbms_revealnet;
/
