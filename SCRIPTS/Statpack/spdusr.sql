Rem
Rem $Header: spdusr.sql 23-apr-2001.20:33:06 cdialeri Exp $
Rem
Rem spdusr.sql
Rem
Rem  Copyright (c) Oracle Corporation 1999, 2000. All Rights Reserved.
Rem
Rem    NAME
Rem      spdusr.sql
Rem
Rem    DESCRIPTION
Rem      SQL*Plus command file to DROP user which contains the
Rem      STATSPACK database objects.
Rem
Rem    NOTES
Rem      Must be run when connected to SYS (or internal)
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    cdialeri    04/23/01 - 9.0
Rem    cdialeri    09/12/00 - sp_1404195
Rem    cdialeri    04/07/00 - 1261813
Rem    cdialeri    02/16/00 - 1191805
Rem    cdialeri    11/04/99 - 1059172
Rem    cdialeri    08/13/99 - Created
Rem

set echo off;

spool spdusr.lis

Rem 
Rem  Drop X$views

drop view           STATS$X_$KCBFWAIT;
drop public synonym  STATS$X$KCBFWAIT;
drop view           STATS$X_$KSPPSV;
drop public synonym  STATS$X$KSPPSV;
drop view           STATS$X_$KSPPI;
drop public synonym  STATS$X$KSPPI;
drop view           STATS$V_$FILESTATXS;
drop public synonym  STATS$V$FILESTATXS;
drop view           STATS$V_$SQLXS;
drop public synonym  STATS$V$SQLXS;
drop view           STATS$V_$TEMPSTATXS;
drop public synonym  STATS$V$TEMPSTATXS;

Rem
Rem  Drop PERFSTAT user cascade
Rem

drop user perfstat cascade;

prompt
prompt NOTE:
prompt   SPDUSR complete. Please check spdusr.lis for any errors.
prompt

spool off;
set echo on;

