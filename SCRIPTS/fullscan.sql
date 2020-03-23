REM FILE NAME:  fullscan.sql
REM LOCATION:   Database Tuning\File I/O Reports
REM FUNCTION:   Identifies users of full table scans
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$session, v$sesstat, v$statname
REM             This view is used by the fscanavg.sql script
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


DROP VIEW full_table_scans;

CREATE VIEW full_table_scans
AS
   SELECT      ss.username
            || '('
            || se.sid
            || ') ' "User Process",
            SUM (DECODE (NAME, 'table scans (short tables)', VALUE)) "Short Scans",
            SUM (DECODE (NAME, 'table scans (long tables)', VALUE)) "Long Scans",
            SUM (DECODE (NAME, 'table scan rows gotten', VALUE)) "Rows Retrieved"
       FROM v$session ss, v$sesstat se, v$statname sn
      WHERE se.statistic# = sn.statistic#
        AND (   NAME LIKE '%table scans (short tables)%'
             OR NAME LIKE '%table scans (long tables)%'
             OR NAME LIKE '%table scan rows gotten%'
            )
        AND se.sid = ss.sid
        AND ss.username IS NOT NULL
   GROUP BY    ss.username
            || '('
            || se.sid
            || ') ';

COLUMN  "User Process"             FORMAT a20;  
COLUMN  "Long Scans"               FORMAT 999,999,999;  
COLUMN  "Short Scans"              FORMAT 999,999,999;   
COLUMN  "Rows Retreived"           FORMAT 999,999,999;   
COLUMN  "Average Long Scan Length" FORMAT 999,999,999;   
TTITLE ' Table Access Activity By User '
SELECT   "User Process", "Long Scans", "Short Scans", "Rows Retrieved"
    FROM full_table_scans
ORDER BY "Long Scans" DESC;
