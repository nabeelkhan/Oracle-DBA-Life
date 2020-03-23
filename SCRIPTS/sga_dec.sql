REM FILE NAME:  sga_dec.sql
REM LOCATION:   Database Tuning\Buffer Cache Reports
REM FUNCTION:   Query X$KCBCBH with the intent to shrink the SGA
REM TESTED ON:  7.3.3.5
REM PLATFORM:   non-specific
REM REQUIRES:   x$kcbcbh (must log in as SYS)
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM 

COL bufval new_value nbuf noprint
COL thits new_value tot_hits noprint
SELECT VALUE bufval
  FROM v$parameter
 WHERE LOWER (NAME) = 'db_block_buffers';
SELECT SUM (COUNT) thits
  FROM x$kcbcbh;
START title80 "Lost Hits if &nbuf Cache Buffers were Removed"
COL interval   format         a20 justify c heading 'Buffers'
COL cache_hits format 999,999,990 justify c heading -
  'Hits that would have been lost|had Cache Buffers been removed'
COL cum format 99.99 heading 'Percent of loss'
SET feedback off verify off echo off
SPOOL rep_out\sga_dec
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
         SUM (COUNT) cache_hits,
         SUM (COUNT) / &tot_hits * 100 cum
    FROM x$kcbcbh
   WHERE indx > 0
GROUP BY TRUNC (indx / &&incr);

SPOOL off
SET termout on feedback 15 verify on
CLEAR columns
CLEAR computes
