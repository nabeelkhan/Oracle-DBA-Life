/*
 * createConnectAudit.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script builds the CONNECT_AUDIT table.
 */

SET ECHO ON

BEGIN
  FOR i IN (SELECT   null
            FROM     user_tables
            WHERE    table_name = 'CONNECT_AUDIT') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE connect_audit';
  END LOOP;
END;
/

CREATE TABLE connect_audit (
  user_name  VARCHAR2(30),
  operation  VARCHAR2(30),
  timestamp  DATE);
