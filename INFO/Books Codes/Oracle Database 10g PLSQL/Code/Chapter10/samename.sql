/*
 * samename.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates user defined triggers.
 */

-- Legal, since triggers and tables are in different namespaces.
CREATE OR REPLACE TRIGGER inventory
  BEFORE INSERT ON inventory
BEGIN
  INSERT INTO temp_table (char_col)
    VALUES ('Trigger fired!');
END inventory;
/

-- Illegal, since procedures and tables are in the same namespace.
CREATE OR REPLACE PROCEDURE inventory AS
BEGIN
  INSERT INTO temp_table (char_col)
    VALUES ('Procedure called!');
END inventory;
/
