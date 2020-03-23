Rem
Rem $Header: spcusr.sql 17-apr-2002.18:41:23 vbarrier Exp $
Rem
Rem spcusr.sql
Rem
Rem Copyright (c) 1999, 2002, Oracle Corporation.  All rights reserved.  
Rem
Rem    NAME
Rem      spcusr.sql
Rem
Rem    DESCRIPTION
Rem      SQL*Plus command file to create user which will contain the
Rem      STATSPACK database objects.
Rem
Rem    NOTES
Rem      Must be run from connected to SYS (or internal)
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    vbarrier    04/01/02 - 2290728
Rem    vbarrier    03/05/02 - Segment Statistics
Rem    cdialeri    02/07/02 - 2218573
Rem    cdialeri    11/30/01 - 9.2 - features 1
Rem    cdialeri    04/26/01 - 9.0
Rem    cdialeri    09/12/00 - sp_1404195
Rem    cdialeri    04/07/00 - 1261813
Rem    cdialeri    02/16/00 - 1191805
Rem    cdialeri    01/26/00 - 1169401
Rem    cdialeri    11/01/99 - 1059172
Rem    cdialeri    08/13/99 - Created
Rem


set echo off verify off showmode off;
whenever sqlerror exit;

spool spcusr.lis

prompt ... Installing Required Packages

Rem
Rem  Install required packages
Rem

@@dbmspool
@@dbmsjob


Rem
Rem  Create X$views as a temporary workaround to externalizing these objects
Rem  through V$views

create or replace view STATS$X_$KCBFWAIT as select * from X$KCBFWAIT;
create or replace public synonym  STATS$X$KCBFWAIT for STATS$X_$KCBFWAIT;
create or replace view STATS$X_$KSPPSV as select * from X$KSPPSV;
create or replace public synonym  STATS$X$KSPPSV for STATS$X_$KSPPSV;
create or replace view STATS$X_$KSPPI as select * from X$KSPPI;
create or replace public synonym STATS$X$KSPPI for STATS$X_$KSPPI;

create or replace view STATS$V_$FILESTATXS as
select ts.name      tsname
     , df.name	    filename
     , fs.phyrds
     , fs.phywrts
     , fs.readtim
     , fs.writetim
     , fs.singleblkrds
     , fs.phyblkrd
     , fs.phyblkwrt
     , fs.singleblkrdtim
     , fw.count     wait_count
     , fw.time      time
  from x$kcbfwait   fw
     , v$filestat   fs
     , v$tablespace ts
     , v$datafile   df
 where ts.ts#    = df.ts#
   and fs.file#  = df.file#
   and fw.indx+1 = df.file#;
create or replace public synonym  STATS$V$FILESTATXS for STATS$V_$FILESTATXS;

