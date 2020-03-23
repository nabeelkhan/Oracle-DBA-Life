/*
 * Chapter 7, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, and Scott Urman
 *
 * This block will raise the DUP_VAL_ON_INDEX exception.
 */

BEGIN
  INSERT INTO authors (id, first_name, last_name)
    VALUES (20000, 'John', 'Smith');
  INSERT INTO authors (id, first_name, last_name)
    VALUES (20000, 'Susan', 'Ryan');
END; 
/
