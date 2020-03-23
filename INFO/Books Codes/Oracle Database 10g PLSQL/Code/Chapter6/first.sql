/*
 * first.sql
 * Chapter 6, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates how to use the Oracle10g Collection API
 * FIRST and LAST methods against a collection.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

DECLARE

  -- Define a nested table type of INTEGER.
  TYPE number_table IS TABLE OF INTEGER
    INDEX BY VARCHAR2(9 CHAR);

  -- Define a variable of the nested table type.
  number_list NUMBER_TABLE;

BEGIN

  -- Build three elements with unique string subscripts.
  number_list('One') := 1;
  number_list('Two') := 2;
  number_list('Nine') := 9;

  -- Print the first index and next.
  DBMS_OUTPUT.PUT_LINE(
    'FIRST Index ['||number_list.FIRST||']');
  DBMS_OUTPUT.PUT_LINE(
    'NEXT  Index ['||number_list.NEXT(number_list.FIRST)||']');

  -- Print the last index and prior.
  DBMS_OUTPUT.PUT_LINE(CHR(10)||
    'LAST  Index ['||number_list.LAST||']');
  DBMS_OUTPUT.PUT_LINE(
    'PRIOR Index ['||number_list.PRIOR(number_list.LAST)||']');

END;
/
