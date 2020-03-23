REM FILE NAME:  crea_tab.sql
REM LOCATION:   SetUp
REM FUNCTION: 	Create required views and tables for the DBMS_REVEALNET package
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


DROP TABLE dba_temp;
CREATE TABLE dba_temp (
NAME VARCHAR2(64),
VALUE NUMBER,
rep_order NUMBER)
STORAGE (INITIAL 16k NEXT 16k);

DROP TABLE temp_size_table;
CREATE TABLE temp_size_table (
table_name VARCHAR2(64),
blocks NUMBER)
STORAGE (INITIAL 16k NEXT 16k);

DROP TABLE hit_ratios;
CREATE TABLE hit_ratios (
check_date DATE NOT NULL,
check_hour NUMBER NOT NULL,
db_block_gets NUMBER,
CONSISTENT NUMBER,
phy_reads NUMBER,
hitratio NUMBER,
period_hit_ratio NUMBER,
period_usage NUMBER,
users NUMBER)
STORAGE (INITIAL 16k NEXT 16k);

CREATE UNIQUE INDEX hr_index ON hit_ratios (
check_date,
check_hour)
STORAGE (INITIAL 16k NEXT 16k);

REM  You must have direct select grants on the undelying tables
REM  for these views to be generated.

CREATE OR REPLACE VIEW free_space (
   TABLESPACE,
   file_id,
   pieces,
   free_bytes,
   free_blocks,
   largest_bytes,
   largest_blks,
   fsfi
)
AS
   SELECT   tablespace_name, file_id, COUNT (*), SUM (bytes), SUM (blocks),
            MAX (bytes), MAX (blocks),
              SQRT (MAX (blocks) / SUM (blocks))
            * (100 / SQRT (SQRT (COUNT (blocks))))
       FROM sys.dba_free_space
   GROUP BY tablespace_name, file_id;

REM
REM FUNCTION: create views required for rbk1 and rbk2 reports.
REM
REM exit
CREATE OR REPLACE VIEW rollback1
AS
   SELECT d.segment_name, extents, optsize, shrinks, aveshrink, aveactive,
          d.status
     FROM v$rollname n, v$rollstat s, dba_rollback_segs d
    WHERE d.segment_id = n.usn(+) AND d.segment_id = s.usn(+);

CREATE OR REPLACE VIEW rollback2
AS
   SELECT d.segment_name, extents, xacts, hwmsize, rssize, waits, wraps,
          EXTENDS
     FROM v$rollname n, v$rollstat s, dba_rollback_segs d
    WHERE d.segment_id = n.usn(+) AND d.segment_id = s.usn(+);
REM FUNCTION: Creates summary of v_$sqlarea and dba_users for use in
REM           sqlmem.sql and sqlsummary.sql reports
REM
REM
CREATE OR REPLACE VIEW sql_summary
AS
   SELECT username, sharable_mem, persistent_mem, runtime_mem
     FROM sys.v_$sqlarea a, dba_users b
    WHERE a.parsing_user_id = b.user_id;
REM 
REM trans_per_rollback view gives a quick look at who is doing what to rollbacks
REM 
CREATE OR REPLACE VIEW trans_per_rollback (
   NAME, sid, pid, TRANSACTION, terminal)
AS
   SELECT r.NAME, l.sid, p.spid, NVL (p.username, 'no transaction'), p.terminal
     FROM v$lock l, v$process p, v$rollname r
    WHERE l.sid = p.pid(+)
      AND TRUNC (l.id1(+) / 65536) = r.usn
      AND l.TYPE(+) = 'TX'
      AND l.lmode(+) = 6;
REM
REM proc_count view 
REM provides line count data for procedures
REM
CREATE OR REPLACE VIEW proc_count
AS
   SELECT   owner, NAME, TYPE, COUNT (*) lines
       FROM dba_source
   GROUP BY owner, NAME, TYPE
/

CREATE TABLE dba_running_stats (
NAME VARCHAR2(64),
VALUE NUMBER,
rep_order NUMBER,
meas_date DATE,
delta NUMBER)
STORAGE(INITIAL 1m NEXT 1m PCTINCREASE 0)
/
DROP TABLE revealnet_kept_objects;
CREATE TABLE revealnet_kept_objects
(
   object_name VARCHAR2(128),
CONSTRAINT pk_revealnet_kept_objects
PRIMARY KEY (object_name)
USING INDEX
TABLESPACE &&index_tablespace
STORAGE (INITIAL 16k NEXT 16k PCTINCREASE 0))
TABLESPACE &&data_tablespace
STORAGE (INITIAL 16k NEXT 16k);
--
-- Column object_name stores the names of objects that the user wishes to pin in the
-- Shared SQL area
--
DROP TABLE revealnet_update_tables;
CREATE TABLE revealnet_update_tables
(
   main_table VARCHAR2(30) NOT NULL,
   table_name VARCHAR2(30) NOT NULL,
   column_name VARCHAR2(30) NOT NULL,
CONSTRAINT pk_revealnet_update_tables
PRIMARY KEY (main_table,table_name,column_name)
USING INDEX
TABLESPACE &&index_tablespace
STORAGE (INITIAL 16k NEXT 16k PCTINCREASE 0))
STORAGE (INITIAL 56k NEXT 56k PCTINCREASE 0)
TABLESPACE &&data_tablespace;

/
-- Column definitions for revealnet_update_tables  are as follows:
--
-- main_table holds the name of the table that the update
-- cascades from.
--
-- table_name holds the name(s) of the tables to cascade the update
-- into.
--
-- column_name is the name of the column in the target table(s) to
-- updateDBMS version
--
-- view contend is used by dbms_revealnet.running_stats
--
CREATE OR REPLACE VIEW contend
AS
   SELECT   CLASS, SUM (COUNT) waits, SUM (TIME) elapsed_time
       FROM v$waitstat
   GROUP BY CLASS;
--
--
--
CREATE OR REPLACE VIEW sql_garbage
AS
   SELECT   b.username users, SUM (  a.sharable_mem
                                   + a.persistent_mem) garbage,
            TO_NUMBER (NULL) good
       FROM sys.v_$sqlarea a, dba_users b
      WHERE (a.parsing_user_id = b.user_id AND a.executions <= 1)
   GROUP BY b.username
   UNION
   SELECT DISTINCT b.username users, TO_NUMBER (NULL) garbage,
                   SUM (  c.sharable_mem
                        + c.persistent_mem) good
              FROM dba_users b, sys.v_$sqlarea c
             WHERE (b.user_id = c.parsing_user_id AND c.executions > 1)
          GROUP BY b.username;
--
-- end of crea_tab.sql
--