create or replace view STATS$V_$TEMPSTATXS as
select ts.name      tsname
     , tf.name	    filename
     , tm.phyrds
     , tm.phywrts
     , tm.readtim
     , tm.writetim
     , tm.singleblkrds
     , tm.phyblkrd
     , tm.phyblkwrt
     , tm.singleblkrdtim
     , fw.count     wait_count
     , fw.time      time
  from x$kcbfwait   fw
     , v$tempstat   tm
     , v$tablespace ts
     , v$tempfile   tf
 where ts.ts#     = tf.ts#
   and tm.file#   = tf.file#
   and fw.indx+1  = (tf.file# + (select value from v$parameter where name='db_files'));
create or replace public synonym  STATS$V$TEMPSTATXS for STATS$V_$TEMPSTATXS;

create or replace view STATS$V_$SQLXS as
select max(sql_text)        sql_text
     , sum(sharable_mem)    sharable_mem
     , sum(sorts)           sorts
     , min(module)          module
     , sum(loaded_versions) loaded_versions
     , sum(fetches)         fetches
     , sum(executions)      executions
     , sum(loads)           loads
     , sum(invalidations)   invalidations
     , sum(parse_calls)     parse_calls
     , sum(disk_reads)      disk_reads
     , sum(buffer_gets)     buffer_gets
     , sum(rows_processed)  rows_processed
     , max(command_type)    command_type
     , address              address
     , hash_value           hash_value
     , count(1)             version_count
     , sum(cpu_time)        cpu_time
     , sum(elapsed_time)    elapsed_time
     , max(outline_sid)     outline_sid
     , max(outline_category) outline_category
     , max(is_obsolete)     is_obsolete
     , max(child_latch)     child_latch
  from v$sql
 group by hash_value, address;
create or replace public synonym STATS$V$SQLXS for STATS$V_$SQLXS; 

prompt ... Creating PERFSTAT user ...
prompt
prompt Choose the PERFSTAT user's password.
prompt
prompt Not specifying a password will result in the installation FAILING
prompt
prompt Specify PERFSTAT password
prompt &&perfstat_password

whenever sqlerror exit sql.sqlcode
begin
  if '&&perfstat_password' is null then
    raise_application_error(-20101, 'Install failed - No password specified for PERFSTAT user');
  end if;
end;
/
whenever sqlerror continue

Rem
Rem  Create PERFSTAT user and grant privileges
Rem

create user perfstat identified by &&perfstat_password;

/*  System privileges  */
grant create session              to PERFSTAT;
grant alter  session              to PERFSTAT;
grant create table                to PERFSTAT;
grant create procedure            to PERFSTAT;
grant create sequence             to PERFSTAT;
grant create public synonym       to PERFSTAT;
grant drop   public synonym       to PERFSTAT;

/*  Select privileges on STATSPACK created views  */
grant select on STATS$X_$KCBFWAIT       to PERFSTAT;
grant select on STATS$X_$KSPPSV         to PERFSTAT;
grant select on STATS$X_$KSPPI          to PERFSTAT;
grant select on STATS$V_$FILESTATXS     to PERFSTAT;
grant select on STATS$V_$TEMPSTATXS     to PERFSTAT;
grant select on STATS$V_$SQLXS          to PERFSTAT;

/*  Roles  */
grant SELECT_CATALOG_ROLE         to PERFSTAT;

/*  Select privs for catalog objects - ROLES disabled in PL/SQL packages  */
grant select on V_$PARAMETER      to PERFSTAT;
grant select on V_$SYSTEM_PARAMETER to PERFSTAT;
grant select on V_$DATABASE       to PERFSTAT;
grant select on V_$INSTANCE       to PERFSTAT;
grant select on V_$LIBRARYCACHE   to PERFSTAT;
grant select on V_$LATCH          to PERFSTAT;
grant select on V_$LATCH_MISSES   to PERFSTAT;
grant select on V_$LATCH_CHILDREN to PERFSTAT;
grant select on V_$LATCH_PARENT   to PERFSTAT;
grant select on V_$ROLLSTAT       to PERFSTAT;
grant select on V_$ROWCACHE       to PERFSTAT;
grant select on V_$SGA            to PERFSTAT;
grant select on V_$BUFFER_POOL    to PERFSTAT;
grant select on V_$SGASTAT        to PERFSTAT;
grant select on V_$SYSTEM_EVENT   to PERFSTAT;
grant select on V_$SESSION        to PERFSTAT;
grant select on V_$SESSION_EVENT  to PERFSTAT;
grant select on V_$SYSSTAT        to PERFSTAT;
grant select on V_$WAITSTAT       to PERFSTAT;
grant select on V_$ENQUEUE_STAT   to PERFSTAT;
grant select on V_$SQLAREA        to PERFSTAT;
grant select on V_$SQL            to PERFSTAT;
grant select on V_$SQLTEXT        to PERFSTAT;
grant select on V_$SESSTAT        to PERFSTAT;
grant select on V_$BUFFER_POOL_STATISTICS to PERFSTAT;
grant select on V_$RESOURCE_LIMIT to PERFSTAT;
grant select on V_$DLM_MISC       to PERFSTAT;
grant select on V_$UNDOSTAT       to PERFSTAT;
grant select on V_$SQL_PLAN       to PERFSTAT;
grant select on V_$DB_CACHE_ADVICE to PERFSTAT;
grant select on V_$PGASTAT        to PERFSTAT;
grant select on V_$INSTANCE_RECOVERY to PERFSTAT;
grant select on V_$SHARED_POOL_ADVICE     to PERFSTAT;
grant select on V_$SQL_WORKAREA_HISTOGRAM to PERFSTAT;
grant select on V_$PGA_TARGET_ADVICE      to PERFSTAT;
grant select on V_$SEGSTAT                  to PERFSTAT;
grant select on V_$SEGMENT_STATISTICS       to PERFSTAT;
grant select on V_$SEGSTAT_NAME             to PERFSTAT;



/*  Packages  */
grant execute on DBMS_SHARED_POOL to PERFSTAT;
grant execute on DBMS_JOB         to PERFSTAT;


Rem
Rem  Set up PERFSTAT's temporary and default tablespaces;
Rem

prompt
prompt Below are the list of online tablespaces in this database.
prompt Decide which tablespace you wish to create the STATSPACK tables
prompt and indexes.  This will also be the PERFSTAT user's default tablespace.
prompt
prompt Specifying the SYSTEM tablespace will result in the installation
prompt FAILING, as using SYSTEM for performance data is not supported.
prompt

select tablespace_name, contents
  from sys.dba_tablespaces 
 where tablespace_name <> 'SYSTEM'
   and status = 'ONLINE'
 order by tablespace_name;

prompt
prompt Specify PERFSTAT user's default   tablespace
prompt Using &&default_tablespace for the default tablespace

whenever sqlerror exit sql.sqlcode;
begin
  if upper('&&default_tablespace') = 'SYSTEM' then
    raise_application_error(-20101, 'Install failed - SYSTEM tablespace specified for DEFAULT tablespace');
  end if;
end;
/
alter user PERFSTAT quota unlimited on &&default_tablespace;
alter user PERFSTAT default tablespace &&default_tablespace;

prompt
prompt Choose the PERFSTAT user's temporary tablespace.
prompt
prompt Specifying the SYSTEM tablespace will result in the installation
prompt FAILING, as using SYSTEM for the temporary tablespace is not recommended.

prompt
prompt Specify PERFSTAT user's temporary tablespace.
prompt Using &&temporary_tablespace for the temporary tablespace
prompt

begin
  if upper('&&temporary_tablespace') = 'SYSTEM' then
    raise_application_error(-20101, 'Install failed - SYSTEM tablespace specified for TEMPORARY tablespace');
  end if;
end;
/
alter user PERFSTAT temporary tablespace &&temporary_tablespace;


prompt
prompt NOTE:
prompt   SPCUSR complete. Please check spcusr.lis for any errors.
prompt

spool off;
whenever sqlerror continue;
set echo on;
