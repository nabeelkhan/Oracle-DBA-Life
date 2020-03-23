REM FILE NAME:  act_size8.sql
REM LOCATION:  	Object Management\Tabls\Reports
REM FUNCTION:   Shows actual block used vs allocated for all tables for a user
REM TESTED ON:  8.0.4.1, 8.1.5, 8.1.7, 9.0.1 
REM PLATFORM:   non-specific
REM REQUIRES:   dba_segments, index_stats, v$parameter , dual, stat_temp
REM
REM INPUTS:     owner = Table owner name.
REM
REM This is a part of the Knowledge Xpert for Oracle Administration library. 
REM Copyright (C) 2001 Quest Software 
REM All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


ACCEPT owner prompt 'Enter table owner name: '
SET heading off feedback off verify off echo off recsep off pages 0
COLUMN db_block_size new_value blocksize noprint
TTITLE off
DEFINE cr='chr(10)'
DEFINE qt='chr(39)'
DELETE      temp_size_table;
SELECT VALUE db_block_size
  FROM v$parameter
 WHERE NAME = 'db_block_size';
SPOOL fill_sz.sql
SELECT    'INSERT INTO temp_size_table'
       || &&cr
       || 'SELECT '
       || &&qt
       || segment_name
       || &&qt
       || &&cr
       || ',COUNT( DISTINCT(dbms_rowid.rowid_block_number(ROWID))) blocks'
       || &&cr
       || 'FROM &&owner..'
       || segment_name,
       ';'
  FROM dba_segments
 WHERE segment_type = 'TABLE' AND owner = UPPER ('&owner');
SPOOL OFF
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
SET feedback on termout on lines 132
START index_sz.sql
INSERT INTO temp_size_table
   SELECT NAME, TRUNC (used_space / &&blocksize)
     FROM stat_temp;
REM drop table stat_temp;
DEFINE temp_var = &&qt;
START fill_sz
HOST del  fill_size_table.sql
DEFINE bs = '&&blocksize K'
COLUMN t_date       NOPRINT new_value t_date
COLUMN user_id      NOPRINT new_value user_id
COLUMN segment_name FORMAT A25         HEADING "SEGMENT|NAME"
COLUMN segment_type FORMAT A7          HEADING "SEGMENT|TYPE"
COLUMN extents      FORMAT 999         HEADING "EXTENTS"
COLUMN kbytes       FORMAT 999,999,999 HEADING "KILOBYTES"
COLUMN blocks       FORMAT 9,999,999   HEADING "ALLOC.|&&bs|BLOCKS"
COLUMN act_blocks   FORMAT 9,999,990   HEADING "USED|&&bs|BLOCKS"
COLUMN pct_block    FORMAT 999.99      HEADING "PCT|BLOCKS|USED"
START title132 "Actual Size Report for &owner"
SET pages 55
BREAK on report on segment_type skip 1
COMPUTE sum of kbytes on segment_type report 
SPOOL rep_out\act_siz8
SELECT   segment_name, segment_type, SUM (extents) extents,
         SUM (bytes) / 1024 kbytes, SUM (a.blocks) blocks,
         NVL (MAX (b.blocks), 0) act_blocks,
         (MAX (b.blocks) / SUM (a.blocks)) * 100 pct_block
    FROM sys.dba_segments a, temp_size_table b
   WHERE segment_name = UPPER (b.table_name)
GROUP BY segment_name, segment_type
ORDER BY segment_type, segment_name;
SPOOL OFF
DELETE      temp_size_table;
SET termout on feedback 15 verify on pagesize 20 linesize 80 space 1
UNDEF qt
UNDEF cr
TTITLE off
CLEAR columns 
CLEAR computes
