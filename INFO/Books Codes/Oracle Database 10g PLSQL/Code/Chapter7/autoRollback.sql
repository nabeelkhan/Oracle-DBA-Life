/*
 * autoRollback.sql
 * Chapter 7, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, and Scott Urman
 *
 * This script demonstrates how the server will roll back the
 * current transaction if the top level block exits with an
 * unhandled exception.
 */
 
DELETE temp_table;
 
BEGIN
  -- Insert a row into temp_table, and then raise an
  -- exception that will not be handled.
  INSERT INTO temp_table (char_col)
    VALUES ('This is my row!');
  RAISE VALUE_ERROR;
END;
/
 
-- The row is not present because the transaction has been rolled 
-- back.
SELECT * FROM temp_table;
