/*
 * create_record4.sql
 * Chapter 5, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates using a database object to define a record type.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

-- An anonymous block program to ensure the primary key is not violated; and
-- an existing record structure is dropped from the database user's schema.
BEGIN
  -- Loop if a row is found and delete it.
  FOR i IN (SELECT   null
            FROM     individuals
            WHERE    individual_id = 4) LOOP

    EXECUTE IMMEDIATE 'DELETE FROM individuals WHERE individual_id = 4';
    COMMIT;

  END LOOP;

  -- Loop if a row is found and delete it.
  FOR i IN (SELECT   null
            FROM     user_types
            WHERE    type_name = 'INDIVIDUAL_ADDRESS_RECORD') LOOP

    EXECUTE IMMEDIATE 'DROP TYPE individual_address_record';
    COMMIT;

  END LOOP;

  -- Loop if a row is found and delete it.
  FOR i IN (SELECT   null
            FROM     user_types
            WHERE    type_name = 'INDIVIDUAL_RECORD') LOOP

    EXECUTE IMMEDIATE 'DROP TYPE individual_record';
    COMMIT;

  END LOOP;

END;
/

-- Create a database object type.
CREATE OR REPLACE TYPE individual_record AS OBJECT
  (individual_id  INTEGER
  ,first_name     VARCHAR2(30 CHAR)
  ,middle_initial VARCHAR2(1 CHAR)
  ,last_name      VARCHAR2(30 CHAR)
  ,CONSTRUCTOR FUNCTION individual_record
  (individual_id  INTEGER
  ,first_name     VARCHAR2
  ,middle_initial VARCHAR2
  ,last_name      VARCHAR2)
  RETURN SELF AS RESULT)
  INSTANTIABLE NOT FINAL;
/

show errors

-- Create a database object body type.
CREATE OR REPLACE TYPE BODY individual_record AS
  CONSTRUCTOR FUNCTION individual_record
  (individual_id  INTEGER
  ,first_name     VARCHAR2
  ,middle_initial VARCHAR2
  ,last_name      VARCHAR2)
  RETURN SELF AS RESULT IS
  BEGIN
    self.individual_id := individual_id;
    self.first_name := first_name;
    self.middle_initial := middle_initial;
    self.last_name := last_name;
    RETURN;
  END;
END;
/

show errors

-- An anonymous block program to write the record to a row.
DECLARE

  -- Define a variable of the record type.
  individual INDIVIDUAL_RECORD;

BEGIN

  -- Construct an instance of the object type and assign it.

  individual := individual_record(4,'Klaes','M','van Roosevelt');

  -- Insert the values into the table.
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
