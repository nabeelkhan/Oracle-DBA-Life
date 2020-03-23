/*
 * CheckPrice2.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates user defined trigger.
 */

SET ECHO ON

CREATE OR REPLACE TRIGGER CheckPrice
  BEFORE INSERT OR UPDATE OF price ON books
  FOR EACH ROW
BEGIN
  IF :new.price > 49.99 THEN
    /* Trigger body goes here. */
    NULL;
  END IF;
END;
/
