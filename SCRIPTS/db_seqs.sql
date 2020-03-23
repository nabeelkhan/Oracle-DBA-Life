REM FILE NAME:  db_seqs.sql
REM LOCATION:   Object Management\Sequence Reports
REM FUNCTION:   Generate a report on sequences for an account
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_sequences
REM 
REM INPUTS: 	1 - Sequence Owner or Wild Card
REM				2 - Sequence Name or Wild Card
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


SET HEADING OFF VERIFY OFF PAUSE OFF echo off 
REM
PROMPT ** Sequence Report **
PROMPT
PROMPT Percent signs are wild
REM
ACCEPT sequence_owner prompt 'Enter Oracle account to report on (or wild):';
ACCEPT sequence_name prompt 'Enter object name to report on (or wild): ';
PROMPT
PROMPT Report file name is sequence_dbname.lis
REM
SET HEADING ON  
SET LINESIZE 130 PAGESIZE 56 NEWPAGE 0 TAB OFF SPACE 1 
SET TERMOUT OFF
BREAK ON SEQUENCE_OWNER SKIP 2
REM
COLUMN SEQUENCE_OWNER   FORMAT A10      HEADING 'Sequence Owner'
COLUMN SEQUENCE_NAME    FORMAT A30      HEADING 'Sequence Name'
COLUMN MIN_VALUE                        HEADING 'Minimum'
COLUMN MAX_VALUE                        HEADING 'Maximum'
COLUMN INCREMENT_BY     FORMAT 9999     HEADING 'Incr.'
COLUMN CYCLE_FLAG                       HEADING 'Cycle'
COLUMN ORDER_FLAG                       HEADING 'Order'
COLUMN CACHE_SIZE       FORMAT 99999    HEADING 'Cache'
COLUMN LAST_NUMBER                      HEADING 'Last Value'
REM
START title132 "SEQUENCE REPORT"
SPOOL rep_out\db_seqs
REM
SELECT   sequence_owner, sequence_name, min_value, max_value, increment_by,
         DECODE (cycle_flag, 'Y', 'YES', 'N', 'NO') cycle_flag,
         DECODE (order_flag, 'Y', 'YES', 'N', 'NO') order_flag, cache_size,
         last_number
    FROM dba_sequences
   WHERE sequence_owner LIKE UPPER ('&SEQUENCE_OWNER')
     AND sequence_name LIKE UPPER ('&SEQUENCE_NAME')
ORDER BY 1, 2;
SPOOL OFF
SET heading on verify on feedback on tab on lines 80 pages 22
SET termout on
CLEAR columns
TTITLE off
