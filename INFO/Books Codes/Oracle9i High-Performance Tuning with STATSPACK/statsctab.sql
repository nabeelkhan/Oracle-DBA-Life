Rem
Rem $Header: statsctab.sql 13-aug-99.11:03:16 cdialeri Exp $
Rem
Rem statsctab.sql
Rem
Rem  Copyright (c) Oracle Corporation 1999. All Rights Reserved.
Rem
Rem    NAME
Rem      statsctab.sql
Rem
Rem    DESCRIPTION
Rem	 SQL*PLUS command file to create tables to hold
Rem      start and end "snapshot" statistical information
Rem
Rem    NOTES
Rem      Should be run as STATSPACK user, PERFSTAT
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    cdialeri    11/01/99 - Enhance, 1059172
Rem    cmlim       07/17/97 - Added STATS$SQLAREA to store top sql stmts
Rem    gwood       10/16/95 - Version to run as sys without using many views
Rem    cellis.uk   11/15/89 - Created
Rem

set showmode off echo off;
whenever sqlerror exit;

spool statsctab.lis

/* ------------------------------------------------------------------------- */

prompt
prompt  Below are the list of online tablespaces in this database.
prompt  Decide which tablespace you wish to create the STATSPACK tables
prompt  and indexes.  It is not recommended to use the system tablespace
prompt  for storing statistics data.
prompt
prompt  Ensure the PERFSTAT user has sufficient quota in the tablespace
prompt  you specify.
prompt

select tablespace_name 
  from sys.dba_tablespaces 
 where tablespace_name <> 'SYSTEM'
   and status = 'ONLINE';
prompt
accept tbsn prompt "Enter tablespace where STATSPACK objects will be created: "

/* ------------------------------------------------------------------------- */

Prompt ... Creating STATS$SNAPSHOT_ID Sequence

create sequence       STATS$SNAPSHOT_ID
       start with   1
       increment by 1
       nomaxvalue
       cache 10;

create public synonym STATS$SNAPSHOT_ID  for STATS$SNAPSHOT_ID;
grant select       on STATS$SNAPSHOT_ID  to  PUBLIC;

/* ------------------------------------------------------------------------- */

Prompt ... Creating STATS$... tables

create table          STATS$DATABASE_INSTANCE
(dbid                 number       not null
,instance_number      number       not null
,db_name              varchar2(9)  not null
,instance_name        varchar2(16) not null
,host_name            varchar2(64)
,constraint STATS$DATABASE_INSTANCE_PK primary key (dbid, instance_number)
) tablespace &&tbsn
;

create public synonym  STATS$DATABASE_INSTANCE  for STATS$DATABASE_INSTANCE;
grant select on        STATS$DATABASE_INSTANCE  to  PUBLIC;

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
,constraint STATS$SNAPSHOT_PK primary key (snap_id, dbid, instance_number)
,constraint STATS$SNAPSHOT_FK foreign key (dbid, instance_number)
    references STATS$DATABASE_INSTANCE on delete cascade
) tablespace &&tbsn
  storage (initial 1m next 1m pctincrease 0) pctfree 0 pctused 40;

create public synonym  STATS$SNAPSHOT  for STATS$SNAPSHOT;
grant select on        STATS$SNAPSHOT  to  PUBLIC;

/* ------------------------------------------------------------------------- */

