Rem
Rem $Header: spctab.sql 16-apr-2002.14:54:46 vbarrier Exp $
Rem
Rem spctab.sql
Rem
Rem Copyright (c) 1999, 2002, Oracle Corporation.  All rights reserved.  
Rem
Rem    NAME
Rem      spctab.sql
Rem
Rem    DESCRIPTION
Rem	 SQL*PLUS command file to create tables to hold
Rem      start and end "snapshot" statistical information
Rem
Rem    NOTES
Rem      Should be run as STATSPACK user, PERFSTAT
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    vbarrier    03/20/02 - 2143634
Rem    vbarrier    03/05/02 - Segment Statistics
Rem    cdialeri    02/07/02 - 2218573
Rem    cdialeri    01/30/02 - 2184717
Rem    cdialeri    01/11/02 - 9.2 - features 2
Rem    cdialeri    11/30/01 - 9.2 - features 1
Rem    cdialeri    04/22/01 - Undostat changes
Rem    cdialeri    03/02/01 - 9.0
Rem    cdialeri    09/12/00 - sp_1404195
Rem    cdialeri    04/07/00 - 1261813
Rem    cdialeri    03/20/00 - Support for purge
Rem    cdialeri    02/16/00 - 1191805
Rem    cdialeri    01/26/00 - 1169401
Rem    cdialeri    11/01/99 - Enhance, 1059172
Rem    cmlim       07/17/97 - Added STATS$SQLAREA to store top sql stmts
Rem    gwood       10/16/95 - Version to run as sys without using many views
Rem    cellis.uk   11/15/89 - Created
Rem

set showmode off echo off;
whenever sqlerror exit;

spool spctab.lis

/* ------------------------------------------------------------------------- */

prompt
prompt  If this script is automatically called from spcreate (which is
prompt  the supported method), all STATSPACK segments will be created in 
prompt  the PERFSTAT user's default tablespace.
prompt

define tablespace_name=&&default_tablespace
prompt Using &&tablespace_name tablespace to store Statspack objects
prompt

/* ------------------------------------------------------------------------- */

Prompt ... Creating STATS$SNAPSHOT_ID Sequence

create sequence       STATS$SNAPSHOT_ID
       start with   1
       increment by 1
       nomaxvalue
       cache 10;

create public synonym STATS$SNAPSHOT_ID  for STATS$SNAPSHOT_ID;

/* ------------------------------------------------------------------------- */

Prompt ... Creating STATS$... tables

