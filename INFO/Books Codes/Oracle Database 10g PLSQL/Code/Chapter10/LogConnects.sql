/*
 * LogConnects.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates user defined triggers.
 */

CREATE OR REPLACE TRIGGER LogConnects
  AFTER LOGON ON DATABASE 
  CALL LogPkg.LogConnect(SYS.LOGIN_USER)
/

CREATE OR REPLACE TRIGGER LogDisconnects
  BEFORE LOGOFF ON DATABASE
  CALL LogPkg.LogDisconnect(SYS.LOGIN_USER)
/
