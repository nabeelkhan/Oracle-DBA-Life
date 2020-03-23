/*
 * ExceptionInit.sql
 * Chapter 7, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, and Scott Urman
 *
 * This script demonstrates the EXCEPTION_INIT pragma.
 */
 
DELETE FROM log_table;

DECLARE
  e_MissingNull EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_MissingNull, -1400);
BEGIN
  INSERT INTO authors (id) VALUES (NULL);
EXCEPTION
  WHEN e_MissingNull then
    INSERT INTO log_table (info) VALUES ('ORA-1400 occurred');
END;
/

SELECT info FROM log_table;
