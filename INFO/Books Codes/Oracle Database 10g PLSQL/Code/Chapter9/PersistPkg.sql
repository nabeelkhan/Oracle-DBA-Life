/*
 * PersistPkg.sql
 * Chapter 9, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates user defined package.
 */

CREATE OR REPLACE PACKAGE PersistPkg AS
  -- Type which holds an array of book ISBN's
  TYPE t_BookTable IS TABLE OF books.isbn%TYPE
    INDEX BY BINARY_INTEGER;

  -- Maximum number of rows to return each time.
  v_MaxRows NUMBER := 4;

  -- Returns up to v_MaxRows ISBN's
  PROCEDURE ReadBooks(p_BookTable OUT t_BookTable,
                      p_NumRows   OUT NUMBER);

END PersistPkg;
/
show errors

CREATE OR REPLACE PACKAGE BODY PersistPkg AS
  -- Query against books.  Since this is global to the package
  -- body, it will remain past a database call.
  CURSOR c_BasicBooks IS
    SELECT isbn
      FROM BOOKS
      WHERE category = 'Oracle Basics'
      ORDER BY title;

  PROCEDURE ReadBooks(p_BookTable OUT t_BookTable,
                      p_NumRows   OUT NUMBER) IS
    v_Done BOOLEAN := FALSE;
    v_NumRows NUMBER := 1;
  BEGIN
    IF NOT c_BasicBooks%ISOPEN THEN
      -- First open the cursor
      OPEN c_BasicBooks;
    END IF;

    -- Cursor is open, so we can fetch up to v_MaxRows
    WHILE NOT v_Done LOOP
      FETCH c_BasicBooks INTO p_BookTable(v_NumRows);
      IF c_BasicBooks%NOTFOUND THEN
        -- No more data, so we're finished.
        CLOSE c_BasicBooks;
        v_Done := TRUE;
      ELSE
        v_NumRows := v_NumRows + 1;
        IF v_NumRows > v_MaxRows THEN
          v_Done := TRUE;
        END IF;
      END IF;
    END LOOP;

    -- Return the actual number of rows fetched.
    p_NumRows := v_NumRows - 1;

  END ReadBooks;
END PersistPkg;
/
show errors
