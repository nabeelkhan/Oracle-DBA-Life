/*
 * nestedtable_dml1.sql
 * Chapter 6, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates using a stored function to resolve the
 * one-to-many relation of a nested table in a row of data.
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
,address_table
  ('Office of Senator McCain'
  ,'450 West Paseo Redondo'
  ,'Suite 200')
,'Tucson'
,'AZ'
,'85701'
,'USA');

-- Use an ordinary select statement.
SELECT   street_address
FROM     addresses;

-- Use SQL*Plus to format the output.
COL column_value FORMAT A30

-- Print a list of the varray elements.
SELECT   column_value
FROM     THE (SELECT   street_address
              FROM     addresses
              WHERE    address_id = 21);

-- Use SQL*Plus to format the output.
COL data FORMAT A30

-- Print a list of the joined elements.
SELECT   s.data
FROM    (SELECT   1 ordering
         ,        rownum roworder
         ,        individual_id
         ,        first_name
         ||       ' '
         ||       middle_initial
         ||       ' '
         ||       last_name data
         FROM     individuals i2
         UNION ALL
         SELECT   2 ordering
         ,        rownum roworder
         ,        individual_id
         ,        column_value data
         FROM     THE (SELECT   street_address
                       FROM     addresses)
         ,        addresses
         UNION ALL
         SELECT   3 ordering
         ,        rownum roworder
         ,        individual_id
         ,        city
         ||       ', '
         ||       state
         ||       ' '
         ||       postal_code data
         FROM     addresses a
         ORDER BY 1,2) s
,        individuals i
WHERE    s.individual_id = i.individual_id
AND      i.individual_id = 21;

-- Created ...
CREATE OR REPLACE FUNCTION many_to_one
  (street_address_in ADDRESS_TABLE)
RETURN VARCHAR2 IS

  -- Define a return variable and initial it as a zero length string.
  retval VARCHAR2(4000) := '';

BEGIN

  FOR i IN 1..street_address_in.COUNT LOOP

    retval := retval || street_address_in(i) || CHR(10);

  END LOOP;

  RETURN retval;

END many_to_one;
/ 


SELECT   i.first_name || ' '
||       i.middle_initial || ' '
||       i.last_name || CHR(10)
||       many_to_one(a.street_address)
||       city || ', '
||       state || ' '
||       postal_code address_label
FROM     addresses a
,        individuals i
WHERE    a.individual_id = i.individual_id
AND      i.individual_id = 21;