create table          STATS$DATABASE_INSTANCE
(dbid                 number       not null
,instance_number      number       not null
,startup_time         date         not null         
,snap_id              number (6)   not null
,parallel             varchar2(3)  not null
,version              varchar2(17) not null
,db_name              varchar2(9)  not null
,instance_name        varchar2(16) not null
,host_name            varchar2(64)
,constraint STATS$DATABASE_INSTANCE_PK primary key
    (dbid, instance_number, startup_time)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$DATABASE_INSTANCE  for STATS$DATABASE_INSTANCE;

/* ------------------------------------------------------------------------- */

create table          STATS$LEVEL_DESCRIPTION
(snap_level           number          not null
,description          varchar2(300)
,constraint STATS$LEVEL_DESCRIPTION_PK primary key (snap_level)
 using index tablespace &&tablespace_name
  storage (initial 100k next 100k pctincrease 0)
) tablespace &&tablespace_name
  storage (initial 100k next 100k pctincrease 0)
;

insert into STATS$LEVEL_DESCRIPTION (snap_level, description)
  values (0,  'This level captures general statistics, including rollback segment, row cache, SGA, system events, background events, session events, system statistics, wait statistics, lock statistics, and Latch information');

insert into STATS$LEVEL_DESCRIPTION (snap_level, description)
  values (5,  'This level includes capturing high resource usage SQL Statements, along with all data captured by lower levels');

insert into STATS$LEVEL_DESCRIPTION (snap_level, description)
  values (6,  'This level includes capturing SQL plan and SQL plan usage information for high resource usage SQL Statements, along with all data captured by lower levels');

insert into STATS$LEVEL_DESCRIPTION (snap_level, description)
  values (7,  'This level captures segment level statistics, including logical and physical reads, row lock, itl and buffer busy waits, along with all data captured by lower levels');

insert into STATS$LEVEL_DESCRIPTION (snap_level, description)
  values (10,  'This level includes capturing Child Latch statistics, along with all data captured by lower levels');

commit;

create public synonym  STATS$LEVEL_DESCRIPTION   for STATS$LEVEL_DESCRIPTION;

/* ------------------------------------------------------------------------- */

create table          STATS$SNAPSHOT
(snap_id              number(6)        not null
,dbid                 number           not null
,instance_number      number           not null
,snap_time            date             not null
,startup_time         date             not null
,session_id           number           not null
,serial#              number
,snap_level           number
,ucomment             varchar2(160)
,executions_th        number
,parse_calls_th       number
,disk_reads_th        number
,buffer_gets_th       number
,sharable_mem_th      number
,version_count_th     number
,seg_phy_reads_th     number         not null
,seg_log_reads_th     number         not null
,seg_buff_busy_th     number         not null
,seg_rowlock_w_th     number         not null
,seg_itl_waits_th     number         not null
,seg_cr_bks_sd_th     number         not null
,seg_cu_bks_sd_th     number         not null
,all_init             varchar2(5)
,constraint STATS$SNAPSHOT_PK primary key (snap_id, dbid, instance_number)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$SNAPSHOT_LVL_FK
    foreign key (snap_level) references STATS$LEVEL_DESCRIPTION
,constraint STATS$SNAPSHOT_FK foreign key (dbid, instance_number, startup_time)
    references STATS$DATABASE_INSTANCE on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$SNAPSHOT  for STATS$SNAPSHOT;

/* ------------------------------------------------------------------------- */

create table          STATS$DB_CACHE_ADVICE
(snap_id              number(6)       not null
,dbid                 number          not null
,instance_number      number          not null
,id                   number          not null
,name                 varchar2(20)    not null
,block_size           number          not null
,buffers_for_estimate number          not null
,advice_status        varchar2(3)
,size_for_estimate    number
,size_factor          number
,estd_physical_read_factor number
,estd_physical_reads  number
,constraint STATS$DB_CACHE_ADVICE_PK primary key 
     (snap_id, dbid, instance_number, id, buffers_for_estimate)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$DB_CACHE_ADVICE_FK foreign key 
     (snap_id, dbid, instance_number)
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;
 
create public synonym  STATS$DB_CACHE_ADVICE  for STATS$DB_CACHE_ADVICE;

/* ------------------------------------------------------------------------- */

create table          STATS$FILESTATXS
(snap_id              number(6)       not null
,dbid                 number          not null
,instance_number      number          not null
,tsname               varchar2 (30)   not null
,filename             varchar2 (513)  not null
,phyrds               number
,phywrts              number
,singleblkrds         number
,readtim              number
,writetim             number
,singleblkrdtim       number
,phyblkrd             number
,phyblkwrt            number
,wait_count           number
,time                 number
,constraint STATS$FILESTATXS_PK primary key 
     (snap_id, dbid, instance_number, tsname, filename)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$FILESTATXS_FK foreign key (snap_id, dbid, instance_number)
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;
 
create public synonym  STATS$FILESTATXS  for STATS$FILESTATXS;
 
/* ------------------------------------------------------------------------- */

create table STATS$TEMPSTATXS
(snap_id             number(6)     not null
,dbid                number        not null
,instance_number     number        not null
,tsname              varchar2(30)  not null
,filename            varchar2(513) not null
,phyrds              number
,phywrts             number
,singleblkrds        number
,readtim             number
,writetim            number
,singleblkrdtim      number
,phyblkrd            number
,phyblkwrt           number
,wait_count          number
,time                number
,constraint STATS$TEMPSTATXS_PK primary key
     (snap_id, dbid, instance_number, tsname, filename)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$TEMPSTATXS_FK foreign key (snap_id, dbid, instance_number)
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$TEMPSTATXS  for STATS$TEMPSTATXS;

/* ------------------------------------------------------------------------- */

create table          STATS$LATCH
(snap_id              number(6)       not null
,dbid                 number          not null
,instance_number      number          not null
,name                 varchar2(64)    not null
,latch#               number          not null
,level#               number
,gets                 number
,misses               number
,sleeps               number
,immediate_gets       number
,immediate_misses     number
,spin_gets            number
,sleep1               number
,sleep2               number
,sleep3               number
,sleep4               number
,wait_time            number
,constraint STATS$LATCH_PK primary key 
    (snap_id, dbid, instance_number, name) 
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$LATCH_FK foreign key (snap_id, dbid, instance_number) 
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$LATCH  for STATS$LATCH;

/* ------------------------------------------------------------------------- */

create table          STATS$LATCH_CHILDREN
(snap_id              number(6)       not null
,dbid                 number          not null
,instance_number      number          not null
,latch#               number          not null
,child#               number          not null
,gets                 number
,misses               number
,sleeps               number
,immediate_gets       number
,immediate_misses     number
,spin_gets            number
,sleep1               number
,sleep2               number
,sleep3               number
,sleep4               number
,wait_time            number
,constraint STATS$LATCH_CHILDREN_PK primary key 
    (snap_id, dbid, instance_number, latch#, child#) 
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$LATCH_CHILDREN_FK foreign key 
    (snap_id, dbid, instance_number) 
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$LATCH_CHILDREN  for STATS$LATCH_CHILDREN;

/* ------------------------------------------------------------------------- */

create table          STATS$LATCH_PARENT
(snap_id              number(6)       not null
,dbid                 number          not null
,instance_number      number          not null
,latch#               number          not null
,level#               number          not null
,gets                 number
,misses               number
,sleeps               number
,immediate_gets       number
,immediate_misses     number
,spin_gets            number
,sleep1               number
,sleep2               number
,sleep3               number
,sleep4               number
,wait_time            number
,constraint STATS$LATCH_PARENT_PK primary key 
    (snap_id, dbid, instance_number, latch#) 
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$LATCH_PARENT_FK foreign key 
    (snap_id, dbid, instance_number) 
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$LATCH_PARENT  for STATS$LATCH_PARENT;

/* ------------------------------------------------------------------------- */

create table          STATS$LATCH_MISSES_SUMMARY
(snap_id              number(6)        not null
,dbid                 number           not null
,instance_number      number           not null
,parent_name          varchar2(50)
,where_in_code        varchar2(64)
,nwfail_count         number
,sleep_count          number
,wtr_slp_count        number
,constraint STATS$LATCH_MISSES_SUMMARY_PK primary key 
    (snap_id, dbid, instance_number, parent_name, where_in_code)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$LATCH_MISSES_SUMMARY_FK foreign key 
    (snap_id, dbid, instance_number)
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;
 
create public synonym  STATS$LATCH_MISSES_SUMMARY  for STATS$LATCH_MISSES_SUMMARY;

/* ------------------------------------------------------------------------- */

create table            STATS$LIBRARYCACHE
(snap_id                number(6)       not null
,dbid                   number          not null
,instance_number        number          not null
,namespace              varchar2(15)    not null
,gets                   number
,gethits                number
,pins                   number
,pinhits                number
,reloads                number
,invalidations          number
,dlm_lock_requests      number
,dlm_pin_requests       number
,dlm_pin_releases       number
,dlm_invalidation_requests  number
,dlm_invalidations      number
,constraint STATS$LIBRARYCACHE_PK primary key 
    (snap_id, dbid, instance_number, namespace)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$LIBRARYCACHE_FK foreign key 
    (snap_id, dbid, instance_number) 
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$LIBRARYCACHE  for STATS$LIBRARYCACHE;

/* ------------------------------------------------------------------------- */

create table             STATS$BUFFER_POOL_STATISTICS
(snap_id                 number(6)        not null
,dbid                    number           not null
,instance_number         number           not null
,id                      number           not null
,name                    varchar2(20)		
,block_size              number
,set_msize               number
,cnum_repl               number
,cnum_write              number
,cnum_set                number
,buf_got                 number
,sum_write               number
,sum_scan                number
,free_buffer_wait        number
,write_complete_wait     number
,buffer_busy_wait        number
,free_buffer_inspected   number
,dirty_buffers_inspected number
,db_block_change         number
,db_block_gets           number
,consistent_gets         number
,physical_reads          number
,physical_writes         number       
,constraint STATS$BUFFER_POOL_STATS_PK primary key
    (snap_id, dbid, instance_number, id)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$BUFFER_POOL_STATS_FK foreign key
     (snap_id, dbid, instance_number)
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$BUFFER_POOL_STATISTICS  for STATS$BUFFER_POOL_STATISTICS;

/* ------------------------------------------------------------------------- */

create table          STATS$ROLLSTAT
(snap_id              number(6)        not null
,dbid                 number           not null
,instance_number      number           not null
,usn                  number           not null
,extents              number
,rssize               number
,writes               number
,xacts                number
,gets                 number
,waits                number
,optsize              number
,hwmsize              number
,shrinks              number
,wraps                number
,extends              number
,aveshrink            number
,aveactive            number
,constraint STATS$ROLLSTAT_PK primary key 
     (snap_id, dbid, instance_number, usn) 
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$ROLLSTAT_FK foreign key (snap_id, dbid, instance_number) 
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$ROLLSTAT  for STATS$ROLLSTAT;

/* ------------------------------------------------------------------------- */

create table          STATS$ROWCACHE_SUMMARY
(snap_id              number (6)       not null
,dbid                 number           not null
,instance_number      number           not null
,parameter            varchar2 (32)
,total_usage          number
,usage                number
,gets                 number
,getmisses            number
,scans                number
,scanmisses           number
,scancompletes        number
,modifications        number
,flushes              number
,dlm_requests         number
,dlm_conflicts        number
,dlm_releases         number
,constraint STATS$ROWCACHE_SUMMARY_PK primary key 
    (snap_id, dbid, instance_number, parameter) 
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$ROWCACHE_SUMMARY_FK foreign key 
    (snap_id, dbid, instance_number) 
        references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$ROWCACHE_SUMMARY  for STATS$ROWCACHE_SUMMARY;

/* ------------------------------------------------------------------------- */

create table          STATS$SGA
(snap_id              number (6)       not null
,dbid                 number           not null
,instance_number      number           not null
,name                 varchar2(64)     not null
,value                number           not null
,startup_time         date
,parallel             varchar2(3)
,version              varchar2(17)
,constraint STATS$SGA_PK primary key 
    (snap_id, dbid, instance_number, name)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$SGA_FK foreign key 
    (snap_id, dbid, instance_number)
        references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$SGA    for STATS$SGA;

/* ------------------------------------------------------------------------- */

create table          STATS$SGASTAT
(snap_id              number           not null
,dbid                 number           not null
,instance_number      number           not null
,name                 varchar2(64)     not null 
,pool                 varchar2(11)
,bytes                number
,constraint STATS$SGASTAT_U unique
    (snap_id, dbid, instance_number, name, pool)
  using index tablespace &&tablespace_name
    storage (initial 1m next 1m pctincrease 0)
,constraint STATS$SGASTAT_FK foreign key 
    (snap_id, dbid, instance_number) 
        references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$SGASTAT  for STATS$SGASTAT;

/* ------------------------------------------------------------------------- */

create table          STATS$SYSSTAT
(snap_id              number(6)       not null
,dbid                 number          not null
,instance_number      number          not null
,statistic#           number          not null
,name                 varchar2 (64)   not null
,value                number
,constraint STATS$SYSSTAT_PK primary key 
    (snap_id, dbid, instance_number, name) 
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$SYSSTAT_FK foreign key (snap_id, dbid, instance_number) 
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$SYSSTAT  for STATS$SYSSTAT;

/* ------------------------------------------------------------------------- */

create table          STATS$SESSTAT
(snap_id              number(6)       not null
,dbid                 number          not null
,instance_number      number          not null
,statistic#           number          not null
,value                number
,constraint STATS$SESSTAT_PK primary key 
    (snap_id, dbid, instance_number, statistic#) 
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$SESSTAT_FK foreign key (snap_id, dbid, instance_number) 
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$SESSTAT  for STATS$SESSTAT;

/* ------------------------------------------------------------------------- */

create table          STATS$SYSTEM_EVENT
(snap_id              number(6)      not null
,dbid                 number         not null
,instance_number      number         not null
,event                varchar2(64)   not null
,total_waits          number
,total_timeouts       number
,time_waited_micro    number
,constraint STATS$SYSTEM_EVENT_PK primary key 
    (snap_id, dbid, instance_number, event) 
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$SYSTEM_EVENT_FK foreign key (snap_id, dbid, instance_number) 
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$SYSTEM_EVENT  for STATS$SYSTEM_EVENT;

/* ------------------------------------------------------------------------- */

create table          STATS$SESSION_EVENT
(snap_id              number(6)        not null
,dbid                 number           not null
,instance_number      number           not null
,event                varchar2(64)     not null
,total_waits          number
,total_timeouts       number
,time_waited_micro    number
,max_wait             number
,constraint STATS$SESSION_EVENT_PK primary key 
    (snap_id, dbid, instance_number, event) 
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$SESSION_EVENT_FK foreign key 
    (snap_id, dbid, instance_number) 
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$SESSION_EVENT  for STATS$SESSION_EVENT;

/* ------------------------------------------------------------------------- */

create table          STATS$BG_EVENT_SUMMARY
(snap_id              number(6)      not null
,dbid                 number         not null
,instance_number      number         not null
,event                varchar2(64)   not null
,total_waits          number
,total_timeouts       number
,time_waited_micro    number
,constraint STATS$BG_EVENT_SUMMARY_PK primary key 
    (snap_id, dbid, instance_number, event) 
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$BG_EVENT_SUMMARY_FK foreign key (snap_id, dbid, instance_number) 
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$BG_EVENT_SUMMARY  for STATS$BG_EVENT_SUMMARY;

/* ------------------------------------------------------------------------- */

create table          STATS$WAITSTAT
(snap_id              number(6)        not null
,dbid                 number           not null
,instance_number      number           not null
,class                varchar2(18)
,wait_count           number
,time                 number
,constraint STATS$WAITSTAT_PK primary key 
    (snap_id, dbid, instance_number, class)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$WAITSTAT_FK foreign key (snap_id, dbid, instance_number) 
    references STATS$SNAPSHOT on delete cascade
)tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$WAITSTAT  for STATS$WAITSTAT;

/* ------------------------------------------------------------------------- */

create table          STATS$ENQUEUE_STAT
(snap_id              number(6)        not null
,dbid                 number           not null
,instance_number      number           not null
,eq_type              varchar2(2)      not null
,total_req#           number
,total_wait#          number
,succ_req#            number
,failed_req#          number
,cum_wait_time        number 
,constraint STATS$ENQUEUE_STAT_PK primary key 
    (snap_id, dbid, instance_number, eq_type)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$ENQUEUE_STAT_FK foreign key (snap_id, dbid, instance_number)
    references STATS$SNAPSHOT on delete cascade
)tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$ENQUEUE_STAT  for STATS$ENQUEUE_STAT;
 
/* ------------------------------------------------------------------------- */

create table          STATS$SQL_SUMMARY
(snap_id              number(6)        not null
,dbid                 number           not null
,instance_number      number           not null
,text_subset          varchar2(31)     not null
,sql_text             varchar2(1000)
,sharable_mem         number
,sorts                number
,module               varchar2(64)
,loaded_versions      number
,fetches              number
,executions           number
,loads                number
,invalidations        number
,parse_calls          number
,disk_reads           number
,buffer_gets          number
,rows_processed       number
,command_type         number
,address              raw(8)
,hash_value           number
,version_count        number
,cpu_time             number
,elapsed_time         number
,outline_sid          number
,outline_category     varchar2(64)
,child_latch          number
,constraint STATS$SQL_SUMMARY_PK primary key
    (snap_id, dbid, instance_number, hash_value, text_subset)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$SQL_SUMMARY_FK foreign key (snap_id, dbid, instance_number)
                references STATS$SNAPSHOT on delete cascade
)tablespace &&tablespace_name
storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$SQL_SUMMARY  for STATS$SQL_SUMMARY;
 
/* ------------------------------------------------------------------------- */

create table STATS$SQLTEXT
(hash_value      number       not null
,text_subset     varchar2(31) not null
,piece           number       not null
,sql_text        varchar2(64)
,address         raw(8)
,command_type    number
,last_snap_id    number
,constraint STATS$SQLTEXT_PK primary key (hash_value, text_subset, piece)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
) tablespace &&tablespace_name
  storage (initial 5m next 5m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$SQLTEXT  for STATS$SQLTEXT;

/* ------------------------------------------------------------------------- */

create table          STATS$SQL_STATISTICS
(snap_id              number(6)        not null
,dbid                 number           not null
,instance_number      number           not null
,total_sql            number           not null
,total_sql_mem        number           not null
,single_use_sql       number           not null
,single_use_sql_mem   number           not null
,constraint STATS$SQL_STATISTICS_PK primary key 
    (snap_id, dbid, instance_number)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$SQL_STATISTICS_FK foreign key 
    (snap_id, dbid, instance_number)
   references STATS$SNAPSHOT on delete cascade
)tablespace &&tablespace_name
storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$SQL_STATISTICS  for STATS$SQL_STATISTICS;
 
/* ------------------------------------------------------------------------- */

create table          STATS$RESOURCE_LIMIT
(snap_id              number(6)        not null
,dbid                 number           not null
,instance_number      number           not null
,resource_name        varchar2(30)     not null
,current_utilization  number
,max_utilization      number
,initial_allocation   varchar2(10)
,limit_value          varchar2(10)
,constraint STATS$RESOURCE_LIMIT_PK primary key
    (snap_id, dbid, instance_number, resource_name)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$RESOURCE_LIMIT_FK foreign key
    (snap_id, dbid, instance_number)
   references STATS$SNAPSHOT on delete cascade
)tablespace &&tablespace_name
storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$RESOURCE_LIMIT  for STATS$RESOURCE_LIMIT;

/* ------------------------------------------------------------------------- */

create table STATS$DLM_MISC
(snap_id              number(6)       not null
,dbid                 number          not null
,instance_number      number          not null
,statistic#           number          not null
,name                 varchar2(38)
,value                number
,constraint STATS$DLM_MISC_PK primary key
    (snap_id, dbid, instance_number, statistic#)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$DLM_MISC_FK foreign key
    (snap_id, dbid, instance_number)
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$DLM_MISC  for STATS$DLM_MISC;

/* ------------------------------------------------------------------------- */

create table STATS$UNDOSTAT
(begin_time           date            not null
,end_time             date            not null
,dbid                 number          not null
,instance_number      number          not null
,snap_id              number(6)       not null
,undotsn              number          not null
,undoblks             number
,txncount             number
,maxquerylen          number
,maxconcurrency       number
,unxpstealcnt         number
,unxpblkrelcnt        number
,unxpblkreucnt        number
,expstealcnt          number
,expblkrelcnt         number
,expblkreucnt         number
,ssolderrcnt          number
,nospaceerrcnt        number
,constraint STATS$UNDOSTAT_PK primary key
    (begin_time, end_time, dbid, instance_number)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$UNDOSTAT  for STATS$UNDOSTAT;

/* ------------------------------------------------------------------------- */

create table STATS$SQL_PLAN_USAGE
(snap_id              number(6)        not null
,dbid                 number           not null
,instance_number      number           not null
,hash_value           number           not null
,text_subset          varchar2(31)     not null
,plan_hash_value      number           not null
,cost                 number
,address              raw(8)
,optimizer            varchar2(20)
,constraint STATS$SQL_PLAN_USAGE_PK primary key
    (snap_id, dbid, instance_number
    ,hash_value, text_subset, plan_hash_value, cost)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$SQL_PLAN_USAGE_FK foreign key
    (snap_id, dbid, instance_number)
   references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 5m next 5m pctincrease 0) pctfree 5 pctused 40;

create index STATS$SQL_PLAN_USAGE_HV ON STATS$SQL_PLAN_USAGE (hash_value)
  tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0);

create public synonym  STATS$SQL_PLAN_USAGE  for STATS$SQL_PLAN_USAGE;

/* ------------------------------------------------------------------------- */

create table STATS$SQL_PLAN
(plan_hash_value      number          not null
,id                   number          not null
,operation            varchar2(30)
,options              varchar2(30)
,object_node          varchar2(10)
,object#              number
,object_owner         varchar2(30)
,object_name          varchar2(30)
,optimizer            varchar2(20)
,parent_id            number
,depth                number
,position             number
,search_columns       number
,cost                 number
,cardinality          number
,bytes                number
,other_tag            varchar2(35)
,partition_start      varchar2(5)
,partition_stop       varchar2(5)
,partition_id         number
,other                varchar2(4000)
,distribution         varchar2(20)
,cpu_cost             number
,io_cost              number
,temp_space           number
,access_predicates    varchar2(4000)
,filter_predicates    varchar2(4000)
,snap_id              number
,constraint STATS$SQL_PLAN_PK primary key
    (plan_hash_value, id)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
) tablespace &&tablespace_name
  storage (initial 5m next 5m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$SQL_PLAN  for STATS$SQL_PLAN;

/* ------------------------------------------------------------------------- */

create table STATS$SEG_STAT
(snap_id                         number(6)   not null
,dbid                            number      not null
,instance_number                 number      not null
,dataobj#                        number      not null
,obj#                            number      not null
,ts#                             number      not null
,logical_reads                   number
,buffer_busy_waits                number
,db_block_changes                number
,physical_reads                  number
,physical_writes                 number
,direct_physical_reads           number
,direct_physical_writes          number
,global_cache_cr_blocks_served   number
,global_cache_cu_blocks_served   number
,itl_waits                       number
,row_lock_waits                  number
, constraint STATS$SEG_STAT_PK primary key
   (snap_id, dbid, instance_number, dataobj#, obj#)
  using index tablespace &&tablespace_name
    storage (initial 1m next 1m pctincrease 0)
,constraint STATS$SEG_STAT_FK foreign key
    (snap_id, dbid, instance_number)
   references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
    storage (initial 3m next 3m pctincrease 0);

create public synonym STATS$SEG_STAT for STATS$SEG_STAT;

-- Segment names having statistics

create table STATS$SEG_STAT_OBJ
(dataobj#             number      not null
,obj#                 number      not null
,ts#                  number      not null
,dbid                 number      not null
,owner                varchar(30) not null
,object_name          varchar(30) not null
,subobject_name       varchar(30)
,object_type          varchar2(18)
,tablespace_name      varchar(30) not null
,constraint STATS$SEG_STAT_OBJ_PK primary key
  (dataobj#, obj#, dbid)
  using index tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0)
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0);

create public synonym STATS$SEG_STAT_OBJ for STATS$SEG_STAT_OBJ;

/* ------------------------------------------------------------------------- */

create table STATS$PGASTAT
(snap_id              number(6)       not null
,dbid                 number          not null
,instance_number      number          not null
,name                 varchar2(64)    not null
,value                number
,constraint STATS$SQL_PGASTAT_PK primary key
    (snap_id, dbid, instance_number, name)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$SQL_PGASTAT_FK foreign key
     (snap_id, dbid, instance_number)
     references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$PGASTAT  for STATS$PGASTAT;

/* ------------------------------------------------------------------------- */

create table          STATS$IDLE_EVENT
(event                varchar2(64)     not null
,constraint STATS$IDLE_EVENT_PK primary key (event)
 using index tablespace &&tablespace_name
   storage (initial 100k next 100k pctincrease 0)
) tablespace &&tablespace_name
  storage (initial 100k next 100k pctincrease 0) pctfree 5 pctused 40;

insert into STATS$IDLE_EVENT (event) values ('smon timer');
insert into STATS$IDLE_EVENT (event) values ('pmon timer');
insert into STATS$IDLE_EVENT (event) values ('rdbms ipc message');
insert into STATS$IDLE_EVENT (event) values ('Null event');
insert into STATS$IDLE_EVENT (event) values ('parallel query dequeue');
insert into STATS$IDLE_EVENT (event) values ('pipe get');
insert into STATS$IDLE_EVENT (event) values ('client message');
insert into STATS$IDLE_EVENT (event) values ('SQL*Net message to client');
insert into STATS$IDLE_EVENT (event) values ('SQL*Net message from client');
insert into STATS$IDLE_EVENT (event) values ('SQL*Net more data from client');
insert into STATS$IDLE_EVENT (event) values ('dispatcher timer');
insert into STATS$IDLE_EVENT (event) values ('virtual circuit status');
insert into STATS$IDLE_EVENT (event) values ('lock manager wait for remote message');
insert into STATS$IDLE_EVENT (event) values ('PX Idle Wait');
insert into STATS$IDLE_EVENT (event) values ('PX Deq: Execution Msg');
insert into STATS$IDLE_EVENT (event) values ('PX Deq: Table Q Normal');
insert into STATS$IDLE_EVENT (event) values ('wakeup time manager');
insert into STATS$IDLE_EVENT (event) values ('slave wait');
insert into STATS$IDLE_EVENT (event) values ('i/o slave wait');
insert into STATS$IDLE_EVENT (event) values ('jobq slave wait');
insert into STATS$IDLE_EVENT (event) values ('null event');
insert into STATS$IDLE_EVENT (event) values ('gcs remote message');
insert into STATS$IDLE_EVENT (event) values ('gcs for action');
insert into STATS$IDLE_EVENT (event) values ('ges remote message');
insert into STATS$IDLE_EVENT (event) values ('queue messages');
commit;

create public synonym  STATS$IDLE_EVENT   for STATS$IDLE_EVENT;

/* ------------------------------------------------------------------------- */

create table          STATS$PARAMETER
(snap_id              number(6)        not null
,dbid                 number           not null
,instance_number      number           not null
,name                 varchar2(64)     not null
,value                varchar2(512)
,isdefault            varchar2(9)
,ismodified           varchar2(10)
,constraint STATS$PARAMETER_PK primary key 
    (snap_id, dbid, instance_number, name)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$PARAMETER_FK foreign key (snap_id, dbid, instance_number)
                references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$PARAMETER  for STATS$PARAMETER;

/* ------------------------------------------------------------------------- */

create table          STATS$INSTANCE_RECOVERY
(snap_id                          number(6)        not null
,dbid                             number           not null
,instance_number                  number           not null
,recovery_estimated_ios           number
,actual_redo_blks                 number
,target_redo_blks                 number
,log_file_size_redo_blks          number
,log_chkpt_timeout_redo_blks      number
,log_chkpt_interval_redo_blks     number
,fast_start_io_target_redo_blks   number
,target_mttr                      number
,estimated_mttr                   number
,ckpt_block_writes                number
,constraint STATS$INSTANCE_RECOVERY_PK primary key 
    (snap_id, dbid, instance_number)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$INSTANCE_RECOVERY_FK foreign key 
    (snap_id, dbid, instance_number)
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$INSTANCE_RECOVERY  for STATS$INSTANCE_RECOVERY;

/* ------------------------------------------------------------------------- */

create table          STATS$STATSPACK_PARAMETER
(dbid                 number         not null
,instance_number      number         not null
,session_id           number         not null
,snap_level           number         not null
,num_sql              number         not null
,executions_th        number         not null
,parse_calls_th       number         not null
,disk_reads_th        number         not null
,buffer_gets_th       number         not null
,sharable_mem_th      number         not null
,version_count_th     number         not null
,pin_statspack        varchar2(10)   not null
,all_init             varchar2(5)    not null
,last_modified        date
,ucomment             varchar2(160)
,job                  number
,seg_phy_reads_th     number         not null
,seg_log_reads_th     number         not null
,seg_buff_busy_th     number         not null
,seg_rowlock_w_th     number         not null
,seg_itl_waits_th     number         not null
,seg_cr_bks_sd_th     number         not null
,seg_cu_bks_sd_th     number         not null
,constraint STATS$STATSPACK_PARAMETER_PK primary key 
    (dbid, instance_number)
 using index tablespace &&tablespace_name
   storage (initial 100k next 100k pctincrease 0)
,constraint STATS$STATSPACK_LVL_FK
    foreign key (snap_level) references STATS$LEVEL_DESCRIPTION
,constraint STATS$STATSPACK_P_PIN_CK
    check (pin_statspack in ('TRUE', 'FALSE'))
,constraint STATS$STATSPACK_ALL_INIT_CK
    check (all_init in ('TRUE', 'FALSE'))
) tablespace &&tablespace_name
  storage (initial 100k next 100k pctincrease 0);

create public synonym  STATS$STATSPACK_PARAMETER  for STATS$STATSPACK_PARAMETER;


/* ------------------------------------------------------------------------- */

create table STATS$SHARED_POOL_ADVICE
(snap_id                        number(6)  not null
,dbid                           number     not null
,instance_number                number     not null
,shared_pool_size_for_estimate  number     not null
,shared_pool_size_factor        number
,estd_lc_size                   number
,estd_lc_memory_objects         number
,estd_lc_time_saved             number
,estd_lc_time_saved_factor      number
,estd_lc_memory_object_hits     number
,constraint STATS$SHARED_POOL_ADVICE_PK primary key 
     (snap_id, dbid, instance_number, shared_pool_size_for_estimate)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$SHARED_POOL_ADVICE_FK foreign key 
     (snap_id, dbid, instance_number)
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;
 
create public synonym  STATS$SHARED_POOL_ADVICE  for STATS$SHARED_POOL_ADVICE;

/* ------------------------------------------------------------------------- */

create table STATS$SQL_WORKAREA_HISTOGRAM
(snap_id                        number(6)  not null
,dbid                           number     not null
,instance_number                number     not null
,low_optimal_size               number     not null
,high_optimal_size              number     not null
,optimal_executions             number
,onepass_executions             number
,multipasses_executions         number
,total_executions               number
,constraint STATS$SQL_WORKAREA_HIST_PK primary key 
     (snap_id, dbid, instance_number, low_optimal_size, high_optimal_size)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$SQL_WORKAREA_HIST_FK foreign key 
     (snap_id, dbid, instance_number)
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$SQL_WORKAREA_HISTOGRAM  for STATS$SQL_WORKAREA_HISTOGRAM;


/* ------------------------------------------------------------------------- */

create table STATS$PGA_TARGET_ADVICE
(snap_id                        number(6)  not null
,dbid                           number     not null
,instance_number                number     not null
,pga_target_for_estimate        number     not null
,pga_target_factor              number
,advice_status                  varchar2(3)
,bytes_processed                number
,estd_extra_bytes_rw            number
,estd_pga_cache_hit_percentage  number
,estd_overalloc_count           number
,constraint STATS$PGA_TARGET_ADVICE_PK primary key 
     (snap_id, dbid, instance_number, pga_target_for_estimate)
 using index tablespace &&tablespace_name
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$PGA_TARGET_ADVICE_FK foreign key 
     (snap_id, dbid, instance_number)
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tablespace_name
  storage (initial 1m next 1m pctincrease 0) pctfree 5 pctused 40;

create public synonym  STATS$PGA_TARGET_ADVICE  for STATS$PGA_TARGET_ADVICE;


/* ------------------------------------------------------------------------- */

-- In anticipation of creating statspack
create public synonym STATSPACK  for STATSPACK;

/* ------------------------------------------------------------------------- */

prompt
prompt NOTE:
prompt   SPCTAB complete. Please check spctab.lis for any errors.
prompt

spool off;
undefine tablespace_name default_tablespace temporary_tablespace
whenever sqlerror continue;
set echo on;
