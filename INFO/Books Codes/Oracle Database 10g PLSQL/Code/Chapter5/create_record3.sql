/*
 * create_record3.sql
 * Chapter 5, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates using explicit definition to define record
 * types and a compound record type; and, the use of nested types.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

-- An anonymous block program to ensure the primary key is not violated.
BEGIN
  -- Loop if a row is found and delete it.
  FOR i IN (SELECT   null
            FROM     addresses
            WHERE    address_id = 1) LOOP

    EXECUTE IMMEDIATE 'DELETE FROM addresses WHERE address_id = 1';
    COMMIT;

  END LOOP;

  -- Loop if a row is found and delete it.
  FOR i IN (SELECT   null
            FROM     individuals
            WHERE    individual_id = 3) LOOP

    EXECUTE IMMEDIATE 'DELETE FROM individuals WHERE individual_id = 3';
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
  ,middle_initial  VARCHAR2(1 CHAR)
  ,last_name       VARCHAR2(30 CHAR));

  -- Define a record type.
  TYPE address_record IS RECORD
  (address_id      INTEGER
  ,individual_id   INTEGER
  ,street_address1 VARCHAR2(30 CHAR)
  ,street_address2 VARCHAR2(30 CHAR)
  ,street_address3 VARCHAR2(30 CHAR)
  ,city            VARCHAR2(20 CHAR)
  ,state           VARCHAR2(20 CHAR)
  ,postal_code     VARCHAR2(20 CHAR)
  ,country_code    VARCHAR2(10 CHAR));

  -- Define a record type of two user defined record type variables.
  TYPE individual_address_record IS RECORD
  (individual      INDIVIDUAL_RECORD
  ,address         ADDRESS_RECORD);

  -- Define a variable of a user defined compound record type.
  individual_address INDIVIDUAL_ADDRESS_RECORD;

BEGIN

  -- Initialize the field values for the record.
  individual_address.individual.individual_id := 3;
  individual_address.individual.first_name := 'Ulysses';
  individual_address.individual.middle_initial := 'S';
  individual_address.individual.last_name := 'Grant';

  -- Initialize the field values for the record.
  individual_address.address.address_id := 1;
  individual_address.address.individual_id := 3;
  individual_address.address.street_address1 := 'Riverside Park';
  individual_address.address.street_address2 := '';
  individual_address.address.street_address3 := '';
  individual_address.address.city := 'New York City';
  individual_address.address.state := 'NY';
  individual_address.address.postal_code := '10027-3914';
  individual_address.address.country_code := 'USA';

  -- Insert the values into the target object.
  INSERT
  INTO     individuals
  VALUES
  (individual_address.individual.individual_id
  ,individual_address.individual.first_name
  ,individual_address.individual.middle_initial
  ,individual_address.individual.last_name);

  -- Insert the values into the target object.
  INSERT
  INTO     addresses
  VALUES
  (individual_address.address.address_id
  ,individual_address.address.individual_id
  ,individual_address.address.street_address1
  ,individual_address.address.street_address2
  ,individual_address.address.street_address2
  ,individual_address.address.city
  ,individual_address.address.state
  ,individual_address.address.postal_code
  ,individual_address.address.country_code);

  -- Commit the record.
  COMMIT;

END;
/    
