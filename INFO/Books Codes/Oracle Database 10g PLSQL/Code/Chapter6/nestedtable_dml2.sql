/*
 * nestedtable_dml2.sql
 * Chapter 6, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates how to update nested tables.
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

-- Insert into address using the varray structure.
UPDATE   addresses
SET      street_address = 
           address_table('Office of Senator McCain'
                        ,'2400 E. Arizona Biltmore Cir.'
                        ,'Suite 1150')
WHERE    address_id = 21;

SELECT   column_value
FROM     THE (SELECT   street_address
              FROM     addresses
              WHERE    address_id = 21);
