/*
 * create_nestedtable2.sql
 * Chapter 6, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This constructs a null element nested table, then extends it one element at a time.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

DECLARE

  -- Define a nested table of variable length strings.
  TYPE card_suit IS TABLE OF VARCHAR2(5 CHAR);

  -- Declare and initialize a null set of rows.
  cards CARD_SUIT := card_suit();

BEGIN

  -- Loop through the three records.
  FOR i IN 1..3 LOOP

    -- Initialize row.
    cards.EXTEND;

    -- Assign values to subscripted members of the varray.
    IF    i = 1 THEN
      cards(i) := 'Ace';
    ELSIF i = 2 THEN
      cards(i) := 'Two';
    ELSIF i = 3 THEN
      cards(i) := 'Three';
    END IF;

  END LOOP;

  -- Print title.
  dbms_output.put_line(
    'Nested table initialized as Ace, Two and Three.');
  dbms_output.put_line(
    '-----------------------------------------------');

  -- Loop through the records to print the nested table.
  FOR i IN 1..3 LOOP

    -- Print the contents.
    dbms_output.put     ('Cards ['||i||'] ');
    dbms_output.put_line('['||cards(i)||']');

  END LOOP;

END;
/
