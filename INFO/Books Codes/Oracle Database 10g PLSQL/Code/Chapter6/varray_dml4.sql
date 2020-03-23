/*
 * varray_dml4.sql
 * Chapter 6, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates the update of an element of a varray
 * collection.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

-- Clean up environment.
BEGIN

  FOR i IN (SELECT   null
            FROM     addresses
            WHERE    address_id = 22) LOOP
    EXECUTE IMMEDIATE 'DELETE FROM addresses WHERE address_id = 22';
  END LOOP;

  FOR i IN (SELECT   null
            FROM     individuals
            WHERE    individual_id = 22) LOOP
    EXECUTE IMMEDIATE 'DELETE FROM individuals WHERE individual_id = 22';
  END LOOP;

  COMMIT;

END;
/

-- Insert into individual because of mandatory parent key constraint.
INSERT
INTO     individuals
VALUES
('22'
,'Teddy'
,''
,'Kennedy');

-- Insert into address using the varray structure.
INSERT
INTO     addresses
VALUES
(22
,22
,address_table('Office of Senator Kennedy')
,'Boston'
,'MA'
,'02203'
,'USA');

-- Anonymous block using PL/SQL nested table element update.
DECLARE

  -- Define a record type for a row of the addresses table.
  TYPE address_type IS RECORD
  (address_id          INTEGER
  ,individual_id       INTEGER
  ,street_address      ADDRESS_TABLE
  ,city                VARCHAR2(20 CHAR)
  ,state               VARCHAR2(20 CHAR)
  ,postal_code         VARCHAR2(20 CHAR)
  ,country_code        VARCHAR2(10 CHAR));

  -- Define a variable of the addresses table record type.
  address              ADDRESS_TYPE;

  -- Define a cursor to return the %ROWTYPE value.
  CURSOR get_street_address
    (address_id_in      INTEGER) IS
    SELECT   *
    FROM     addresses
    WHERE    address_id = address_id_in;

BEGIN

  -- Open the cursor.
  OPEN  get_street_address(22);

  -- Fetch a into the record type variable.
  FETCH get_street_address
  INTO  address;

  -- Close the cursor.
  CLOSE get_street_address;

  -- Add element space.
  FOR i IN 2..3 LOOP
    address.street_address.EXTEND;
  END LOOP;

  -- Reset the first element of the varray type variable.
  address.street_address(2) := 'JFK Building';
  address.street_address(3) := 'Suite 2400';

  -- Update the varray column value.
  UPDATE   addresses
  SET      street_address = address.street_address
  WHERE    address_id = 22;

END;
/

-- Create a type to view the formatted varray values.
CREATE OR REPLACE TYPE varray_nested_table
IS TABLE OF VARCHAR2(30 CHAR);
/

-- Query the column value.
SELECT   column_value
FROM     THE (SELECT   CAST(street_address AS varray_nested_table)
              FROM     addresses
              WHERE    address_id = 22);
