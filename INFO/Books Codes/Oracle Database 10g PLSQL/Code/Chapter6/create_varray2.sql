/*
 * create_varray2.sql
 * Chapter 6, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This defines a varray with a null element constructor and extends it one element at a time.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

DECLARE

  -- Define a varray of integer with 3 rows.
  TYPE integer_varray IS VARRAY(3) OF INTEGER;

  -- Declare and initialize a null set of rows.
  varray_integer INTEGER_VARRAY := integer_varray();

BEGIN

  -- Loop through the three records.
  FOR i IN 1..3 LOOP

    -- Initialize row.
    varray_integer.EXTEND;

    -- Assign values to subscripted members of the varray.
    varray_integer(i) := 10 + i;

  END LOOP;

  -- Print title.
  dbms_output.put_line('Varray initialized as values.');
  dbms_output.put_line('-----------------------------');

  -- Loop through the records to print the varrays.
  FOR i IN 1..3 LOOP

    -- Print the contents.
    dbms_output.put     ('Integer Varray ['||i||'] ');
    dbms_output.put_line('['||varray_integer(i)||']');

  END LOOP;

END;
/
