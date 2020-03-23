/*
 * count.sql
 * Chapter 6, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates how to use the Oracle10g Collection API
 * COUNT method against an element.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

DECLARE

  -- Define a nested table type of INTEGER.
  TYPE number_table IS TABLE OF INTEGER;

  -- Define a variable of the nested table type.
  number_list NUMBER_TABLE := number_table(1,2,3,4,5);

BEGIN

  -- Print a title.
  DBMS_OUTPUT.PUT_LINE('How many elements');
  DBMS_OUTPUT.PUT_LINE('-----------------');

  -- Print the list.
  DBMS_OUTPUT.PUT_LINE('Count ['||number_list.COUNT||']');

END;
/
