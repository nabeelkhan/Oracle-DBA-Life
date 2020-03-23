/*
 * GenerateAuthorID.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates the use of :new in a trigger.
 */

SET ECHO ON

CREATE OR REPLACE TRIGGER GenerateAuthorID
  BEFORE INSERT OR UPDATE ON authors
  FOR EACH ROW
BEGIN
  /* Fill in the ID field of authors with the next value from
     author_sequence. Since ID is a column in authors, :new.ID
     is a valid reference. */
  SELECT author_sequence.NEXTVAL
    INTO :new.ID
    FROM dual;
END GenerateAuthorID;
/
show errors

-- Both of these INSERTs will use the sequence for the ID
-- column
INSERT INTO authors (first_name, last_name)
  VALUES ('Lolita', 'Lazarus');
INSERT INTO authors (ID, first_name, last_name)
  VALUES (-7, 'Zelda', 'Zoom');

-- This version of the trigger uses the REFERENCING clause.
CREATE OR REPLACE TRIGGER GenerateAuthorID
  BEFORE INSERT OR UPDATE ON authors
  REFERENCING new AS new_author
  FOR EACH ROW
BEGIN
  /* Fill in the ID field of authors with the next value from
     author_sequence. Since ID is a column in authors, :new.ID
     is a valid reference. */
  SELECT author_sequence.NEXTVAL
    INTO :new_author.ID
    FROM dual;
END GenerateAuthorID;
/
show errors