create table          STATS$FILESTATXS
(snap_id              number(6)       not null
,dbid                 number          not null
,instance_number      number          not null
,tsname               varchar2 (30)   not null
,filename             varchar2 (257)  not null
,phyrds               number
,phywrts              number
,readtim              number
,writetim             number
,phyblkrd             number
,phyblkwrt            number
,wait_count           number
,time                 number
,constraint STATS$FILESTATXS_PK primary key 
     (snap_id, dbid, instance_number, tsname, filename)
 using index tablespace &&tbsn
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$FILESTATXS_FK foreign key (snap_id, dbid, instance_number)
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tbsn
  storage (initial 1m next 1m pctincrease 0) pctfree 0 pctused 40;
 
create public synonym  STATS$FILESTATXS  for STATS$FILESTATXS;
grant select on        STATS$FILESTATXS  to  PUBLIC;
 
/* ------------------------------------------------------------------------- */

create table          STATS$LATCH
(snap_id              number(6)       not null
,dbid                 number          not null
,instance_number      number          not null
,name                 varchar2 (64)   not null
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
,constraint STATS$LATCH_PK primary key 
    (snap_id, dbid, instance_number, name) 
 using index tablespace &&tbsn
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$LATCH_FK foreign key (snap_id, dbid, instance_number) 
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tbsn
  storage (initial 1m next 1m pctincrease 0) pctfree 0 pctused 40;

create public synonym  STATS$LATCH  for STATS$LATCH;
grant select on        STATS$LATCH  to  PUBLIC;

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
,constraint STATS$LATCH_CHILDREN_PK primary key 
    (snap_id, dbid, instance_number, latch#, child#) 
,constraint STATS$LATCH_CHILDREN_FK foreign key 
    (snap_id, dbid, instance_number) 
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tbsn
  storage (initial 1m next 1m pctincrease 0) pctfree 0 pctused 40;

create public synonym  STATS$LATCH_CHILDREN  for STATS$LATCH_CHILDREN;
grant select on        STATS$LATCH_CHILDREN  to  PUBLIC;

/* ------------------------------------------------------------------------- */

create table          STATS$LATCH_MISSES_SUMMARY
(snap_id              number(6)        not null
,dbid                 number           not null
,instance_number      number           not null
,parent_name          varchar2(50)
,where_in_code        varchar2(64)
,nwfail_count         number
,sleep_count          number
,constraint STATS$LATCH_MISSES_SUMMARY_PK primary key 
    (snap_id, dbid, instance_number, parent_name, where_in_code)
,constraint STATS$LATCH_MISSES_SUMMARY_FK foreign key 
    (snap_id, dbid, instance_number)
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tbsn
  storage (initial 1m next 1m pctincrease 0) pctfree 0 pctused 40;
 
create public synonym  STATS$LATCH_MISSES_SUMMARY  for STATS$LATCH_MISSES_SUMMARY;
grant select on        STATS$LATCH_MISSES_SUMMARY  to  PUBLIC;

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
,constraint STATS$LIBRARYCACHE_FK foreign key 
    (snap_id, dbid, instance_number) 
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tbsn
  storage (initial 1m next 1m pctincrease 0) pctfree 0 pctused 40;

create public synonym  STATS$LIBRARYCACHE  for STATS$LIBRARYCACHE;
grant select on        STATS$LIBRARYCACHE  to  PUBLIC;

/* ------------------------------------------------------------------------- */

create table         STATS$BUFFER_POOL
(snap_id             number(6)        not null
,dbid                number           not null
,instance_number     number           not null
,name                varchar2(20)      
,lo_setid            number
,set_count           number
,buffers             number
,constraint STATS$BUFFER_POOL_PK primary key
    (snap_id, dbid, instance_number, name)
,constraint STATS$BUFFER_POOL_FK foreign key 
    (snap_id, dbid, instance_number) 
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tbsn
  storage (initial 1m next 1m pctincrease 0) pctfree 0 pctused 40;

create public synonym  STATS$BUFFER_POOL  for STATS$BUFFER_POOL;
grant select on        STATS$BUFFER_POOL  to  PUBLIC;

/* ------------------------------------------------------------------------- */

create table             STATS$BUFFER_POOL_STATISTICS
(snap_id                 number(6)        not null
,dbid                    number           not null
,instance_number         number           not null
,id                      number           not null
,name                    varchar2(20)		
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
,constraint STATS$BUFFER_POOL_STATS_FK foreign key
     (snap_id, dbid, instance_number)
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tbsn
  storage (initial 1m next 1m pctincrease 0) pctfree 0 pctused 40;

create public synonym  STATS$BUFFER_POOL_STATISTICS  for STATS$BUFFER_POOL_STATISTICS;
grant select on        STATS$BUFFER_POOL_STATISTICS  to  PUBLIC;
 
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
 using index tablespace &&tbsn
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$ROLLSTAT_FK foreign key (snap_id, dbid, instance_number) 
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tbsn
  storage (initial 1m next 1m pctincrease 0) pctfree 0 pctused 40;

create public synonym  STATS$ROLLSTAT  for STATS$ROLLSTAT;
grant select on        STATS$ROLLSTAT  to  PUBLIC;

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
 using index tablespace &&tbsn
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$ROWCACHE_SUMMARY_FK foreign key 
    (snap_id, dbid, instance_number) 
        references STATS$SNAPSHOT on delete cascade
) tablespace &&tbsn
  storage (initial 1m next 1m pctincrease 0) pctfree 0 pctused 40;

create public synonym  STATS$ROWCACHE_SUMMARY  for STATS$ROWCACHE_SUMMARY;
grant select on        STATS$ROWCACHE_SUMMARY  to  PUBLIC;

/* ------------------------------------------------------------------------- */

create table          STATS$SGAXS
(snap_id              number (6)       not null
,dbid                 number           not null
,instance_number      number           not null
,startup_time         date             not null
,parallel             varchar2(3)      not null
,name                 varchar2(64)     not null
,version              varchar2(17)
,value                number
,constraint STATS$SGAXS_PK primary key 
    (snap_id, dbid, instance_number, name)
,constraint STATS$SGAXS_FK foreign key (snap_id, dbid, instance_number) 
        references STATS$SNAPSHOT on delete cascade
) tablespace &&tbsn
  storage (initial 1m next 1m pctincrease 0) pctfree 0 pctused 40;

create public synonym  STATS$SGAXS  for STATS$SGAXS;
grant select on        STATS$SGAXS  to  PUBLIC;

/* ------------------------------------------------------------------------- */

create table          STATS$SGASTAT_SUMMARY
(snap_id              number           not null
,dbid                 number           not null
,instance_number      number           not null
,name                 varchar2(64)     not null 
,bytes                number
,constraint STATS$SGASTAT_SUMMARY_PK primary key 
    (snap_id, dbid, instance_number, name)
 using index tablespace &&tbsn
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$SGASTAT_SUMMARY_FK foreign key 
    (snap_id, dbid, instance_number) 
        references STATS$SNAPSHOT on delete cascade
) tablespace &&tbsn
  storage (initial 1m next 1m pctincrease 0) pctfree 0 pctused 40;

create public synonym  STATS$SGASTAT_SUMMARY  for STATS$SGASTAT_SUMMARY;
grant select on        STATS$SGASTAT_SUMMARY  to  PUBLIC;

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
 using index tablespace &&tbsn
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$SYSSTAT_FK foreign key (snap_id, dbid, instance_number) 
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tbsn
  storage (initial 1m next 1m pctincrease 0) pctfree 0 pctused 40;

create public synonym  STATS$SYSSTAT  for STATS$SYSSTAT;
grant select on        STATS$SYSSTAT  to  PUBLIC;

/* ------------------------------------------------------------------------- */

create table          STATS$SESSTAT
(snap_id              number(6)       not null
,dbid                 number          not null
,instance_number      number          not null
,statistic#           number          not null
,value                number
,constraint STATS$SESSTAT_PK primary key 
    (snap_id, dbid, instance_number, statistic#) 
 using index tablespace &&tbsn
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$SESSTAT_FK foreign key (snap_id, dbid, instance_number) 
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tbsn
  storage (initial 1m next 1m pctincrease 0) pctfree 0 pctused 40;

create public synonym  STATS$SESSTAT  for STATS$SESSTAT;
grant select on        STATS$SESSTAT  to  PUBLIC;

/* ------------------------------------------------------------------------- */

create table          STATS$SYSTEM_EVENT
(snap_id              number(6)      not null
,dbid                 number         not null
,instance_number      number         not null
,event                varchar2(64)   not null
,total_waits          number
,total_timeouts       number
,time_waited          number
,constraint STATS$SYSTEM_EVENT_PK primary key 
    (snap_id, dbid, instance_number, event) 
 using index tablespace &&tbsn
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$SYSTEM_EVENT_FK foreign key (snap_id, dbid, instance_number) 
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tbsn
  storage (initial 1m next 1m pctincrease 0) pctfree 0 pctused 40;

create public synonym  STATS$SYSTEM_EVENT  for STATS$SYSTEM_EVENT;
grant select on        STATS$SYSTEM_EVENT  to  PUBLIC;

/* ------------------------------------------------------------------------- */

create table          STATS$SESSION_EVENT
(snap_id              number(6)        not null
,dbid                 number           not null
,instance_number      number           not null
,event                varchar2(64)     not null
,total_waits          number
,total_timeouts       number
,time_waited          number
,constraint STATS$SESSION_EVENT_PK primary key 
    (snap_id, dbid, instance_number, event) 
 using index tablespace &&tbsn
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$SESSION_EVENT_FK foreign key 
    (snap_id, dbid, instance_number) 
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tbsn
  storage (initial 1m next 1m pctincrease 0) pctfree 0 pctused 40;

create public synonym  STATS$SESSION_EVENT  for STATS$SESSION_EVENT;
grant select on        STATS$SESSION_EVENT  to  PUBLIC;

/* ------------------------------------------------------------------------- */

create table          STATS$BG_EVENT_SUMMARY
(snap_id              number(6)      not null
,dbid                 number         not null
,instance_number      number         not null
,event                varchar2(64)   not null
,total_waits          number
,total_timeouts       number
,time_waited          number
,constraint STATS$BG_EVENT_SUMMARY_PK primary key 
    (snap_id, dbid, instance_number, event) 
 using index tablespace &&tbsn
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$BG_EVENT_SUMMARY_FK foreign key (snap_id, dbid, instance_number) 
    references STATS$SNAPSHOT on delete cascade
) tablespace &&tbsn
  storage (initial 1m next 1m pctincrease 0) pctfree 0 pctused 40;

create public synonym  STATS$BG_EVENT_SUMMARY  for STATS$BG_EVENT_SUMMARY;
grant select on        STATS$BG_EVENT_SUMMARY  to  PUBLIC;

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
 using index tablespace &&tbsn
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$WAITSTAT_FK foreign key (snap_id, dbid, instance_number) 
    references STATS$SNAPSHOT on delete cascade
)tablespace &&tbsn
  storage (initial 1m next 1m pctincrease 0) pctfree 0 pctused 40;

create public synonym  STATS$WAITSTAT  for STATS$WAITSTAT;
grant select on        STATS$WAITSTAT  to  PUBLIC;

/* ------------------------------------------------------------------------- */

create table          STATS$ENQUEUESTAT
(snap_id              number(6)        not null
,dbid                 number           not null
,instance_number      number           not null
,name                 varchar2(2)
,gets                 number
,waits                number
,constraint STATS$ENQUEUESTAT_PK primary key 
    (snap_id, dbid, instance_number, name)
,constraint STATS$ENQUEUESTAT_FK foreign key (snap_id, dbid, instance_number)
    references STATS$SNAPSHOT on delete cascade
)tablespace &&tbsn
  storage (initial 1m next 1m pctincrease 0) pctfree 0 pctused 40;

create public synonym  STATS$ENQUEUESTAT  for STATS$ENQUEUESTAT;
grant select on        STATS$ENQUEUESTAT  to  PUBLIC;
 
/* ------------------------------------------------------------------------- */

create table          STATS$SQL_SUMMARY
(snap_id              number(6)        not null
,dbid                 number           not null
,instance_number      number           not null
,sql_text             varchar2(1000)
,sharable_mem         number
,sorts                number
,module               varchar2(64)
,loaded_versions      number
,executions           number
,loads                number
,invalidations        number
,parse_calls          number
,disk_reads           number
,buffer_gets          number
,rows_processed       number
,address              raw(8)
,hash_value           number
,version_count        number
,constraint STATS$SQL_SUMMARY_PK primary key 
    (snap_id, dbid, instance_number, hash_value, address)
 using index tablespace &&tbsn
   storage (initial 1m next 1m pctincrease 0)
,constraint STATS$SQL_SUMMARY_FK foreign key (snap_id, dbid, instance_number)
                references STATS$SNAPSHOT on delete cascade
)tablespace &&tbsn
storage (initial 1m next 1m pctincrease 0) pctfree 0 pctused 40;

create public synonym  STATS$SQL_SUMMARY  for STATS$SQL_SUMMARY;
grant select on        STATS$SQL_SUMMARY  to  PUBLIC;
 
/* ------------------------------------------------------------------------- */

create table          STATS$LEVEL_DESCRIPTION
(snap_level           number          not null
,description          varchar2(300)
,constraint STATS$LEVEL_DESCRIPTION_PK primary key (snap_level)
) tablespace &&tbsn
;

insert into STATS$LEVEL_DESCRIPTION (snap_level, description)
  values (0,  'This level captures general statistics, including rollback segment, row cache, SGA, system events, background events, session events, system statistics, wait statistics, lock statistics, and Latch information');

insert into STATS$LEVEL_DESCRIPTION (snap_level, description)
  values (5,  'This level includes capturing high resource usage SQL Statements, along with all data captured by lower levels');

insert into STATS$LEVEL_DESCRIPTION (snap_level, description)
  values (10,  'This level includes capturing Child Latch statistics, along with all data captured by lower levels');

commit;

create public synonym  STATS$LEVEL_DESCRIPTION   for STATS$LEVEL_DESCRIPTION;
grant select on        STATS$LEVEL_DESCRIPTION   to  PUBLIC;

/* ------------------------------------------------------------------------- */

create table          STATS$IDLE_EVENT
(event                varchar2(64)     not null
,constraint STATS$IDLE_EVENT_PK primary key (event)
) tablespace &&tbsn
;

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
commit;

create public synonym  STATS$IDLE_EVENT   for STATS$IDLE_EVENT;
grant select on        STATS$IDLE_EVENT   to  PUBLIC;

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
,constraint STATS$PARAMETER_FK foreign key (snap_id, dbid, instance_number)
                references STATS$SNAPSHOT on delete cascade
) tablespace &&tbsn
  storage (initial 1m next 1m pctincrease 0) pctfree 0 pctused 40;

create public synonym  STATS$PARAMETER  for STATS$PARAMETER;
grant select on        STATS$PARAMETER  to  PUBLIC;

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
,pin_statspack        varchar2(10)   not null
,last_modified        date
,ucomment             varchar2(160)
,job                  number
,constraint STATS$STATSPACK_PARAMETER_PK primary key 
    (dbid, instance_number)
,constraint STATS$STATSPACK_PARAMETER_FK foreign key (dbid, instance_number)
    references STATS$DATABASE_INSTANCE on delete cascade
,constraint STATS$STATSPACK_P_PIN_CK
    check (pin_statspack in ('true','false','TRUE','FALSE'))
) tablespace &&tbsn
;

create public synonym  STATS$STATSPACK_PARAMETER  for STATS$STATSPACK_PARAMETER;
grant select on        STATS$STATSPACK_PARAMETER  to  PUBLIC;

/* ------------------------------------------------------------------------- */
-- In anticipation of creating statspack
create public synonym STATSPACK  for STATSPACK;

/* ------------------------------------------------------------------------- */

prompt
prompt NOTE:
prompt   STATSCTAB complete. Please check statsctab.lis for any errors.
prompt

spool off;
whenever sqlerror continue;
set echo on;
