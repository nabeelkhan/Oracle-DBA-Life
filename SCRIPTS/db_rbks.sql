REM FILE NAME:  db_rbks.sql
REM LOCATION:   Object Management\Rollback Segment
REM FUNCTION:   Create list of all database rollback segments and their storage defaults
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_rollback_segs
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN rollback_seg format a8        heading 'Rollback|Segment'
COLUMN tablespace format a10         heading 'Rbks|Tablespace'
COLUMN pct        format 9990        heading 'Pct|Inc'
COLUMN init       format 99,999,999  heading 'Init|Ext'
COLUMN next       format 99,999,999  heading 'Next|Ext'
COLUMN min        format 999         heading 'Min|Ext'
COLUMN max        format 9,999       heading 'Max|Ext'
COLUMN instance   format a3          heading 'Int|Num'
COLUMN type                          heading 'Rbks|Type'
COLUMN status                        heading 'Rbks|Status'
SET pages 59 lines 132 feedback off echo off
START title132 'Rollback Storage Parameter Report'
SPOOL rep_out\db_rbks
SELECT segment_name rollback_seg, tablespace_name TABLESPACE,
       initial_extent init, next_extent NEXT, min_extents MIN, max_extents MAX,
       pct_increase pct, status, instance_num INSTANCE,
       DECODE (owner, 'SYS', 'PRIVATE') TYPE
  FROM dba_rollback_segs;
SPOOL off
TTITLE off
CLEAR columns
SET pages 22 lines 80 feedback on echo on
