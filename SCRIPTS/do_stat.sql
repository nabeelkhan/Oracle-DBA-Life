REM FILE NAME:  do_stat.sql
REM LOCATION:   System Monitoring\Utilities
REM FUNCTION:   Do an ANALYZE on all database tables
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_tables
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM
REM NOTE:     DONT RUN THIS UNLESS YOU WANT
REM           ALL TABLES ANALYZED SINCE IT WILL 
REM           LOAD TABLE STATS AND THIS MAY CAUSE 
REM           PROBLEMS WITH OPTIMIZER
REM
REM
REM***********************************************************************************


SET pages 0 
REM set feedback off 
REM set echo off termout off 
REM set verify off
SPOOL rep_out\do_stat.sql
SELECT    'analyze table '
       || owner
       || '.'
       || table_name
       || ' estimate statistics;'
  FROM dba_tables
 WHERE owner NOT IN ('SYS', 'SYSTEM');
SPOOL off
START rep_out\do_stat.sql
