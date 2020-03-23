/*
 * create_nestedtable3.sql
 * Chapter 6, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This constructs a null element nested table type in the database, then extends it one element at a time.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

-- Define a table of variable length strings.
CREATE OR REPLACE TYPE card_table
  AS TABLE OF VARCHAR2(5 CHAR);
/

DECLARE

  -- Declare and initialize a nested table with three rows.
  cards CARD_TABLE := card_table(NULL,NULL,NULL);

BEGIN

  -- Print title.
  dbms_output.put_line(
    'Nested table initialized as null values.');
  dbms_output.put_line(
    '----------------------------------------');

  -- Loop through the three records.
  FOR i IN 1..3 LOOP

    -- Print the contents.
    dbms_output.put     ('Cards Varray ['||i||'] ');
    dbms_output.put_line('['||cards(i)||']');

  END LOOP;

  -- Assign values to subscripted members of the varray.
  cards(1) := 'Ace';
  cards(2) := 'Two';
  cards(3) := 'Three';

  -- Print title.
  dbms_output.put     (CHR(10)); -- Visual line break.
  dbms_output.put_line(
    'Nested table initialized as Ace, Two and Three.');
  dbms_output.put_line(
    '-----------------------------------------------');

  -- Loop through the three records to print the varray contents.
  FOR i IN 1..3 LOOP

    dbms_output.put_line('Cards ['||i||'] '
    ||                   '['||cards(i)||']');

  END LOOP;

END;
/
