REM FILE NAME:  brown.sql
REM LOCATION:   Object Management\Indexes\Reports
REM FUNCTION:   Report Index Statistics - browned 
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   index_stats, dual, dba_indexes, stat_temp
REM
REM This is a part of the Knowledge Xpert for Oracle Administration library. 
REM Copyright (C) 2001 Quest Software 
REM All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN del_lf_rows_len        FORMAT 999,999,999 HEADING 'Deleted Bytes'
COLUMN lf_rows_len            FORMAT 999,999,999 HEADING 'Filled Bytes'
COLUMN browning               FORMAT 999.90      HEADING 'Percent|Browned'
COLUMN height                 FORMAT 999999      HEADING 'Height' 
COLUMN blocks                 FORMAT 999999      HEADING 'Blocks' 
COLUMN distinct_keys          FORMAT 999999999   HEADING '#|Keys'
COLUMN most_repeated_key      FORMAT 999999999   HEADING 'Most|Repeated|Key'
COLUMN used_space             FORMAT 999999999   HEADING 'Used|Space' 
COLUMN rows_per_key           FORMAT 999999      HEADING 'Rows|Per|Key'
ACCEPT owner prompt 'Enter table owner name: '
SET heading off feedback off verify off echo off recsep off pages 0
TTITLE off
DEFINE cr='chr(10)'
SPOOL index_sz.sql
SELECT    'create table stat_temp as select * from index_stats;'
       || &&cr
       || 'truncate table stat_temp;'
  FROM DUAL;
SELECT    'analyze index '
       || owner
       || '.'
       || index_name
       || ' validate structure;'
       || &&cr
       || 'insert into stat_temp select * from index_stats;'
       || &&cr
       || 'commit;'
  FROM dba_indexes
 WHERE owner = UPPER ('&owner');
SPOOL off
SET feedback off termout off lines 132 verify off
START index_sz.sql
START title132 "Index Statistics Report"
SET heading on feedback on verify on lines 132 pages 58
SPOOL rep_out/brown
SELECT NAME, del_lf_rows_len, lf_rows_len,
         (  del_lf_rows_len
          / DECODE (
               (  lf_rows_len
                + del_lf_rows_len
               ),
               0, 1,
                 lf_rows_len
               + del_lf_rows_len
            )
         )
       * 100
             browning,
       height, blocks, distinct_keys, most_repeated_key, used_space,
       rows_per_key
  FROM stat_temp
 WHERE rows_per_key > 0;
SPOOL off
