/*
 * bulk_collect2.sql
 * Chapter 6, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates how to do a bulk collect into a nested
 * table.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

BEGIN
  FOR i IN (SELECT null
            FROM user_tables
            WHERE table_name = 'BULK_NUMBERS') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE bulk_numbers CASCADE CONSTRAINTS';
  END LOOP;
END;
/

-- Create a table for the example.
CREATE TABLE bulk_numbers
(number_id                NUMBER              NOT NULL
,CONSTRAINT number_id_pk  PRIMARY KEY (number_id));

--ALTER SESSION SET sql_trace=true; 
--SELECT 'Tuning for bulk_collect' from dual; 
--ALTER SESSION SET EVENTS '10046 trace name context forever, level 1'; 

-- Use a FORALL to move an associative array into a table.
DECLARE

  -- Define an associative array of integers.
  TYPE number_table IS TABLE OF bulk_numbers.number_id%TYPE;

  -- Define a variable of the associative array type.
  number_list NUMBER_TABLE := number_table();

BEGIN

  -- Extend space in number list.
  number_list.EXTEND(10000);

  -- Loop from 1 to a million and increment associative array.
  FOR i IN 1..10000 LOOP

    -- Assign number value.
    number_list(i) := i;

  END LOOP;

  -- Loop through all to do a bulk insert.
  FORALL i IN 1..number_list.COUNT
    INSERT
    INTO     bulk_numbers
    VALUES  (number_list(i));

  -- Commit records.
  COMMIT;

END;
/

-- Use a BULK COLLECT to retrieve a table into an
-- associative array.
DECLARE

  -- Define an associative array of integers.
  TYPE number_table IS TABLE OF bulk_numbers.number_id%TYPE;

  -- Define a variable of the associative array type.
  number_list NUMBER_TABLE := number_table();

BEGIN

  -- Gather all rows in a bulk collect.
  SELECT   number_id
  BULK COLLECT
  INTO     number_list
  FROM     bulk_numbers
  ORDER BY 1;

  -- Print a title
  DBMS_OUTPUT.PUT_LINE('Bulk Collected:');
  DBMS_OUTPUT.PUT_LINE('---------------');

  -- Loop through to print elements.
  FOR i IN number_list.FIRST..number_list.LAST LOOP

    -- Print only the first and last two.
    IF i <= 2 OR i >= 9999 THEN

      -- Print an indexed element from the associative array.
      DBMS_OUTPUT.PUT_LINE('Number ['||number_list(i)||']');

    END IF;

  END LOOP;

END;
/
--ALTER SESSION SET EVENTS '10046 trace name context off';

