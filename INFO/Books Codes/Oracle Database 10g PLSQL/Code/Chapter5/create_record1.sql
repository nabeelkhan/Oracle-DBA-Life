/*
 * create_record1.sql
 * Chapter 5, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates using a record type to populate a table.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

-- An anonymous block program to ensure the primary key is not violated.
BEGIN
  -- Loop if a row is found and delete it.
  FOR i IN (SELECT   null
            FROM     individuals
            WHERE    individual_id = 1) LOOP

    EXECUTE IMMEDIATE 'DELETE FROM individuals WHERE individual_id = 1';
    COMMIT;

  END LOOP;

END;
/

-- An anonymous block program to write the record to a row.
DECLARE

  -- Define a variable with an implicit record type.
  individual individuals%ROWTYPE;

BEGIN

  -- Initialize the field values for the record.
  individual.individual_id := 1;
  individual.first_name := 'John';
  individual.middle_initial := 'D';
  individual.last_name := 'Rockefeller';

  -- Insert the values into the target object.
  INSERT
  INTO     individuals
  VALUES
  (individual.individual_id
  ,individual.first_name
  ,individual.middle_initial
  ,individual.last_name);

  -- Commit the record.
  COMMIT;

END;
/    
