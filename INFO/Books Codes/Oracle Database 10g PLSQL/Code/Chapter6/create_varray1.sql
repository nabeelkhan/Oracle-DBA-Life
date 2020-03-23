/*
 * create_varray1.sql
 * Chapter 6, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This defines a varray with a three element constructor of null elements.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

DECLARE

  -- Define a varray of integer with 3 rows.
  TYPE integer_varray IS VARRAY(3) OF INTEGER;

  -- Declare and initialize a varray that allows nulls.
  varray_integer INTEGER_VARRAY :=
    integer_varray(NULL,NULL,NULL);

BEGIN

  -- Print title.
  dbms_output.put_line('Varray initialized as nulls.');
  dbms_output.put_line('----------------------------');

  -- Loop through the three records.
  FOR i IN 1..3 LOOP

    -- Print the contents.
    dbms_output.put     ('Integer Varray ['||i||'] ');
    dbms_output.put_line('['||varray_integer(i)||']');

  END LOOP;

  -- Assign values to subscripted members of the varray.
  varray_integer(1) := 11;
  varray_integer(2) := 12;
  varray_integer(3) := 13;

  -- Print title.
  dbms_output.put     (CHR(10)); -- Visual line break.
  dbms_output.put_line('Varray initialized as values.');
  dbms_output.put_line('-----------------------------');

  -- Loop through the three records to print the varray contents.
  FOR i IN 1..3 LOOP

    dbms_output.put_line('Integer Varray ['||i||'] '
    ||                   '['||varray_integer(i)||']');

  END LOOP;

END;
/
