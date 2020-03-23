/*
 * testLogPkg.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates calls PL/SQL wrappers to stored Java libraries.
 */

DECLARE
  v_string VARCHAR2(80) := 'USERA';
BEGIN
  logpkg.logconnect(v_string);
END;
/

DECLARE
  v_string VARCHAR2(80) := 'USERA';
BEGIN
  logpkg.logdisconnect(v_string);
END;
/
