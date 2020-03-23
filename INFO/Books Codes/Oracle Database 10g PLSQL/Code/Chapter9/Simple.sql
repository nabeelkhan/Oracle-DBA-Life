/*
 * Simple.sql
 * Chapter 9, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates data dictionary views for valid and invalid
 * objects. 
 */

-- Create a simple procedure.
CREATE OR REPLACE PROCEDURE Simple AS
  v_Counter NUMBER;
BEGIN
  v_Counter := 7;
END Simple;
/

COLUMN object_name format a20
COLUMN line format 9999
COLUMN position format 99999
COLUMN text format a59

-- These queries show that the procedure is valid and that
-- the source is stored in the data dictionary.
SELECT object_name, object_type, status
  FROM user_objects
  WHERE object_name = 'SIMPLE';
  
SELECT text
  FROM user_source
  WHERE name = 'SIMPLE'
  ORDER BY line;
  
SELECT line, position, text
  FROM user_errors
  WHERE name = 'SIMPLE'
  ORDER BY sequence;

-- Recreate Simple with a compilation error (note the 
-- missing semicolon).
CREATE OR REPLACE PROCEDURE Simple AS
  v_Counter NUMBER;
BEGIN
  v_Counter := 7
END Simple;
/

-- The same queries now show the procedure is invalid and
-- the errors can be found in user_errors.
SELECT object_name, object_type, status
  FROM user_objects
  WHERE object_name = 'SIMPLE';
  
SELECT text
  FROM user_source
  WHERE name = 'SIMPLE'
  ORDER BY line;
  
SELECT line, position, text
  FROM user_errors
  WHERE name = 'SIMPLE'
  ORDER BY sequence;
