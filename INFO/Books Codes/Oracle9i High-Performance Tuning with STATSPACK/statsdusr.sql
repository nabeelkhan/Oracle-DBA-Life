Rem
Rem $Header: statsdusr.sql 04-nov-99.16:58:14 cdialeri Exp $
Rem
Rem statsdusr.sql
Rem
Rem  Copyright (c) Oracle Corporation 1999. All Rights Reserved.
Rem
Rem    NAME
Rem      statsdusr.sql
Rem
Rem    DESCRIPTION
Rem      SQL*Plus command file to DROP user which contains the
Rem      STATSPACK database objects.
Rem
Rem    NOTES
Rem      Must be run when connected to SYS (or internal)
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    cdialeri    11/04/99 - 1059172
Rem    cdialeri    08/13/99 - Created
Rem

set echo off;

spool statsdusr.lis

Rem 
Rem  Drop X$views

drop view           X_$KCBFWAIT;
drop public synonym  X$KCBFWAIT;
drop view           X_$KSPPSV;
drop public synonym  X$KSPPSV;
drop view           X_$KSPPI;
drop public synonym  X$KSPPI;
drop view           X_$KSQST;
drop public synonym  X$KSQST;
drop view           V_$FILESTATXS;
drop public synonym  V$FILESTATXS;


Rem
Rem  Drop PERFSTAT user cascade
Rem

drop user perfstat cascade;

prompt
prompt NOTE:
prompt   STATSDUSR complete. Please check statsdusr.lis for any errors.
prompt

spool off;
set echo on;

