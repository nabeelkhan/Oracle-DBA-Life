/*
 * Level.sql
 * Chapter 4, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script shows the pseudocolumn LEVEL and an 
 * example of using the levels.  
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

SET SERVEROUTPUT ON

PROMPT
PROMPT ** The following is a demonstration of LEVEL, and the 
PROMPT **  use of START WITH ... CONNECT BY PRIOR to display
PROMPT **  parent/child hierarchical relationships.
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

DBMS_OUTPUT.PUT_LINE(l.title||' is book '
                     ||v_level||' in the '||l.series||' series');

END LOOP;

CLOSE cur_tree;

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE(sqlerrm);
END;
/

