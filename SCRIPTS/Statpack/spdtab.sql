Rem
Rem $Header: spdtab.sql 26-feb-2002.19:12:54 vbarrier Exp $
Rem
Rem spdtab.sql
Rem
Rem Copyright (c) 1999, 2002, Oracle Corporation.  All rights reserved.  
Rem
Rem    NAME
Rem      spdtab.sql
Rem
Rem    DESCRIPTION
Rem      SQL*PLUS command file to drop statspack "snapshot" tables
Rem
Rem    NOTES
Rem      Must be run as STATSPACK table owner, PERFSTAT
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    vbarrier    03/05/02 - Segment Statistics
Rem    cdialeri    11/30/01 - 9.2 - features 1
Rem    cdialeri    04/13/01 - 9.0
Rem    cdialeri    09/12/00 - sp_1404195
Rem    cdialeri    04/07/00 - 1261813
Rem    cdialeri    03/28/00 - sp_purge
Rem    cdialeri    02/16/00 - 1191805
Rem    cdialeri    11/04/99 - 1059172
Rem    cdialeri    08/13/99 - Created
Rem

set echo off;

spool spdtab.lis

/* ------------------------------------------------------------------------- */

prompt Dropping old versions (if any)

whenever sqlerror continue;

/* - sequence - */
drop public synonym    STATS$SNAPSHOT_ID;
drop sequence PERFSTAT.STATS$SNAPSHOT_ID;

/* - tables - */
drop public synonym  STATS$FILESTATXS;
drop table  PERFSTAT.STATS$FILESTATXS;
drop public synonym  STATS$TEMPSTATXS;
drop table  PERFSTAT.STATS$TEMPSTATXS;
drop public synonym  STATS$LATCH;
drop table  PERFSTAT.STATS$LATCH;
drop public synonym  STATS$LATCH_MISSES_SUMMARY;
drop table  PERFSTAT.STATS$LATCH_MISSES_SUMMARY;
drop public synonym  STATS$LATCH_CHILDREN;
drop table  PERFSTAT.STATS$LATCH_CHILDREN;
drop public synonym  STATS$LATCH_PARENT;
drop table  PERFSTAT.STATS$LATCH_PARENT;
drop public synonym  STATS$LIBRARYCACHE;
drop table  PERFSTAT.STATS$LIBRARYCACHE;
drop public synonym  STATS$BUFFER_POOL_STATISTICS;
drop table  PERFSTAT.STATS$BUFFER_POOL_STATISTICS;
drop public synonym  STATS$ROLLSTAT;
drop table  PERFSTAT.STATS$ROLLSTAT;
drop public synonym  STATS$ROWCACHE_SUMMARY;
drop table  PERFSTAT.STATS$ROWCACHE_SUMMARY;
drop public synonym  STATS$SGA;
drop table  PERFSTAT.STATS$SGA;
drop public synonym  STATS$SGASTAT;
drop table  PERFSTAT.STATS$SGASTAT;
drop public synonym  STATS$SYSSTAT;
drop table  PERFSTAT.STATS$SYSSTAT;
drop public synonym  STATS$SESSTAT;
drop table  PERFSTAT.STATS$SESSTAT;
drop public synonym  STATS$SYSTEM_EVENT;
drop table  PERFSTAT.STATS$SYSTEM_EVENT;
drop public synonym  STATS$SESSION_EVENT;
drop table  PERFSTAT.STATS$SESSION_EVENT;
drop public synonym  STATS$BG_EVENT_SUMMARY;
drop table  PERFSTAT.STATS$BG_EVENT_SUMMARY;
drop public synonym  STATS$WAITSTAT;
drop table  PERFSTAT.STATS$WAITSTAT;
drop public synonym  STATS$ENQUEUE_STAT;
drop table  PERFSTAT.STATS$ENQUEUE_STAT;
drop public synonym  STATS$SQL_SUMMARY;
drop table  PERFSTAT.STATS$SQL_SUMMARY;
drop public synonym  STATS$SQL_STATISTICS;
drop table  PERFSTAT.STATS$SQL_STATISTICS;
drop public synonym  STATS$SQLTEXT;
drop table  PERFSTAT.STATS$SQLTEXT;
drop public synonym  STATS$PARAMETER;
drop table  PERFSTAT.STATS$PARAMETER;
drop public synonym  STATS$STATSPACK_PARAMETER;
drop table  PERFSTAT.STATS$STATSPACK_PARAMETER;
drop public synonym  STATS$IDLE_EVENT;
drop table  PERFSTAT.STATS$IDLE_EVENT;
drop public synonym  STATS$RESOURCE_LIMIT;
drop table  PERFSTAT.STATS$RESOURCE_LIMIT;
drop public synonym  STATS$DLM_MISC;
drop table  PERFSTAT.STATS$DLM_MISC;
drop public synonym  STATS$UNDOSTAT;
drop table  PERFSTAT.STATS$UNDOSTAT;
drop public synonym  STATS$SQL_PLAN;
drop table  PERFSTAT.STATS$SQL_PLAN;
drop public synonym  STATS$SQL_PLAN_USAGE;
drop table  PERFSTAT.STATS$SQL_PLAN_USAGE;
drop public synonym  STATS$SEG_STAT_OBJ;
drop table  PERFSTAT.STATS$SEG_STAT_OBJ;
drop public synonym  STATS$SEG_STAT;
drop table  PERFSTAT.STATS$SEG_STAT;
drop public synonym  STATS$DB_CACHE_ADVICE;
drop table  PERFSTAT.STATS$DB_CACHE_ADVICE;
drop public synonym  STATS$PGASTAT;
drop table  PERFSTAT.STATS$PGASTAT;
drop public synonym  STATS$INSTANCE_RECOVERY;
drop table  PERFSTAT.STATS$INSTANCE_RECOVERY;
drop public synonym  STATS$SHARED_POOL_ADVICE;
drop table  PERFSTAT.STATS$SHARED_POOL_ADVICE;
drop public synonym  STATS$SQL_WORKAREA_HISTOGRAM;
drop table  PERFSTAT.STATS$SQL_WORKAREA_HISTOGRAM;
drop public synonym  STATS$PGA_TARGET_ADVICE;
drop table  PERFSTAT.STATS$PGA_TARGET_ADVICE;


--  NB. STATS$DATABASE_INSTANCE must be dropped last, since it is referenced 
--  by foreign keys.  STATS$SNAPSHOT must be dropped before the remaining
--  tables

drop public synonym  STATS$SNAPSHOT;
drop table  PERFSTAT.STATS$SNAPSHOT;
drop public synonym  STATS$LEVEL_DESCRIPTION;
drop table  PERFSTAT.STATS$LEVEL_DESCRIPTION;
drop public synonym  STATS$DATABASE_INSTANCE;
drop table  PERFSTAT.STATS$DATABASE_INSTANCE;



/* - packages - */
drop public  synonym  STATSPACK;
drop package PERFSTAT.STATSPACK;

/* ------------------------------------------------------------------------- */

prompt
prompt NOTE:
prompt   SPDTAB complete. Please check spdtab.lis for any errors.
prompt

spool off;
set echo on;
