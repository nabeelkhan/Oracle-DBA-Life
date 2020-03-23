/*
 * nestedtable_dml3.sql
 * Chapter 6, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates the update of an element of a nested table
 * collection.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

-- Clean up environment.
BEGIN

  FOR i IN (SELECT   null
            FROM     addresses
            WHERE    address_id = 21) LOOP
    EXECUTE IMMEDIATE 'DELETE FROM addresses WHERE address_id = 21';
  END LOOP;

  FOR i IN (SELECT   null
            FROM     individuals
            WHERE    individual_id = 21) LOOP
    EXECUTE IMMEDIATE 'DELETE FROM individuals WHERE individual_id = 21';
  END LOOP;

  COMMIT;

END;
/

-- Insert into individual because of mandatory parent key constraint.
INSERT
INTO     individuals
VALUES
('21'
,'John'
,''
,'McCain');

-- Insert into address using the varray structure.
INSERT
INTO     addresses
VALUES
(21
,21
,address_table('Office of Senator McCain'
              ,'450 West Paseo Redondo'
              ,'Suite 200')
,'Tucson'
,'AZ'
,'85701'
,'USA');

-- Commit work at this point.
COMMIT;

-- Update the column value directly in SQL.
UPDATE   THE (SELECT   street_address
              FROM     addresses
              WHERE    address_id = 21)
SET      column_value = 'Office of Senator John McCain'
WHERE    column_value = 'Office of Senator McCain';

-- Print a list of the varray elements.
SELECT   column_value
FROM     THE (SELECT   street_address
              FROM     addresses
              WHERE    address_id = 21);

-- Rollback update statement.
ROLLBACK;

-- Query the column value.
SELECT   column_value
FROM     THE (SELECT   CAST(street_address AS varray_nested_table)
              FROM     addresses
              WHERE    address_id = 21);

-- Anonymous block using PL/SQL nested table element update.
DECLARE

  -- Define old and new values.
  new_value VARCHAR2(30 CHAR) :=
    'Office of Senator John McCain';

  old_value VARCHAR2(30 CHAR) :=
    'Office of Senator McCain';

  -- Build SQL statement to support bind variables.
  sql_statement VARCHAR2(4000 CHAR)
    := 'UPDATE   THE (SELECT   street_address '
    || '              FROM     addresses '
    || '              WHERE    address_id = 21) '
    || 'SET      column_value = :1 '
    || 'WHERE    column_value = :2';

BEGIN

  -- Use dynamic SQL to run the update statement.
  EXECUTE IMMEDIATE sql_statement 
  USING new_value, old_value;

END;
/

-- Query the column value.
SELECT   column_value
FROM     THE (SELECT   CAST(street_address AS varray_nested_table)
              FROM     addresses
              WHERE    address_id = 21);
