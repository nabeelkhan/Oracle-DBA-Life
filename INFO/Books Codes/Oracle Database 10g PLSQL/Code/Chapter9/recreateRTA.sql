/*
 * recreateRTA.sql
 * Chapter 9, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script builes RecordThreeAuthors package.
 */

-- Grant system privileges to USERB.
GRANT SELECT ON books TO USERB;
GRANT EXECUTE ON ThreeAuthors to USERB;

-- And now temp_table.
CREATE TABLE temp_table (
  num_col    NUMBER,
  char_col   VARCHAR2(60)
);

-- Recreate procedure.
CREATE OR REPLACE PROCEDURE RecordThreeAuthors AS
  CURSOR c_Books IS
    SELECT *
      FROM UserA.books;
BEGIN
  FOR v_BookRecord in c_Books LOOP
    -- Record all the books which have three authors
    -- in temp_table.
    IF UserA.ThreeAuthors(v_BookRecord.ISBN) THEN
      INSERT INTO temp_table (char_col) VALUES
        (v_BookRecord.title || ' has three authors!');
    END IF;
  END LOOP;
END RecordThreeAuthors;
/
