Rem
Rem $Header: statscusr.sql 01-nov-99.15:59:06 cdialeri Exp $
Rem
Rem statscusr.sql
Rem
Rem  Copyright (c) Oracle Corporation 1999. All Rights Reserved.
Rem
Rem    NAME
Rem      statscusr.sql
Rem
Rem    DESCRIPTION
Rem      SQL*Plus command file to create user which will contain the
Rem      STATSPACK database objects.
Rem
Rem    NOTES
Rem      Must be run from connected to SYS (or internal)
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    cdialeri    11/01/99 - 1059172
Rem    cdialeri    08/13/99 - Created
Rem


set echo off verify off showmode off;
whenever sqlerror exit;

spool statscusr.lis

prompt ... Installing Required Packages

Rem
Rem  Install required packages
Rem

rem @@dbmspool
rem @@dbmsjob


Rem
Rem  Create X$views as a temporary workaround to externalizing these objects
Rem  through V$views

create view           X_$KCBFWAIT as select * from  X$KCBFWAIT;
create public synonym  X$KCBFWAIT for              X_$KCBFWAIT;
create view           X_$KSPPSV   as select * from  X$KSPPSV;
create public synonym  X$KSPPSV   for              X_$KSPPSV;
create view           X_$KSPPI    as select * from  X$KSPPI;
create public synonym  X$KSPPI    for              X_$KSPPI;
create view           X_$KSQST    as select * from  X$KSQST;
create public synonym  X$KSQST    for              X_$KSQST;

create view V_$FILESTATXS as
select ts.name      tsname
     , df.name	    filename
     , fs.phyrds
     , fs.phywrts
     , fs.readtim
     , fs.writetim
     , fs.phyblkrd
     , fs.phyblkwrt
     , fw.count     wait_count
     , fw.time      time
  from x$kcbfwait   fw
     , v$filestat   fs
     , v$tablespace ts
     , v$datafile   df
 where ts.ts#    = df.ts#
   and fs.file#  = df.file#
   and fw.indx+1 = df.file#;
create public synonym  V$FILESTATXS for V_$FILESTATXS;


prompt ... Creating PERFSTAT user

Rem
Rem  Create PERFSTAT user and grant privileges
Rem

create user perfstat identified by perfstat;

/*  System privileges  */
grant create session              to PERFSTAT;
grant alter  session              to PERFSTAT;
grant create table                to PERFSTAT;
grant create procedure            to PERFSTAT;
grant create sequence             to PERFSTAT;
grant create public synonym       to PERFSTAT;
grant drop   public synonym       to PERFSTAT;

/*  Select privileges on STATSPACK created views  */
grant select on X_$KCBFWAIT       to PERFSTAT;
grant select on X_$KSPPSV         to PERFSTAT;
grant select on X_$KSPPI          to PERFSTAT;
grant select on X_$KSQST          to PERFSTAT;
grant select on V$FILESTATXS      to PERFSTAT;

/*  Roles  */
grant SELECT_CATALOG_ROLE         to PERFSTAT;

/*  Select privs for catalog objects - ROLES disabled in PL/SQL packages  */
grant select on V_$PARAMETER      to PERFSTAT;
grant select on V_$DATABASE       to PERFSTAT;
grant select on V_$INSTANCE       to PERFSTAT;
grant select on V_$LIBRARYCACHE   to PERFSTAT;
grant select on V_$LATCH          to PERFSTAT;
grant select on V_$LATCH_MISSES   to PERFSTAT;
grant select on V_$LATCH_CHILDREN to PERFSTAT;
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
grant select on V_$SQLAREA        to PERFSTAT;
grant select on V_$SQL            to PERFSTAT;
grant select on V_$SESSTAT        to PERFSTAT;
grant select on V_$BUFFER_POOL_STATISTICS to PERFSTAT;

/*  Packages  */
grant execute on DBMS_SHARED_POOL to PERFSTAT;
grant execute on DBMS_JOB         to PERFSTAT;


Rem
Rem  Set up PERFSTAT's temporary and default tablespaces;
Rem

prompt
prompt  Below are the list of online tablespaces in this database.
prompt  Decide which tablespace you wish to create the STATSPACK tables
prompt  and indexes.  It is not recommended to use the system tablespace
prompt  for storing statistics data.

select tablespace_name 
  from sys.dba_tablespaces 
 where tablespace_name <> 'SYSTEM'
   and status = 'ONLINE';

accept dtbs prompt "Specify PERFSTAT user's default   tablespace: "
alter user PERFSTAT quota unlimited on &&dtbs;
alter user PERFSTAT default tablespace &&dtbs;

accept ttbs prompt "Specify PERFSTAT user's temporary tablespace: "
alter user PERFSTAT temporary tablespace &&ttbs;


prompt
prompt NOTE:
prompt   STATSCUSR complete. Please check statscusr.lis for any errors.
prompt

spool off;
whenever sqlerror continue;
set echo on;
