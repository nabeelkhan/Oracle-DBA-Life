/*
 * create_nestedtable4.sql
 * Chapter 6, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This constructs a two varrays and one nested table type in the database, then it assigns the contents of the varrays into a nested table.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

-- Define a varray of four rows of variable length strings.
CREATE OR REPLACE TYPE card_unit_varray
  AS VARRAY(13) OF VARCHAR2(5 CHAR);
/

-- Define a varray of four rows of variable length strings.
CREATE OR REPLACE TYPE card_suit_varray
  AS VARRAY(4) OF VARCHAR2(8 CHAR);
/

-- Define a table of variable length strings.
CREATE OR REPLACE TYPE card_deck_table
  AS TABLE OF VARCHAR2(17 CHAR);
/

DECLARE

  -- Define a counter to manage 1 to 52 cards in a deck.
  counter INTEGER := 0;

  -- Declare and initialize a varray of card suits.
  suits CARD_SUIT_VARRAY :=
    card_suit_varray('Clubs'
                    ,'Diamonds'
                    ,'Hearts'
                    ,'Spades');

  -- Declare and initialize a varray of card units.
  units CARD_UNIT_VARRAY :=
    card_unit_varray('Ace','Two','Three','Four'
                    ,'Five','Six','Seven','Eight'
                    ,'Nine','Ten','Jack','Queen'
                    ,'King');

  -- Declare and initialize a null nested table.
  deck CARD_DECK_TABLE := card_deck_table(); 

BEGIN

  -- Loop through the four suits of cards.
  FOR i IN 1..suits.COUNT LOOP

    -- Loop through the thirteen units of cards.
    FOR j IN 1..units.COUNT LOOP

      -- Increment counter.
      counter := counter + 1;

      -- Initialize row.
      deck.EXTEND;

      -- Assign a value to the element.
      deck(counter) := units(j)||' of '||suits(i);

    END LOOP;

  END LOOP;

  -- Print title.
  dbms_output.put_line('Deck of cards by suit.');
  dbms_output.put_line('----------------------');

  -- Loop through the deck of cards.
  FOR i IN 1..counter LOOP

    -- Print the contents.
    dbms_output.put_line('['||deck(i)||']');

  END LOOP;

END;
/
