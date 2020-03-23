-- ***************************************************************************
-- File: 3_5.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 3_5.lis

-- Program: 3_5.sql
-- Created: 05/20/98
-- Created By: Joe Trezzo (TUSC)

-- Description: This script creates the source_log table, an index
--              on the table, a PUBLIC synonym on the table and 
--              select and insert access on the table.

SPOOL 3_5.log
CREATE TABLE source_log
(backup_date    DATE,
 backup_time    VARCHAR2(6),
 last_ddl_time  DATE,
 owner          VARCHAR2(30),
 name           VARCHAR2(30),
 type           VARCHAR2(12),
 line           NUMBER,
 text           VARCHAR2(2000)) -- For Oracle8 change 2000 to 4000
/
CREATE INDEX source_log_idx1 ON source_log
  (last_ddl_time, owner, name)
/
CREATE PUBLIC SYNONYM source_log FOR source_log
/
GRANT SELECT, INSERT ON source_log to PUBLIC
/

SPOOL OFF

SPOOL OFF
