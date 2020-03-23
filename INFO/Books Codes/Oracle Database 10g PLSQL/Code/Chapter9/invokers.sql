/*
 * invokers.sql
 * Chapter 9, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates invoker rights concepts.
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

INSERT INTO books (isbn, category, title, num_pages, price, copyright, author1, author2, author3)
  VALUES ('72121203', 'Oracle Basics', 'Oracle DBA 101', 563, 39.99, 1999, 1, 2, 3);

INSERT INTO books (isbn, category, title, num_pages, price, copyright, author1, author2)
  VALUES ('72122048', 'Oracle Basics', 'Oracle8i: A Beginner''s Guide', 765, 44.99, 1999, 4, 5);

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
 
-- Invoker's rights version of RecordThreeAuthors.  This version
-- runs under the privilege set of its caller, not the owner
CREATE OR REPLACE PROCEDURE RecordThreeAuthors
  AUTHID CURRENT_USER AS
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

-- ***********************************
-- Scenerio illustrated by Figure 7-12: UserB with SELECT on
--                                      books
-- ***********************************

-- Grant the necessary privileges to UserB.
GRANT EXECUTE ON RecordThreeAuthors TO UserB;
GRANT SELECT ON books TO UserB;

-- Call as UserA.  This will insert into UserA.temp_table.
BEGIN
  RecordThreeAuthors;
  COMMIT;
END;
/

-- Query temp_table.  There should be 1 row.
SELECT * FROM temp_table;

-- Connect as UserB and create temp_table there.
connect UserB/UserB
CREATE TABLE temp_table (
  num_col    NUMBER,
  char_col   VARCHAR2(60)
  );

-- Now the call to RecordThreeAuthors will insert into
-- UserB.temp_table.
BEGIN
  UserA.RecordThreeAuthors;
  COMMIT;
END;
/

-- So we should have one row here as well.
SELECT * FROM temp_table;

-- ***********************************
-- Scenerio illustrated by Figure 7-13: UserB without SELECT on
--                                      books
-- ***********************************

-- Connect as UserA, and revoke the privilege.
connect UserA/UserA
REVOKE SELECT ON books FROM UserB;

-- Calling as UserA will still work:
-- Call as UserA.  This will insert into UserA.temp_table.
BEGIN
  RecordThreeAuthors;
  COMMIT;
END;
/

-- Query temp_table.  There should be 2 rows, one from each
-- call to RecordThreeAuthors.
SELECT * FROM temp_table;

-- Connect as UserB and call.
connect UserB/UserB

-- Now the call to RecordThreeAuthors will fail.
BEGIN
  UserA.RecordThreeAuthors;
END;
/

-- ***********************************
-- Scenerio illustrated by Figure 7-14: SELECT on books GRANTed
--                                      via a role
-- ***********************************

-- Connect as UserA, and create the role.
connect UserA/UserA
DROP ROLE UserA_Role;
CREATE ROLE UserA_Role;
GRANT SELECT ON books TO UserA_Role;
GRANT UserA_Role TO UserB;

-- Connect as UserB and call.
connect UserB/UserB

-- Now the call to RecordThreeAuthors will succeed.
BEGIN
  UserA.RecordThreeAuthors;
  COMMIT;
END;
/

-- We should have two rows now.
SELECT * FROM temp_table;
