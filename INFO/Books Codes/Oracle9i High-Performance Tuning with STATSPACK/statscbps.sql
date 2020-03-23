Rem
Rem $Header: statscbps.sql 01-nov-99.14:11:07 cdialeri Exp $
Rem
Rem statscbps.sql
Rem
Rem  Copyright (c) Oracle Corporation 1999. All Rights Reserved.
Rem
Rem    NAME
Rem      statscbps.sql
Rem
Rem    DESCRIPTION
Rem      Script to allow Statspack to run with 8.0 or 8.1.5 
Rem      database.
Rem
Rem    NOTES
Rem      Creates a STATSV_$BUFFER_POOL_STATISTICS view owned by SYS,
Rem      and a private synonym owned by PERFSTAT to simulate the
Rem      missing V$BUFFER_POOL_STATISTICS view.
Rem
Rem    USAGE
Rem      Must be run as INTERNAL or SYS.  This script must be run BEFORE 
Rem      the Statspack installation script statscre.sql
Rem
Rem    WARNING
Rem      Running Statspack against server releases earlier than 8.1.6 is
Rem      NOT SUPPORTED.
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    cdialeri    12/10/99 - Create
Rem

set echo off;
whenever sqlerror exit;

spool statscbps.lis

/* ---------------------------------------------------------------------- */

create view v_$buffer_pool_statistics
( id
, name
, set_msize
, cnum_repl
, cnum_write
, cnum_set
, buf_got
, sum_write
, sum_scan
, free_buffer_wait
, write_complete_wait
, buffer_busy_wait
, free_buffer_inspected
, dirty_buffers_inspected
, db_block_change
, db_block_gets
, consistent_gets
, physical_reads
, physical_writes)
as select 
  set_id
, 'FAKE VIEW'
, '0'
, cnum_repl
, cnum_write
, cnum_set
, buf_got
, sum_wrt
, sum_scn
, fbwait
, wcwait
, bbwait
, fbinsp
, dbinsp
, dbbchg
, dbbget
, conget
, pread
, pwrite
from X$KCBWDS;

create public synonym V$BUFFER_POOL_STATISTICS for V_$BUFFER_POOL_STATISTICS;
grant select on V_$BUFFER_POOL_STATISTICS to select_catalog_role;

spool off

/* ---------------------------------------------------------------------- */
