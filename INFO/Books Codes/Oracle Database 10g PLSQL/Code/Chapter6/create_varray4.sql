/*
 * create_varray4.sql
 * Chapter 6, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This defines a varray with a null element constructor and extends it one element at a time
 * by a formula.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

BEGIN

  -- Loop if a row is found and delete it.
  FOR i IN (SELECT   null
            FROM     user_types
            WHERE    type_name = 'INTEGER_VARRAY') LOOP

    EXECUTE IMMEDIATE 'DROP TYPE integer_varray';
    COMMIT;

  END LOOP;

END;
/

CREATE OR REPLACE TYPE integer_varray
  AS VARRAY(100) OF INTEGER NOT NULL;
/

DECLARE

  -- Declare and initialize a null set of rows.
  varray_integer INTEGER_VARRAY := integer_varray();

BEGIN

  -- Loop through all records to print the varray contents.
  FOR i IN 1..varray_integer.LIMIT LOOP

    -- Initialize row.
    varray_integer.EXTEND;

  END LOOP;

    -- Print to console how many rows are initialized.
    dbms_output.put     ('Integer Varray Initialized ');
    dbms_output.put_line('['||varray_integer.COUNT||']');

END;
/
