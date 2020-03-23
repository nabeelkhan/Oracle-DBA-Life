/*
 * LogPkg1.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates user defined packages called from
 * triggers.
 */

CREATE OR REPLACE PACKAGE LogPkg AS
  PROCEDURE LogConnect(p_UserID IN VARCHAR2);
  PROCEDURE LogDisconnect(p_UserID IN VARCHAR2);
END LogPkg;
/
show errors

CREATE OR REPLACE PACKAGE BODY LogPkg AS
  PROCEDURE LogConnect(p_UserID IN VARCHAR2) IS
  BEGIN
    INSERT INTO connect_audit (user_name, operation, timestamp)
      VALUES (p_USerID, 'CONNECT', SYSDATE);
  END LogConnect;

  PROCEDURE LogDisconnect(p_UserID IN VARCHAR2) IS
  BEGIN
    INSERT INTO connect_audit (user_name, operation, timestamp)
      VALUES (p_USerID, 'DISCONNECT', SYSDATE);
  END LogDisconnect;
END LogPkg;
/
show errors
