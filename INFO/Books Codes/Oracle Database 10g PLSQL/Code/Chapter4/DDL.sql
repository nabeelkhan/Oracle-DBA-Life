/*
 * DDL.sql
 * Chapter 4, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates how DDL doesn't work with PL/SQL
 */

BEGIN
   CREATE TABLE ddl_table (
      id NUMBER(10));
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE(sqlerrm);
END;
/
