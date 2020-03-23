/*
 * callPP.sql
 * Chapter 9, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates call to a persistent package.
 */

set serveroutput on

DECLARE
  v_BookTable PersistPkg.t_BookTable;
  v_NumRows NUMBER := PersistPkg.v_MaxRows;
  v_Title books.title%TYPE;
BEGIN
  PersistPkg.ReadBooks(v_BookTable, v_NumRows);
  DBMS_OUTPUT.PUT_LINE(' Fetched ' || v_NumRows || ' rows:');
  FOR v_Count IN 1..v_NumRows LOOP
    SELECT title
      INTO v_Title
      FROM books
      WHERE isbn = v_BookTable(v_Count);
    DBMS_OUTPUT.PUT_LINE(v_Title);
  END LOOP;
END;
/
