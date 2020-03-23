REM FILE NAME:  locksql.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Report objects and users involved in a blocking situation
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$sqltext, v$access, v$session
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM
REM
REM NOTES:   Report the usernames being blocked and the objects 
REM          involved in a locking situation. The statements 
REM          listed are the last statement run by each user, 
REM          which is usually the statement causing the locking 
REM          problem. The user that has a lockwait of null is 
REM          the user that the other users are waiting for. 
REM          That user is not listed in this query. 
REM          Use UTLLOCKT.SQL to find the offending user. 
REM
REM***********************************************************************************


COLUMN users            format a15      heading "User Name / SID"
COLUMN owner            format a15      heading "Owner"
COLUMN object           format a30      heading "Object"
COLUMN lockwait         format a15      heading "Lock Wait"
COLUMN sqltext          format a30      heading "SQL Text"
BREAK ON username
SET FEEDBACK OFF VERIFY OFF 
START title132 "Objects and Users Involved in a Blocking Situation"
SPOOL rep_out\locksql

SELECT    ses.username
       || '('
       || ses.sid
       || ')' users, acc.owner owner,
       acc.OBJECT OBJECT, ses.lockwait, txt.sql_text sqltext
  FROM v$sqltext txt, v$access acc, v$session ses
 WHERE txt.address = ses.sql_address
   AND txt.hash_value = ses.sql_hash_value
   AND ses.sid = acc.sid
   AND ses.lockwait IS NOT NULL;
SPOOL off
SET lines 80 pages 22
TTITLE off
CLEAR columns
