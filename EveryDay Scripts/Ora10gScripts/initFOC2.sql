REM Akadia AG, Arvenweg 4, CH-3604 Thun                       initFOC2.sql
REM ----------------------------------------------------------------------
REM
REM File:       initFOC2.sql
REM
REM Autor:      Martin Zahn / 25.03.2004
REM
REM Purpose:    Create Oracle Database on Windows 2000
REM
REM Location:   $ORACLE_HOME\Database
REM
REM Certified:  Oracle 10.1.0.2 on Windows 2000
REM ----------------------------------------------------------------------
REM
SPOOL D:\Oracle\Product\10.1.0\Database\initFOC2.log
CONNECT SYS/MANAGER AS SYSDBA;

REM Startup database
REM ----------------
REM
STARTUP NOMOUNT pfile=D:\Oracle\Product\10.1.0\Database\initFOC2_init.ora;

REM Create database
REM ---------------
REM
CREATE DATABASE        FOC2
       CONTROLFILE     REUSE
       MAXDATAFILES    256
       MAXINSTANCES    4
       MAXLOGFILES     62
       MAXLOGMEMBERS   5
       MAXLOGHISTORY   1600
       CHARACTER SET   "WE8ISO8859P1"
       NATIONAL CHARACTER SET "AL16UTF16"
       DATAFILE 'E:\Oradata\FOC2\sys\FOC2_sys1.dbf' SIZE 500M REUSE
       SYSAUX DATAFILE 'E:\Oradata\FOC2\sys\FOC2_sysaux1.dbf' SIZE 200M REUSE
       UNDO TABLESPACE undo DATAFILE 'E:\Oradata\FOC2\sys\FOC2_undo1.dbf'
         SIZE 200M REUSE AUTOEXTEND ON NEXT 5120K MAXSIZE UNLIMITED
       DEFAULT TEMPORARY TABLESPACE temp
         TEMPFILE 'E:\Oradata\FOC2\tmp\FOC2_temp1.dbf' SIZE 500M REUSE
         EXTENT MANAGEMENT LOCAL UNIFORM SIZE 256K
 LOGFILE GROUP 1 ('E:\Oradata\FOC2\rdo\FOC2_log1A.rdo',
                  'C:\Oradata\FOC2\rdo\FOC2_log1B.rdo') SIZE 5M REUSE,
         GROUP 2 ('E:\Oradata\FOC2\rdo\FOC2_log2A.rdo',
                  'C:\Oradata\FOC2\rdo\FOC2_log2B.rdo') SIZE 5M REUSE,
         GROUP 3 ('E:\Oradata\FOC2\rdo\FOC2_log3A.rdo',
                  'C:\Oradata\FOC2\rdo\FOC2_log3B.rdo') SIZE 5M REUSE,
         GROUP 4 ('E:\Oradata\FOC2\rdo\FOC2_log4A.rdo',
                  'C:\Oradata\FOC2\rdo\FOC2_log4B.rdo') SIZE 5M REUSE;

REM Create locally managed TEMP tablespace after DB creation
REM --------------------------------------------------------
REM Locally managed (SIZE + 64K for Header Bitmap)
REM
REM CREATE TEMPORARY TABLESPACE temp
REM        TEMPFILE 'E:\Oradata\FOC2\tmp\FOC2_temp2.dbf' SIZE 512064K REUSE
REM        AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED
REM        EXTENT MANAGEMENT LOCAL UNIFORM SIZE 256K;

REM Create users tablespace
REM -----------------------
REM Locally managed (SIZE + 64K for Header Bitmap)
REM
CREATE TABLESPACE users
        LOGGING
        DATAFILE 'E:\Oradata\FOC2\usr\FOC2_users1.dbf' SIZE 10M REUSE
        AUTOEXTEND ON NEXT 5M MAXSIZE UNLIMITED
        EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO
        PERMANENT
        ONLINE;

REM Create tablespace for small objects
REM -----------------------------------
REM Locally managed (SIZE + 64K for Header Bitmap)
REM
CREATE TABLESPACE tab
        LOGGING
        DATAFILE 'E:\Oradata\FOC2\tab\FOC2_tab1.dbf' SIZE 300M REUSE
        AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED
        EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO
        PERMANENT
        ONLINE;

REM Create tablespace for small Indexes
REM -----------------------------------
REM Locally managed (SIZE + 64K for Header Bitmap)
REM
CREATE TABLESPACE idx
        LOGGING
        DATAFILE 'E:\Oradata\FOC2\idx\FOC2_idx1.dbf' SIZE 300M REUSE
        AUTOEXTEND ON NEXT 5M MAXSIZE UNLIMITED
        EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO
        PERMANENT
        ONLINE;

