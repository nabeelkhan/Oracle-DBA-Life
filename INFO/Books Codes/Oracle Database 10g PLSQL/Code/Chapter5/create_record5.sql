/*
 * create_record5.sql
 * Chapter 5, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates using compound database objects to define a
 * record type.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

-- An anonymous block program to ensure the primary key is not violated; and
-- an existing record structure is dropped from the database user's schema.
BEGIN
  -- Loop if a row is found and delete it.
  FOR i IN (SELECT   null
            FROM     addresses
            WHERE    address_id = 2) LOOP

    EXECUTE IMMEDIATE 'DELETE FROM addresses WHERE address_id = 2';
    COMMIT;

  END LOOP;

  -- Loop if a row is found and delete it.
  FOR i IN (SELECT   null
            FROM     individuals
            WHERE    individual_id = 5) LOOP

    EXECUTE IMMEDIATE 'DELETE FROM individuals WHERE individual_id = 5';
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

  -- Loop if a row is found and delete it.
  FOR i IN (SELECT   null
            FROM     user_types
            WHERE    type_name = 'ADDRESS_RECORD') LOOP

    EXECUTE IMMEDIATE 'DROP TYPE address_record';
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

-- Create a database object body.
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

-- Create a database object type.
CREATE OR REPLACE TYPE address_record AS OBJECT
  (address_id      INTEGER
  ,individual_id   INTEGER
  ,street_address1 VARCHAR2(30 CHAR)
  ,street_address2 VARCHAR2(30 CHAR)
  ,street_address3 VARCHAR2(30 CHAR)
  ,city            VARCHAR2(20 CHAR)
  ,state           VARCHAR2(20 CHAR)
  ,postal_code     VARCHAR2(20 CHAR)
  ,country_code    VARCHAR2(10 CHAR)
  ,CONSTRUCTOR FUNCTION address_record
  (address_id      INTEGER
  ,individual_id   INTEGER
  ,street_address1 VARCHAR2
  ,street_address2 VARCHAR2
  ,street_address3 VARCHAR2
  ,city            VARCHAR2
  ,state           VARCHAR2
  ,postal_code     VARCHAR2
  ,country_code    VARCHAR2)
  RETURN SELF AS RESULT)
  INSTANTIABLE NOT FINAL;
/

show errors

-- Create database object body.
CREATE OR REPLACE TYPE BODY address_record AS
  CONSTRUCTOR FUNCTION address_record
  (address_id      INTEGER
  ,individual_id   INTEGER
  ,street_address1 VARCHAR2
  ,street_address2 VARCHAR2
  ,street_address3 VARCHAR2
  ,city            VARCHAR2
  ,state           VARCHAR2
  ,postal_code     VARCHAR2
  ,country_code    VARCHAR2)
  RETURN SELF AS RESULT IS
  BEGIN
    -- Instantiate object attributes.
    self.address_id := address_id;
    self.individual_id := individual_id;
    self.street_address1 := street_address1;
    self.street_address2 := street_address2;
    self.street_address3 := street_address3;
    self.city := city;
    self.state := state;
    self.postal_code := postal_code;
    self.country_code := country_code;
    RETURN;
  END;
END;
/

show errors

-- Create a database object type.
CREATE OR REPLACE TYPE individual_address_record AS OBJECT
  (individual      INDIVIDUAL_RECORD
  ,address         ADDRESS_RECORD
  ,CONSTRUCTOR FUNCTION individual_address_record
  (individual      INDIVIDUAL_RECORD
  ,address         ADDRESS_RECORD)
  RETURN SELF AS RESULT)
  INSTANTIABLE NOT FINAL;
/

show errors

-- Create a database object body.
CREATE OR REPLACE TYPE BODY individual_address_record AS
  CONSTRUCTOR FUNCTION individual_address_record
  (individual      INDIVIDUAL_RECORD
  ,address         ADDRESS_RECORD)
  RETURN SELF AS RESULT IS
  BEGIN
    -- Assign an instance of INDIVIDUAL_RECORD.
    self.individual := individual;

    -- Assign an instance of ADDRESS_RECORD.
    self.address := address;
    RETURN;
  END;
END;
/

show errors

-- An anonymous block program to write the record to a row.
DECLARE

  -- Define a variable of the record type.
  individual_address INDIVIDUAL_ADDRESS_RECORD;

BEGIN

  -- Construct an instance of the object type and assign it.
  -- This uses two nested constructors within the constructor.
  individual_address :=
    individual_address_record(
      individual_record(5,'Kermit','','Roosevelt'),
      address_record(2,5,'20 Sagamore Hill','',''
                    ,'Oyster Bay','NY','11771-1899','USA'));

  -- Insert the values into the table.
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
  ,individual_address.individual.individual_id
  ,individual_address.address.street_address1
  ,individual_address.address.street_address2
  ,individual_address.address.street_address3
  ,individual_address.address.city
  ,individual_address.address.state
  ,individual_address.address.postal_code
  ,individual_address.address.country_code);

  -- Commit the record.
  COMMIT;

END;
/    
