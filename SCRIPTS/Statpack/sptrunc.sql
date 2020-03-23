Rem
Rem $Header: sptrunc.sql 19-feb-2002.11:36:28 vbarrier Exp $
Rem
Rem sptrunc.sql
Rem
Rem Copyright (c) 2000, 2002, Oracle Corporation.  All rights reserved.  
Rem
Rem    NAME
Rem      sptrunc.sql - STATSPACK - Truncate tables
Rem
Rem    DESCRIPTION
Rem      Truncates data in Statspack tables
Rem
Rem    NOTES
Rem      Should be run as STATSPACK user, PERFSTAT.
Rem
Rem      The following tables should NOT be truncated
Rem        STATS$LEVEL_DESCRIPTION
Rem        STATS$IDLE_EVENT
Rem        STATS$STATSPACK_PARAMETER
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    vbarrier    03/05/02 - Segment Statistics
Rem    cdialeri    04/13/01 - 9.0
Rem    cdialeri    09/12/00 - sp_1404195
Rem    cdialeri    04/11/00 - 1261813
Rem    cdialeri    03/15/00 - Created
Rem

undefine anystring
set showmode off echo off;
whenever sqlerror exit;

spool sptrunc.lis

/* ------------------------------------------------------------------------- */

prompt
prompt Warning
prompt ~~~~~~~
prompt Running sptrunc.sql removes ALL data from Statspack tables.  You may
prompt wish to export the data before continuing.
prompt
prompt
prompt About to Truncate Statspack Tables
prompt ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
prompt If you would like to continue, press <return>
prompt
prompt
prompt &return Entered - starting truncate operation

truncate table STATS$FILESTATXS;
truncate table STATS$TEMPSTATXS;
truncate table STATS$LATCH;
truncate table STATS$LATCH_CHILDREN;
truncate table STATS$LATCH_MISSES_SUMMARY;
truncate table STATS$LATCH_PARENT;
truncate table STATS$LIBRARYCACHE;
truncate table STATS$BUFFER_POOL_STATISTICS;
truncate table STATS$ROLLSTAT;
truncate table STATS$ROWCACHE_SUMMARY;
truncate table STATS$SGA;
truncate table STATS$SGASTAT;
truncate table STATS$SYSSTAT;
truncate table STATS$SESSTAT;
truncate table STATS$SYSTEM_EVENT;
truncate table STATS$SESSION_EVENT;
truncate table STATS$BG_EVENT_SUMMARY;
truncate table STATS$WAITSTAT;
truncate table STATS$ENQUEUE_STAT;
truncate table STATS$SQL_SUMMARY;
truncate table STATS$SQL_STATISTICS;
truncate table STATS$SQLTEXT;
truncate table STATS$PARAMETER;
truncate table STATS$RESOURCE_LIMIT;
truncate table STATS$DLM_MISC;
truncate table STATS$UNDOSTAT;
truncate table STATS$SQL_PLAN;
truncate table STATS$SQL_PLAN_USAGE;
truncate table STATS$SEG_STAT;
truncate table STATS$SEG_STAT_OBJ;
truncate table STATS$DB_CACHE_ADVICE;
truncate table STATS$PGASTAT;
truncate table STATS$INSTANCE_RECOVERY;

delete from STATS$SNAPSHOT;
delete from STATS$DATABASE_INSTANCE;

commit;

Rem This is required to allow further snapshots to work without 
Rem recreating package or restarting the instance
alter package statspack compile;

prompt
prompt Truncate operation complete
prompt


/* ------------------------------------------------------------------------- */

spool off;

whenever sqlerror continue;
set echo on;
