/*
 * CheckPrice.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates user defined trigger.
 */

SET ECHO ON

CREATE OR REPLACE TRIGGER CheckPrice
  BEFORE INSERT OR UPDATE OF price ON books
  FOR EACH ROW
  WHEN (new.price > 49.99) BEGIN
  /* Trigger body goes here. */
  NULL;
END;
/
