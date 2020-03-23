/*
 * LevelUpdate.sql
 * Chapter 4, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script shows the pseudocolumn LEVEL and an 
 * example of using the levels with an update. 
 */

exec clean_schema.trigs
exec clean_schema.procs
exec clean_schema.tables
exec clean_schema.ind

CREATE TABLE books (
  isbn      VARCHAR2(10) PRIMARY KEY,
  parent_isbn VARCHAR2(10),
  series    VARCHAR2(20),
  category  VARCHAR2(20),
  title     VARCHAR2(100),
  num_pages NUMBER,
  price     NUMBER,
  copyright NUMBER(4));

INSERT INTO books (isbn, parent_isbn, series, category, title, num_pages, price, copyright)
  VALUES ('72191473', '72121467', 'Oracle PL/SQL', 'Oracle Server', 'Oracle9i PL/SQL Programming', 664, 49.99, 2002);

INSERT INTO books (isbn, parent_isbn, series, category, title, num_pages, price, copyright)
  VALUES ('72121467', null, 'Oracle PL/SQL', 'Oracle Server', 'Oracle8i Advanced PL/SQL Programming', 772, 49.99, 2000);

INSERT INTO books (isbn, parent_isbn, series, category, title, num_pages, price, copyright)
  VALUES ('72230665', '72191473', 'Oracle PL/SQL', 'Oracle Server', 'Oracle Database 10g PL/SQL Programming', 1008, 54.99, 2004);

INSERT INTO books (isbn, parent_isbn, series, category, title, num_pages, price, copyright)
  VALUES ('72132302', null, 'Oracle Ebusiness', 'Oracle Ebusiness', 'Oracle E-Business Suite Financials Handbook', 820, 59.99, 2002);

commit;

PROMPT
PROMPT ** Alter table books, adding a position column
PROMPT

ALTER TABLE books
ADD position NUMBER(10);

PROMPT
PROMPT ** Run an anonymous block that updates the records in the table
PROMPT **  providing the current position of each record.
PROMPT

SET SERVEROUTPUT ON

DECLARE
   v_level PLS_INTEGER;
   v_title BOOKS.TITLE%TYPE;

   CURSOR cur_tree
   IS
      SELECT isbn, title, series
      FROM books;
BEGIN

FOR l IN cur_tree
LOOP

   SELECT max(LEVEL)
   INTO v_level
   FROM books
   START WITH isbn = l.isbn
   CONNECT BY PRIOR parent_isbn = isbn;

   UPDATE books
   SET position = v_level
   WHERE isbn = l.isbn;

END LOOP;

COMMIT;

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE(sqlerrm);
END;
/

PROMPT
PROMPT ** Check the data in the table to make certain the records
PROMPT **  were updated.
PROMPT

SET PAGES 9999
SELECT title, position
FROM books
ORDER BY series, position;

PROMPT
PROMPT ** Insert a new record for Oracle PL/SQL version 8.0
PROMPT **  and update the 8i version to include a parent_isbn
PROMPT

INSERT INTO books (isbn, parent_isbn, series, category, title, num_pages, price, copyright)
  VALUES ('111111', null, 'Oracle PL/SQL', 'Oracle Server', 'Oracle8.0 PL/SQL Programming', 772, 49.99, 2000);

UPDATE books
SET parent_isbn = '111111'
WHERE isbn = '72121467';

COMMIT;

PROMPT
PROMPT
PROMPT ** With the insert and update complete, rerun the select to show
PROMPT **  the position column is null for the new record.
PROMPT

SELECT title, position
FROM books
ORDER BY series, position;

PROMPT
PROMPT ** Rerun the same anonymous block to update the position column
PROMPT

DECLARE
   v_level PLS_INTEGER;
   v_title BOOKS.TITLE%TYPE;

   CURSOR cur_tree
   IS
      SELECT isbn, title, series
      FROM books;
BEGIN

FOR l IN cur_tree
LOOP

   SELECT max(LEVEL)
   INTO v_level
   FROM books
   START WITH isbn = l.isbn
   CONNECT BY PRIOR parent_isbn = isbn;

   UPDATE books
   SET position = v_level
   WHERE isbn = l.isbn;

END LOOP;

COMMIT;

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE(sqlerrm);
END;
/

PROMPT
PROMPT ** Confirm the change with a select
PROMPT

SELECT title, position
FROM books
ORDER BY series, position;

PROMPT
PROMPT ** Not only was the new record updated, but all other
PROMPT **  records had their positions change relative to the 
PROMPT **  new root.
PROMPT