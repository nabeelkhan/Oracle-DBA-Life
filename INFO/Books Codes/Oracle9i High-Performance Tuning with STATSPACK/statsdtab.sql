Rem
Rem $Header: statsdtab.sql 04-nov-99.11:28:51 cdialeri Exp $
Rem
Rem statsdtab.sql
Rem
Rem  Copyright (c) Oracle Corporation 1999. All Rights Reserved.
Rem
Rem    NAME
Rem      statsdtab.sql
Rem
Rem    DESCRIPTION
Rem      SQL*PLUS command file to drop statspack "snapshot" tables
Rem
Rem    NOTES
Rem      Must be run as STATSPACK table owner, PERFSTAT
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    cdialeri    11/04/99 - 1059172
Rem    cdialeri    08/13/99 - Created
Rem

set echo off;

spool statsdtab.lis

/* ------------------------------------------------------------------------- */

prompt Dropping old versions (if any)

whenever sqlerror continue;

/* - sequence - */
drop public synonym  STATS$SNAPSHOT_ID;
drop sequence        STATS$SNAPSHOT_ID;

/* - tables - */
drop public synonym STATS$FILESTATXS;
drop table          STATS$FILESTATXS;
drop public synonym STATS$LATCH;
drop table          STATS$LATCH;
drop public synonym STATS$LATCH_MISSES_SUMMARY;
drop table          STATS$LATCH_MISSES_SUMMARY;
drop public synonym STATS$LATCH_CHILDREN;
drop table          STATS$LATCH_CHILDREN;
drop public synonym STATS$LIBRARYCACHE;
drop table          STATS$LIBRARYCACHE;
drop public synonym STATS$BUFFER_POOL;
drop table          STATS$BUFFER_POOL;
drop public synonym STATS$BUFFER_POOL_STATISTICS;
drop table          STATS$BUFFER_POOL_STATISTICS;
drop public synonym STATS$ROLLSTAT;
drop table          STATS$ROLLSTAT;
drop public synonym STATS$ROWCACHE_SUMMARY;
drop table          STATS$ROWCACHE_SUMMARY;
drop public synonym STATS$SGAXS;
drop table          STATS$SGAXS;
drop public synonym STATS$SGASTAT_SUMMARY;
drop table          STATS$SGASTAT_SUMMARY;
drop public synonym STATS$SYSSTAT;
drop table          STATS$SYSSTAT;
drop public synonym STATS$SESSTAT;
drop table          STATS$SESSTAT;
drop public synonym STATS$SYSTEM_EVENT;
drop table          STATS$SYSTEM_EVENT;
drop public synonym STATS$SESSION_EVENT;
drop table          STATS$SESSION_EVENT;
drop public synonym STATS$BG_EVENT_SUMMARY;
drop table          STATS$BG_EVENT_SUMMARY;
drop public synonym STATS$WAITSTAT;
drop table          STATS$WAITSTAT;
drop public synonym STATS$ENQUEUESTAT;
drop table          STATS$ENQUEUESTAT;
drop public synonym STATS$SQL_SUMMARY;
drop table          STATS$SQL_SUMMARY;
drop public synonym STATS$PARAMETER;
drop table          STATS$PARAMETER;
drop public synonym STATS$STATSPACK_PARAMETER;
drop table          STATS$STATSPACK_PARAMETER;
drop public synonym STATS$LEVEL_DESCRIPTION;
drop table          STATS$LEVEL_DESCRIPTION;
drop public synonym STATS$IDLE_EVENT;
drop table          STATS$IDLE_EVENT;


--  NB. STATS$DATABASE_INSTANCE must be dropped last, since it is referenced 
--  by foreign keys.  STATS$SNAPSHOT must be dropped before the remaining
--  tables

drop public synonym STATS$SNAPSHOT;
drop table          STATS$SNAPSHOT;
drop public synonym STATS$DATABASE_INSTANCE;
drop table          STATS$DATABASE_INSTANCE;



/* - packages - */
drop public synonym STATSPACK;
drop package        STATSPACK;

/* ------------------------------------------------------------------------- */

prompt
prompt NOTE:
prompt   STATSDTAB complete. Please check statsdtab.lis for any errors.
prompt

spool off;
set echo on;
