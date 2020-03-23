Rem
Rem $Header: statscre.sql 06-dec-99.18:33:17 cdialeri Exp $
Rem
Rem statscre.sql
Rem
Rem  Copyright (c) Oracle Corporation 1999. All Rights Reserved.
Rem
Rem    NAME
Rem      statscre.sql - Statistics Create
Rem
Rem    DESCRIPTION
Rem	 SQL*PLUS command file which creates the STATSPACK user, 
Rem      tables and package for the performance diagnostic tool STATSPACK
Rem
Rem    NOTES
Rem      Note the script connects INTERNAL and so must be run from
Rem      an account which is able to connect internal.
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    cdialeri    12/06/99 - 1103031
Rem    cdialeri    08/13/99 - Created
Rem

--
--  Create PERFSTAT user and required privileges

@@statscusr

--
--  Build the tables and synonyms

connect perfstat/perfstat@&&1
@@statsctab


--
--  Create the statistics Package
connect perfstat/perfstat@&&1
@@statspack
