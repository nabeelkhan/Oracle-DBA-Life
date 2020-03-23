/*
 * UpdateDual.sql
 * Chapter 4, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates how DML works with PL/SQL
 */

BEGIN
   UPDATE dual
   SET dummy = 'x'
   WHERE 1=2;
END;
/
