/*
 * create_assocarray1.sql
 * Chapter 6, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script builds an associative array.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

DECLARE

  -- Define an associative array of strings.
  TYPE card_table IS TABLE OF VARCHAR2(5 CHAR)
    INDEX BY BINARY_INTEGER;

  -- Declare and attempt to construct an associative array.
  cards CARD_TABLE := card_table('A','B','C');

BEGIN

  NULL;

END;
/
