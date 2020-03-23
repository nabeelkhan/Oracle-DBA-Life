/*
 * create_assocarray2.sql
 * Chapter 6, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates you cannot traverse an associative array
 * until elements are initialized.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

DECLARE

  -- Define an associative array of strings.
  TYPE card_table IS TABLE OF VARCHAR2(5 CHAR)
    INDEX BY BINARY_INTEGER;

  -- Define an associative array variable.
  cards CARD_TABLE;

BEGIN

    -- Print an element of the cards associative array.
    DBMS_OUTPUT.PUT_LINE(cards(1));

END;
/