REM Create tablespace for Oracle Options
REM -----------------------------------
REM
REM CREATE TABLESPACE cwmlite
REM         LOGGING
REM         DATAFILE 'E:\Oradata\FOC2\sys\FOC2_cwmlite1.dbf' SIZE 20M REUSE
REM         AUTOEXTEND ON NEXT 640K
REM        EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO
REM        PERMANENT
REM        ONLINE;
REM
REM CREATE TABLESPACE drsys
REM         LOGGING
REM         DATAFILE 'E:\Oradata\FOC2\sys\FOC2_drsys1.dbf' SIZE 20M REUSE
REM         AUTOEXTEND ON NEXT 640K
REM         EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO
REM         PERMANENT
REM         ONLINE;
REM
REM CREATE TABLESPACE odm
REM         LOGGING
REM         DATAFILE 'E:\Oradata\FOC2\sys\FOC2_odm1.dbf' SIZE 20M REUSE
REM         AUTOEXTEND ON NEXT 640K
REM         EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO
REM         PERMANENT
REM         ONLINE;
REM
REM CREATE TABLESPACE xdb
REM         LOGGING
REM         DATAFILE 'E:\Oradata\FOC2\sys\FOC2_xdb1.dbf' SIZE 20M REUSE
REM         AUTOEXTEND ON NEXT 640K
REM         EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO
REM         PERMANENT
REM         ONLINE;
REM
REM CREATE TABLESPACE tools
REM         LOGGING
REM         DATAFILE 'E:\Oradata\FOC2\sys\FOC2_tools1.dbf' SIZE 10M REUSE
REM         AUTOEXTEND ON NEXT 640K
REM         EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO
REM         PERMANENT
REM        ONLINE;

REM Set security for the administrative users
REM -----------------------------------------
REM
ALTER USER sys
TEMPORARY TABLESPACE temp;
ALTER USER sys IDENTIFIED BY manager;

ALTER USER system
TEMPORARY TABLESPACE temp;
ALTER USER system IDENTIFIED BY manager;

REM Load the system scripts
REM -----------------------
REM After creating the database with CREATE DATABASE ....,
REM disconnect and reconnect again, just before running the
REM admin scripts, this solves the problem.

DISCONNECT;
CONNECT SYS/MANAGER AS SYSDBA;
SET TERMOUT ON;

REM Creates data dictionary views. This is the very first
REM Script which must be executed during Database Building
@D:\Oracle\Product\10.1.0\Rdbms\admin\catalog.sql

REM Parallel-Server specific views for performance queries
@D:\Oracle\Product\10.1.0\Rdbms\admin\catparr.sql

REM Scripts for the PL/SQL procedural option
@D:\Oracle\Product\10.1.0\Rdbms\admin\catproc.sql

REM Run all sql scripts for replication option
@D:\Oracle\Product\10.1.0\Rdbms\admin\catrep.sql

REM Collect I/O per table (actually object) statistics by
REM statistical  sampling
@D:\Oracle\Product\10.1.0\Rdbms\admin\catio.sql

REM This package creates a table into which references to
REM the chained rows for an IOT (Index-Only-Table) can be
REM placed using the ANALYZE command.
@D:\Oracle\Product\10.1.0\Rdbms\admin\dbmsiotc.sql

REM Wrap Package which creates IOTs (Index-Only-Table)
@D:\Oracle\Product\10.1.0\Rdbms\admin\prvtiotc.plb

REM This package allows you to display the sizes of objects in the
REM shared pool, and mark them for keeping or unkeeping in order to
REM reduce memory fragmentation.
@D:\Oracle\Product\10.1.0\Rdbms\admin\dbmspool.sql

REM Creates the default table for storing the output
REM of the ANALYZE LIST CHAINED ROWS command
@D:\Oracle\Product\10.1.0\Rdbms\admin\utlchain.sql

REM Creates the EXCEPTION table
@D:\Oracle\Product\10.1.0\Rdbms\admin\utlexcpt.sql

REM Grant public access to all views used by TKPROF
REM with verbose=y option
@D:\Oracle\Product\10.1.0\Rdbms\admin\utltkprf.sql

REM Create table PLAN_TABLE that is used by the EXPLAIN PLAN
REM statement. The explain statement requires the presence of this
REM table in order to store the descriptions of the row sources.
@D:\Oracle\Product\10.1.0\Rdbms\admin\utlxplan.sql

