/*
 * LogPkg2.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates user defined PL/SQL wrappers to a Java program.
 */

CREATE OR REPLACE PACKAGE LogPkg AS
  PROCEDURE LogConnect(p_UserID IN VARCHAR2);
  PROCEDURE LogDisconnect(p_UserID IN VARCHAR2);
END LogPkg;
/
show errors

CREATE OR REPLACE PACKAGE BODY LogPkg AS
  PROCEDURE LogConnect(p_UserID IN VARCHAR2) IS
    LANGUAGE JAVA
    NAME 'Logger.LogConnect(java.lang.String)';

  PROCEDURE LogDisconnect(p_UserID IN VARCHAR2) IS
    LANGUAGE JAVA
    NAME 'Logger.LogDisconnect(java.lang.String)';
END LogPkg;
/
show errors
