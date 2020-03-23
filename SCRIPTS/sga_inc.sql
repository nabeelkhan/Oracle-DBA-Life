REM FILE NAME:  sga_inc.sql
REM LOCATION:   System Monitoring\Utilities
REM FUNCTION:   Examine x$KCBRBH table to see if SGA needs to expand
REM TESTED ON:  7.3.3.5
REM PLATFORM:   non-specific
REM REQUIRES:   x$KCBRBH ( must log in as SYS)
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM

COL bufval new_value nbuf noprint
COL thits  new_value tot_hits noprint
SELECT VALUE bufval
  FROM v$parameter
 WHERE LOWER (NAME) = 'db_block_lru_extended_statistics';
SELECT SUM (COUNT) thits
  FROM sys.x$kcbrbh;
START title80 "Gained Hits if &nbuf Cache Buffers are Added"
COL interval   format         a20 justify c heading 'Buffers'
COL cache_hits format 999,999,990 justify c heading -
  'Hits that would be gained|had Cache Buffers been added'
COL cum format 99.99 heading 'Percent of Gain'
SET feedback off verify off echo off
SPOOL rep_out\sga_inc
SELECT      LPAD (
               TO_CHAR (
                    &&incr * TRUNC (indx / &&incr)
                  + 1,
                  '999,990'
               ),
               8
            )
         || ' to '
         || LPAD (
               TO_CHAR (
                  &&incr * (  TRUNC (indx / &&incr)
                            + 1
                           ),
                  '999,990'
               ),
               8
            )
               INTERVAL,
         SUM (COUNT) cache_hits
    FROM sys.x$kcbrbh
   WHERE indx > 0
GROUP BY TRUNC (indx / &&incr);

SPOOL off
SET termout on feedback 15 verify on
CLEAR columns
CLEAR computes