REM Create v7 style export/import views against the v9 RDBMS
REM so that EXP/IMP v7 can be used to read out data in a v9 RDBMS.
REM These views are necessary if you want to export from Oracle9
REM and import in an Oracle7 database.
@D:\Oracle\Product\10.1.0\Rdbms\admin\catexp7.sql

REM Create views of oracle locks
@D:\Oracle\Product\10.1.0\Rdbms\admin\catblock.sql

REM Print out the lock wait-for graph in a tree structured fashion
@D:\Oracle\Product\10.1.0\Rdbms\admin\utllockt.sql

REM Creates the default table for storing the output of the
REM analyze validate command on a partitioned table
@D:\Oracle\Product\10.1.0\Rdbms\admin\utlvalid.sql

REM PL/SQL Package of utility routines for raw datatypes
@D:\Oracle\Product\10.1.0\Rdbms\admin\utlraw.sql
@D:\Oracle\Product\10.1.0\Rdbms\admin\prvtrawb.plb

REM Contains the PL/SQL interface to the cryptographic toolkit
@D:\Oracle\Product\10.1.0\Rdbms\admin\dbmsoctk.sql
@D:\Oracle\Product\10.1.0\Rdbms\admin\prvtoctk.plb

REM This package provides a built-in random number generator. It is
REM faster than generators written in PL/SQL because it calls Oracle's
--internal random number generator.
@D:\Oracle\Product\10.1.0\Rdbms\admin\dbmsrand.sql

REM DBMS package specification for Oracle8 Large Object
REM This package provides routines for operations on BLOB
REM and CLOB datatypes.
@D:\Oracle\Product\10.1.0\Rdbms\admin\dbmslob.sql

REM Procedures for instrumenting database applications
REM DBMS_APPLICATION_INFO package spec.
@D:\Oracle\Product\10.1.0\Rdbms\admin\dbmsapin.sql

REM Run obfuscation toolkit script.
@D:\Oracle\Product\10.1.0\Rdbms\admin\catobtk.sql

REM Create Heterogeneous Services data dictionary objects.
@D:\Oracle\Product\10.1.0\Rdbms\admin\caths.sql

REM Create Oracle Cryptographic ToolKit
@D:\Oracle\Product\10.1.0\Rdbms\admin\catoctk.sql;

REM Create Oracle OWM
@D:\Oracle\Product\10.1.0\Rdbms\admin\owminst.plb;

REM Recompile all INVALID objects
REM -----------------------------
REM
@D:\Oracle\Product\10.1.0\Rdbms\admin\utlrp.sql

REM Password Verify Function
REM ------------------------
REM
REM @$ORACLE_HOME/rdbms/admin/utlpwdmg.sql

REM Create roles and users
REM ----------------------
REM GRANT EXECUTE ON dbms_pipe, dbms_alert must be granted
REM to the real spm users, not through a role !
REM
DISCONNECT;
CONNECT system/manager;

CREATE USER scott IDENTIFIED BY tiger
    DEFAULT TABLESPACE tab
    TEMPORARY TABLESPACE temp
    QUOTA 0 ON system
    PROFILE default;
    GRANT CONNECT,RESOURCE TO scott;
    GRANT ALL PRIVILEGES TO scott;

ALTER USER dbsnmp
TEMPORARY TABLESPACE temp;

DISCONNECT;
CONNECT SYS/MANAGER AS SYSDBA;

GRANT EXECUTE ON dbms_pipe TO PUBLIC;
GRANT EXECUTE ON dbms_alert TO PUBLIC;
GRANT EXECUTE ON dbms_obfuscation_toolkit TO PUBLIC;

REM Setup PLAN_TABLE for TKPROF, SQL-Tuning
REM ---------------------------------------
REM
GRANT DELETE,INSERT,UPDATE,SELECT ON sys.plan_table TO scott;
CREATE PUBLIC SYNONYM plan_table FOR sys.plan_table;
GRANT SELECT  ON V_$PARAMETER TO scott;

REM Setup AUTO TRACE for SQL*PLUS
REM -----------------------------
REM
CONNECT system/manager;
@D:\Oracle\Product\10.1.0\sqlplus\admin\pupbld.sql
@D:\Oracle\Product\10.1.0\sqlplus\admin\plustrce.sql
GRANT plustrace to scott;

REM Create Help Tables for SQL*Plus
REM -------------------------------
REM
@D:\Oracle\Product\10.1.0\sqlplus\admin\help\hlpbld.sql helpus.sql;

EXIT;
