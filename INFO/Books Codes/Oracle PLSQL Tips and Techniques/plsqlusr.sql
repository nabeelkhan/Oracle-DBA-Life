-- ***************************************************************************
-- File: plsqlusr.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

-- Program:     plsqlusr.sql
-- Creation:    09/01/97
-- Created By:  TUSC
-- Description: Creates the pl/sql user named plsql_user to allow for 
--              the plsqlobj.sql script to be executed.  This script 
--              needs to be executed under a user with DBA privileges.

SPOOL plsqlusr.log

CREATE USER plsql_user IDENTIFIED BY plsql_user;
GRANT CONNECT, RESOURCE TO plsql_user;

SPOOL OFF

