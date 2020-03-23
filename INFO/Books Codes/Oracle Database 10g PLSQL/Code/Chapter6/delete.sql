/*
 * delete.sql
 * Chapter 6, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates how to use the Oracle10g Collection API
 * DELETE method against a set of elements.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

DECLARE

  -- Define a nested table type of INTEGER.
  TYPE number_table IS TABLE OF INTEGER;

  -- Define a variable of the nested table type.
  number_list NUMBER_TABLE;

  -- Define a local procedure to check and print elements.
  PROCEDURE print_list
    (list_in NUMBER_TABLE) IS

  BEGIN

    -- Loop through the possible index values of the list.
    FOR i IN list_in.FIRST..list_in.LAST LOOP

      -- Check if the subscripted element is there.
      IF list_in.EXISTS(i) THEN

        -- Print the element.
        DBMS_OUTPUT.PUT_LINE('List ['||list_in(i)||']');

      END IF;

    END LOOP;

  END print_list;

BEGIN

  -- Check if a subscript element of one does not exists.
  IF NOT number_list.EXISTS(1) THEN

    -- Construct the collection.
    number_list := number_table(1,2,3,4,5);

  END IF;

  -- Print a title.
  DBMS_OUTPUT.PUT_LINE('Nested table before a deletion');
  DBMS_OUTPUT.PUT_LINE('------------------------------');

  -- Print the list.
  print_list(number_list);

  -- Delete an element.
  number_list.DELETE(2,4);

  -- Print a title.
  DBMS_OUTPUT.PUT_LINE(CHR(10)||
                       'Nested table after a deletion');
  DBMS_OUTPUT.PUT_LINE('-----------------------------');

  -- Print the list.
  print_list(number_list);  

END;
/
