Rem
Rem $Header: statsdrp.sql 13-aug-99.11:17:16 cdialeri Exp $
Rem
Rem statsdrp.sql
Rem
Rem  Copyright (c) Oracle Corporation 1999. All Rights Reserved.
Rem
Rem    NAME
Rem      statsdrp.sql
Rem
Rem    DESCRIPTION
Rem	 SQL*PLUS command file drop user, tables and package for
Rem	 performance diagnostic tool STATSPACK
Rem
Rem    NOTES
Rem	 Note the script connects INTERNAL and so must be run from
Rem	 an account which is able to connect internal.
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    cdialeri    08/13/99 - Drops entire STATSPACK environment
Rem    cdialeri    08/13/99 - Created
Rem

--
--  Connect as PERFSTAT and drop the tables and indexes

alter user perfstat identified by perfstat;
connect perfstat/perfstat@&&1
@@statsdtab


--
--  Drop STATSPACK usr

connect sys/&&2@&&1 
@@statsdusr

