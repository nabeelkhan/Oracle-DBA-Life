/*
 * create_varray3.sql
 * Chapter 6, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This defines a varray with a three element constructor of null elements and attempt to populate it beyond three elements.
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
  AS VARRAY(3) OF INTEGER;
/

DECLARE

  -- Declare and initialize a null set of rows.
  varray_integer INTEGER_VARRAY := integer_varray(NULL,NULL,NULL);

BEGIN

  -- Loop through the three records.
  FOR i IN 1..3 LOOP

    -- Assign values to subscripted members of the varray.
    varray_integer(i) := 10 + i;

  END LOOP;

  -- Print title.
  dbms_output.put_line('Varray initialized as values.');
  dbms_output.put_line('-----------------------------');

  -- Loop through the three records.
  FOR i IN 1..3 LOOP

    -- Print contents.
    dbms_output.put     ('Integer Varray ['||i||'] ');
    dbms_output.put_line('['||varray_integer(i)||']');

  END LOOP;

END;
/
