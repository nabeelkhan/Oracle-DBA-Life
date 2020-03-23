REM FILE NAME:  rdo_stat.sql
REM LOCATION:   Database Tuning\Redo Log Reports
REM FUNCTION:   Show REDO latch statisitics
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$latch, v$latchname, v$sysstat
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


SET pages 56 lines 78 verify off feedback off 
START title80 "Redo Latch Statistics"
SPOOL rep_out/rdo_stat
REM
COLUMN name             format a30      heading Name
COLUMN percent          format 999.999  heading Percent
COLUMN total                            heading Total
REM
SELECT l2.NAME,   immediate_gets
                + gets total, immediate_gets "Immediates",
         misses
       + immediate_misses "Total Misses",
       DECODE (
            100.
          * (  GREATEST (  misses
                         + immediate_misses, 1)
             / GREATEST (  immediate_gets
                         + gets, 1)
            ),
          100, 0
       )
             PERCENT
  FROM v$latch l1, v$latchname l2
 WHERE l2.NAME LIKE '%redo%' AND l1.latch# = l2.latch#;
REM
SPOOL OFF
TTITLE OFF
