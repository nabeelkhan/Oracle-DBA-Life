/*
 * create_record2.sql
 * Chapter 5, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates using explicit definition to define a record type.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

-- An anonymous block program to ensure the primary key is not violated.
BEGIN
  -- Loop if a row is found and delete it.
  FOR i IN (SELECT   null
            FROM     individuals
            WHERE    individual_id = 2) LOOP

    EXECUTE IMMEDIATE 'DELETE FROM individuals WHERE individual_id = 2';
    COMMIT;

  END LOOP;

END;
/

-- An anonymous block program to write the record to a row.
DECLARE

  -- Define a record type.
  TYPE individual_record IS RECORD
  (individual_id   INTEGER
  ,first_name      VARCHAR2(30 CHAR)
  ,middle_initial  individuals.middle_initial%TYPE
  ,last_name       VARCHAR2(30 CHAR));

  -- Define a variable of the record type.
  individual INDIVIDUAL_RECORD;

BEGIN

  -- Initialize the field values for the record.
  individual.individual_id := 2;
  individual.first_name := 'John';
  individual.middle_initial := 'P';
  individual.last_name := 'Morgan';

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
