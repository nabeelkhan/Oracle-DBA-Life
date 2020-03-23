REM FILE NAME:  lockall.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Report on all locks held by all users
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_objects, v$session, v$lock
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN username         format a15      heading "User Name"
COLUMN sid              format 9999999  heading "SID"
COLUMN ltype            format a30      heading "Type"
COLUMN object_name      format a30      heading "Object Name"
COLUMN mode_held        format a10      heading "Mode"
BREAK ON username
SET FEEDBACK OFF VERIFY OFF 
SET lines 132 pages 59
START title132 "Locks Held By All Users Report"
SPOOL rep_out\lockall
SELECT s.username, s.sid,
       DECODE (
          l.TYPE,
          'MR', 'Media Recovery',
          'RT', 'Redo Thread',
          'UN', 'User Name',
          'TX', 'Transaction',
          'TM', 'DML',
          'UL', 'PL/SQL User Lock',
          'DX', 'Distributed Xaction',
          'CF', 'Control File',
          'IS', 'Instance State',
          'DS', 'File Set',
          'IR', 'Instance Recovery',
          'ST', 'Disk Space Transaction',
          'TS', 'Temp Segment',
          'IV', 'Library Cache Invalidation',
          'LS', 'Log Start or Switch',
          'RW', 'Row Wait',
          'SQ', 'Sequence Number',
          'TE', 'Extend Table',
          'TT', 'Temp Table'
       ) ltype,
       o.object_name,
       DECODE (
          l.lmode,
          2, 'Row-S(SS)',
          3, 'Row-X(SX)',
          4, 'Share',
          5, 'S/Row-X(SSX)',
          6, 'Exclusive',
          'Other'
       ) mode_held
  FROM dba_objects o, v$session s, v$lock l
 WHERE s.sid = l.sid AND o.object_id = l.id1;
SPOOL off
SET lines 80 pages 22
TTITLE off
CLEAR columns
