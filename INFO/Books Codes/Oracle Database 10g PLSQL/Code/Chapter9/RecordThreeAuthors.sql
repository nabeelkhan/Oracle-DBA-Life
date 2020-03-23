/*
 * RecordThreeAuthors.sql
 * Chapter 9, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates a procedure with dependencies.
 */

CREATE OR REPLACE PROCEDURE RecordThreeAuthors AS
  CURSOR c_Books IS
    SELECT *
      FROM books;
BEGIN
  FOR v_BookRecord in c_Books LOOP
    -- Record all the books which have three authors
    -- in temp_table.
    IF ThreeAuthors(v_BookRecord.ISBN) THEN
      INSERT INTO temp_table (char_col) VALUES
        (v_BookRecord.title || ' has three authors!');
    END IF;
  END LOOP;
END RecordThreeAuthors;
/
