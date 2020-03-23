/*
 * callANA.sql
 * Chapter 8, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, and Scott Urman
 *
 * This block illustrates how to call the AddNewAuthor function.
 */
 
DECLARE
  -- Variables describing the new author
  v_NewFirstName authors.first_name%TYPE := 'Cynthia';
  v_NewLastName authors.last_name%TYPE := 'Camino';
  v_NewAuthorID authors.ID%TYPE := 100;
BEGIN
  -- Add Cynthia Camino to the database
  AddNewAuthor(v_NewAuthorID, v_NewFirstName, v_NewLastName);
END;
/

