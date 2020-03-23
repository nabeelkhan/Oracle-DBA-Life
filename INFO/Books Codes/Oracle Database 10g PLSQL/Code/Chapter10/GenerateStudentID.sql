/*
 * GenerateStudentID.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates user defined trigger.
 */

SET ECHO ON

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
