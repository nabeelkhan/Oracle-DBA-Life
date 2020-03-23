/*
 * limit.sql
 * Chapter 6, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates how to use the Oracle10g Collection API
 * LIMIT method against a collection.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

DECLARE

  -- Define a varray type of INTEGER.
  TYPE number_varray IS VARRAY(5) OF INTEGER;

  -- Define a variable of the varray type.
  number_list NUMBER_VARRAY := number_varray(1,2,3);

  -- Define a local procedure to check and print elements.
  PROCEDURE print_list
    (list_in NUMBER_VARRAY) IS

  BEGIN

    -- Loop through the possible index values of the list.
    FOR i IN list_in.FIRST..list_in.COUNT LOOP

      -- Print the element.
      DBMS_OUTPUT.PUT_LINE(
        'List Index ['||i||'] '||
        'List Value ['||list_in(i)||']');

    END LOOP;

  END print_list;

BEGIN

  -- Print a title.
  DBMS_OUTPUT.PUT_LINE('Varray after initialization');
  DBMS_OUTPUT.PUT_LINE('---------------------------');

  -- Print the list.
  print_list(number_list);

  -- Extend null element to maximum limit.
  number_list.EXTEND(number_list.LIMIT - number_list.LAST);

  -- Print a title.
  DBMS_OUTPUT.PUT(CHR(10));
  DBMS_OUTPUT.PUT_LINE('Varray after extension');
  DBMS_OUTPUT.PUT_LINE('----------------------');

  -- Print the list.
  print_list(number_list);

END;
/
