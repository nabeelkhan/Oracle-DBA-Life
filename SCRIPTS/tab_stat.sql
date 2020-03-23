REM FILE NAME:  tab_stat.sql
REM LOCATION:   Object Management\Tables\Reports
REM FUNCTION:   Will show table statistics for a user's tables or all tables.
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_tables.  Must have run ANALYZE on the tables.
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


SET pages 56 lines 130 newpage 0 verify off echo off feedback off
REM
COLUMN owner            format a12            heading "Table Owner"
COLUMN table_name       format a20            heading "Table"
COLUMN tablespace_name  format a20            heading "Tablespace"
COLUMN num_rows         format 999,999,999    heading "Rows"
COLUMN blocks           format 999,999        heading "Blocks" 
COLUMN empty_blocks     format 999,999        heading "Empties" 
COLUMN space_full       format 999.99         heading "% Full" 
COLUMN chain_cnt        format 999,999        heading "Chains"
COLUMN avg_row_len      format 99,999,999,999 heading "Avg Length (Bytes)"
REM
START title132 "Table Statistics Report"
SPOOL rep_out\tab_stat
BREAK ON OWNER SKIP 2 ON TABLESPACE_NAME SKIP 1;
SELECT   owner, table_name, tablespace_name, num_rows, blocks, empty_blocks,
           100
         * (  (num_rows * avg_row_len)
            / ((  GREATEST (blocks, 1)
                + empty_blocks
               ) * 2048
              )
           )
               space_full,
         chain_cnt, avg_row_len
    FROM dba_tables
   WHERE owner NOT IN ('SYS', 'SYSTEM')
ORDER BY owner, tablespace_name;
SPOOL off
SET pages 22 lines 80 newpage 1 verify on echo off feedback on
CLEAR columns
CLEAR breaks
TTITLE off
