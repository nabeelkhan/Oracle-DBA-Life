/*
 * AddNewAuthor.sql
 * Chapter 8, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, and Scott Urman
 *
 * This script demonstrates how to create and call a simple procedure.
 */
 
CREATE OR REPLACE PROCEDURE AddNewAuthor (
  p_ID authors.ID%TYPE,
  p_FirstName authors.first_name%TYPE,
  p_LastName authors.last_name%TYPE) AS
BEGIN
  -- Insert a new row into the authors table, using the supplied 
  -- arguments for the column values.
  INSERT INTO authors (id, first_name, last_name)
    VALUES (p_ID, p_FirstName, p_LastName);
END AddNewAuthor;
/

BEGIN
  AddNewAuthor(100, 'Zelda', 'Zudnik');
END;
/

-- Roll back the insert so the example can be run again.
ROLLBACK;