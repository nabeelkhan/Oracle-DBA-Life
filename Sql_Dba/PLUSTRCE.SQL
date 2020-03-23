rem
rem $Header: plustrce.sql 3030100.1 95/05/17 14:10:17 ssaux Generic<base> $
rem
rem Copyright (c) 1995 Oracle Corporation.  All Rights Reserved.
rem
rem NAME
rem   PLUSTRCE.SQL
rem
rem FUNCTION
rem   Create a role with access to Dynamic Performance Tables
rem   for the SQL*Plus SET AUTOTRACE ... STATISTICS command
rem
rem NOTES
rem   This file must be run while logged-in as SYS.
rem   Catalog.sql must have been run before this file is run.
rem
rem   After this script has been run, each user requiring access to
rem   the AUTOTRACE feature should be granted the PLUSTRACE role by
rem   the DBA.
rem
rem MODIFIED   (MM/DD/YY)
rem   cjones    04/20/95  - created

set echo on

drop role plustrace;
create role plustrace;

grant select on v_$sesstat to plustrace;
grant select on v_$statname to plustrace;
grant select on v_$session to plustrace;
grant plustrace to dba with admin option;

set echo off
