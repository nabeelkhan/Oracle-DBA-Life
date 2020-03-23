/*
 * create_record7.sql
 * Chapter 5, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates passing database objects as actual parameters to a procedure.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

-- An anonymous block program to ensure the primary key is not violated; and
-- an existing record structure is dropped from the database user's schema.
BEGIN
  -- Loop if a row is found and delete it.
  FOR i IN (SELECT   null
            FROM     addresses
            WHERE    address_id = 4) LOOP

    EXECUTE IMMEDIATE 'DELETE FROM addresses WHERE address_id = 4';
    COMMIT;

  END LOOP;

  -- Loop if a row is found and delete it.
  FOR i IN (SELECT   null
            FROM     individuals
            WHERE    individual_id = 7) LOOP

    EXECUTE IMMEDIATE 'DELETE FROM individuals WHERE individual_id = 7';
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

  -- Define a local procedure to manage addresses inserts.
  PROCEDURE insert_address
    (address_in ADDRESS_RECORD) IS

  BEGIN

    -- Insert the values into the target object.
    INSERT
    INTO     addresses
    VALUES
    (address_in.address_id
    ,address_in.individual_id
    ,address_in.street_address1
    ,address_in.street_address2
    ,address_in.street_address3
    ,address_in.city
    ,address_in.state
    ,address_in.postal_code
    ,address_in.country_code);

  END insert_address; 

  -- Define a local procedure to manage addresses inserts.
  PROCEDURE insert_individual
    (individual_in INDIVIDUAL_RECORD) IS

  BEGIN

    -- Insert the values into the table.
    INSERT
    INTO     individuals
    VALUES
    (individual_in.individual_id
    ,individual_in.first_name
    ,individual_in.middle_initial
    ,individual_in.last_name);

  END insert_individual; 

BEGIN

  -- Construct an instance of the object type and assign it.
  -- This uses two nested constructors within the constructor.
  individual_address :=
    individual_address_record(
      individual_record(7,'Quentin','','Roosevelt'),
      address_record(4,7,'20 Sagamore Hill','',''
                    ,'Oyster Bay','NY','11771-1899','USA'));

  -- Create a savepoint.
  SAVEPOINT addressbook;

  -- Process object subtypes.
  insert_individual(individual_address.individual); 
  insert_address(individual_address.address); 

  -- Commit the record.
  COMMIT;

EXCEPTION

  -- Rollback to savepoint on error.
  WHEN OTHERS THEN
    ROLLBACK to addressbook;
    RETURN;

END;
/    
