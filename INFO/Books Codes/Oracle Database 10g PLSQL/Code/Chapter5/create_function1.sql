/*
 * create_function1.sql
 * Chapter 5, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates using a record type as a function return value.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

@create_record1.sql

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

  -- Define a local function to return a record type.
  FUNCTION get_row 
    (individual_id_in INTEGER)
  RETURN INDIVIDUAL_RECORD IS

    -- Define a cursor to return a row of individuals.
    CURSOR c
      (individual_id_cursor INTEGER) IS
      SELECT   *
      FROM individuals
      WHERE    individual_id = individual_id_cursor;

  BEGIN

    -- Loop through the cursor for a single row.
    FOR i IN c(individual_id_in) LOOP

      -- Return a %ROWTYPE from the INDIVIDUALS table.
      RETURN i;

    END LOOP;

  END get_row;

BEGIN

  -- Demonstrate function return variable assignment.
  individual := get_row(1);
  
  -- Display results.
  dbms_output.put_line(CHR(10));
  dbms_output.put_line('INDIVIDUAL_ID  : '||individual.individual_id);
  dbms_output.put_line('FIRST_NAME     : '||individual.first_name);
  dbms_output.put_line('MIDDLE_INITIAL : '||individual.middle_initial);
  dbms_output.put_line('LAST_NAME      : '||individual.last_name);

END;
/    
