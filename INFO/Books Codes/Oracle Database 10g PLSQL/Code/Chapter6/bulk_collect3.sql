/*
 * bulk_collect3.sql
 * Chapter 6, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates how to do a non-bulk select into elements
 * of a PL/SQL table.
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
(number_id                INTEGER              NOT NULL
,CONSTRAINT number_id_pk  PRIMARY KEY (number_id));

-- These are tunning commands that you may unremark.
--ALTER SESSION SET sql_trace=true; 
--SELECT 'Tuning for bulk_collect' from dual; 
--ALTER SESSION SET EVENTS '10046 trace name context forever, level 1'; 

-- Use a FORALL to move an associative array into a table.
DECLARE

  -- Define an associative array of integers.
  TYPE number_table IS TABLE OF bulk_numbers.number_id%TYPE
    INDEX BY BINARY_INTEGER;

  -- Define a variable of the associative array type.
  number_list NUMBER_TABLE;

BEGIN

  -- Loop from 1 to a million and increment associative array.
  FOR i IN 1..10000 LOOP

    INSERT
    INTO     bulk_numbers
    VALUES  (i);

  END LOOP;

  -- Commit records.
  COMMIT;

END;
/

-- Use a BULK COLLECT to retrieve a table into an
-- associative array.
DECLARE

  -- Define an associative array of integers.
  TYPE number_table IS TABLE OF bulk_numbers.number_id%TYPE
    INDEX BY BINARY_INTEGER;

  -- Define a variable of the associative array type.
  number_list NUMBER_TABLE;

BEGIN

  -- Gather all rows in a bulk collect.
  FOR i IN 1..10000 LOOP

    SELECT   number_id
    INTO     number_list(i)
    FROM     bulk_numbers
    WHERE    number_id = i
    ORDER BY 1;

  END LOOP;

  -- Print a title
  DBMS_OUTPUT.PUT_LINE('Row Collected:');
  DBMS_OUTPUT.PUT_LINE('--------------');

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

-- These are tunning commands that you may unremark.
--ALTER SESSION SET EVENTS '10046 trace name context off';

