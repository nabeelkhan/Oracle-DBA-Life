/*
 * execute.sql
 * Chapter 9, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates the behavior of the EXECUTE system privilege.
 */

set echo on
set serveroutput on

-- First create the users userA and userB, with the necessary
-- objects in each.  We need to connect to an account with the
-- necessary privileges, such as SYSTEM, to do this.
-- You may also want to change the UNLIMITED TABLESPACE
-- privilege below to grant explicit limits on tablespaces in your
-- database.
connect system/manager
DROP USER UserA CASCADE;
CREATE USER UserA IDENTIFIED BY UserA;
GRANT CREATE SESSION, CREATE TABLE, CREATE PROCEDURE,
      UNLIMITED TABLESPACE, CREATE ROLE, DROP ANY ROLE TO UserA;

DROP USER UserB CASCADE;
CREATE USER UserB IDENTIFIED BY UserB;
GRANT CREATE SESSION, CREATE TABLE, CREATE PROCEDURE,
      UNLIMITED TABLESPACE TO UserB;

connect UserA/UserA

-- ***********************************
-- Scenario illustrated by Figure 7-8: All objects owned by UserA.
-- ***********************************

-- First create the books table.  We won't bother creating authors,
-- so don't include the integrity constraints.
CREATE TABLE books (
  isbn      CHAR(10) PRIMARY KEY,
  category  VARCHAR2(20),
  title     VARCHAR2(100),
  num_pages NUMBER,
  price     NUMBER,
  copyright NUMBER(4),
  author1   NUMBER,
  author2   NUMBER,
  author3   NUMBER 
);

-- And insert some data.  This is only a subset of the rows
-- included in the complete books table.  Note that one book
-- has three authors, and the other only two.

INSERT
INTO books
(isbn
,category
,title
,num_pages
,price
,copyright
,author1
,author2
,author3)
VALUES
('007212606X'
,'Oracle Basics'
,'Oracle PL/SQL 101'
,420
,39.99
,2000
,1
,2
,3);

INSERT
INTO books
(isbn
,category
,title
,num_pages
,price
,copyright
,author1
,author2
,author3)
VALUES
('0072131454'
,'Oracle Basics'
,'Oracle Performance Tuning 101'
,404
,39.99
,2001
,1
,2
,3);

INSERT
INTO books
(isbn
,category
,title
,num_pages
,price
,copyright
,author1
,author2
,author3)
VALUES
('72121203'
,'Oracle Basics'
,'Oracle DBA 101'
,563
,39.99
,1999
,1
,2
,3);

INSERT
INTO books
(isbn
,category
,title
,num_pages
,price
,copyright
,author1
,author2)
VALUES
('72122048'
,'Oracle Basics'
,'Oracle8i: A Beginner''s Guide'
,765
,44.99
,1999
,4
,5);

-- And now temp_table.
CREATE TABLE temp_table (
  num_col    NUMBER,
  char_col   VARCHAR2(60)
);

-- We also need ThreeAuthors:
CREATE OR REPLACE FUNCTION ThreeAuthors(p_ISBN IN books.isbn%TYPE)
  RETURN BOOLEAN AS

  v_Author3 books.author3%TYPE;
BEGIN
  -- Select the third author for the supplied book into v_Author3.
  SELECT author3
    INTO v_Author3
    FROM books
    WHERE isbn = p_ISBN;

  -- If v_Author3 is NULL, that means that the book has less then 3
  -- authors, so we can return false.  Otherwise, return true.
  IF v_Author3 IS NULL THEN
    RETURN FALSE;
  ELSE
    RETURN TRUE;
  END IF;
END ThreeAuthors;
/
 
-- And now we can create RecordThreeAuthors.
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
show errors

-- Now that all of the objects have been created, grant EXECUTE on
-- RecordThreeAuthors to UserB.  Note that UserB has no other
-- privileges on UserA's objects.
GRANT EXECUTE ON RecordThreeAuthors to UserB;

-- connect as UserB, and run RecordThreeAuthors.  The results will
-- be stored in temp_table owned by UserA, since that is the only
-- copy of temp_table.
connect UserB/UserB
BEGIN
  UserA.RecordThreeAuthors;
  COMMIT;
END;
/

-- Query temp_table as UserA to verify the results.
connect UserA/UserA
SELECT * FROM temp_table;

-- ***********************************
-- Scenario illustrated by Figure 7-9: UserB also owns a copy of
--                                     temp_table.
-- ***********************************

-- Create UserB.temp_table.
connect UserB/UserB
CREATE TABLE temp_table (
  num_col    NUMBER,
  char_col   VARCHAR2(60)
);

-- Now if we call UserA.RecordThreeAuthors, UserA's copy of
-- temp_table gets modified.
BEGIN
  UserA.RecordThreeAuthors;
  COMMIT;
END;
/

-- Query UserB's table: this should return no rows.
SELECT * FROM temp_table;

-- Query UserA's table: this should return two rows - one for
-- each of the executions.
connect UserA/UserA
SELECT * FROM temp_table;

-- ***********************************
-- Scenario illustrated by Figure 7-10: UserB owns temp_table and
--                                      RecordThreeAuthors, GRANTs
--                                      done directly.
-- ***********************************

-- First drop them from UserA:
connect UserA/UserA
DROP TABLE temp_table;
DROP PROCEDURE RecordThreeAuthors;

-- We now need to GRANT privileges on ThreeAuthors and books
-- to UserB:
GRANT SELECT ON books TO UserB;
GRANT EXECUTE ON ThreeAuthors TO UserB;

-- UserB already owns temp_table, so we just need to create the
-- procedure.  Note that this refers to ThreeAuthors in UserA's
-- schema through dot notation.  If the above GRANTs were not done,
-- this would not compile.
connect UserB/UserB
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

-- If we execute RecordThreeAuthors now, the results are stored in
-- temp_table owned by UserB.
BEGIN
  RecordThreeAuthors;
  COMMIT;
END;
/

-- This should return one row.
SELECT * FROM temp_table;

-- ***********************************
-- Scenario illustrated by Figure 7-11: UserB owns temp_table and
--                                      RecordThreeAuthors, GRANTs
--                                      done via a role.
-- ***********************************

connect UserA/UserA
-- First revoke the earlier GRANTs
REVOKE SELECT ON books FROM UserB;
REVOKE EXECUTE ON ThreeAuthors FROM UserB;

-- Now create the role
DROP ROLE UserA_Role;
CREATE ROLE UserA_Role;
GRANT SELECT ON books TO UserA_Role;
GRANT EXECUTE ON ThreeAuthors TO UserA_Role;
GRANT UserA_Role TO UserB;

-- Attempting to create RecordThreeAuthors as UserB will now result
-- in ORA-942 and PLS-201 errors:
connect UserB/UserB
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
show errors
