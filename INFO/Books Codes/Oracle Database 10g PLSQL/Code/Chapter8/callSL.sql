/*
 * callSL.sql
 * Chapter 8, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, and Scott Urman
 *
 * This block illustrates how to call a packaged procedure which
 * takes a named type parameter.
 */
 
set serveroutput on
DECLARE
  v_BooksInStock InventoryOps.t_ISBNTable;
  v_NumBooks BINARY_INTEGER;
BEGIN
  -- Fill the PL/SQL table with the ISBNs of the books which
  -- are in stock.
  InventoryOps.StatusList('IN STOCK', v_BooksInStock, v_NumBooks);

  -- And print them out. 
  FOR v_LoopCounter IN 1..v_NumBooks LOOP
    DBMS_OUTPUT.PUT_LINE('ISBN ' || v_BooksInStock(v_LoopCounter) ||
                         ' is in stock');                         
  END LOOP;
END;
/
