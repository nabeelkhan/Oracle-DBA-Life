REM FILE NAME:  objwait.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Report the objects that your users are accessing 
REM             when they are forced to wait for disk I/O.
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$session, v$sqlarea, v$session_wait, dba_extents
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


SET heading off
SET pagesize 999
SET verify off
SET feedback off
SET echo off
COLUMN aa newline
SPOOL rep_out\objwait.sql
COLUMN nl newline
SELECT 'doc ' nl,
          'User '
       || v$session.username
       || '('
       || v$session_wait.sid
       || ')' nl,
       v$sqlarea.sql_text nl, '#' nl, 'select segment_name, segment_type ' nl,
       'from dba_extents ' nl,    'where file_id='
                               || v$session_wait.p1 nl,
          '  and '
       || v$session_wait.p2
       || ' between block_id and block_id 
           +  blocks -1);'
  FROM v$session, v$sqlarea, v$session_wait
 WHERE (   v$session_wait.event LIKE '%buffer%'
        OR v$session_wait.event LIKE '%write%'
        OR v$session_wait.event LIKE '%read%'
       )
   AND v$session_wait.sid = v$session.sid
   AND v$session.sql_address = v$sqlarea.address
   AND v$session.sql_hash_value = v$sqlarea.hash_value
/
SPOOL off
@rep_out\objwait.sql
