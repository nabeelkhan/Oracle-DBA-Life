-- ***************************************************************************
-- File: 12_37.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_37.lis

CREATE OR REPLACE PROCEDURE show_orders
   (p_order_by_txt IN VARCHAR2 := '1') IS
   -- This function outputs the order information to the terminal 
   -- (using DBMS_OUTPUT), but orders the output, using the 
   -- specified "ORDER BY" clause.
   lv_cursor_id_num PLS_INTEGER;
   lv_statement_txt VARCHAR2(500);
   lv_rowcount_num  PLS_INTEGER := 0;
   lv_ord_rec       s_order%ROWTYPE;
BEGIN
   -- Open a cursor to be used
   lv_cursor_id_num := DBMS_SQL.OPEN_CURSOR;
   -- Set up statement for first column
   lv_statement_txt := 'SELECT customer_id, total ' ||
                       'FROM   s_order ' ||
                       'ORDER BY ' || p_order_by_txt;
   DBMS_SQL.PARSE(lv_cursor_id_num, lv_statement_txt,DBMS_SQL.NATIVE);
   DBMS_SQL.DEFINE_COLUMN(lv_cursor_id_num, 1,lv_ord_rec.customer_id);
   DBMS_SQL.DEFINE_COLUMN(lv_cursor_id_num, 2,lv_ord_rec.total);
   lv_rowcount_num := DBMS_SQL.EXECUTE(lv_cursor_id_num);
   LOOP
      EXIT WHEN DBMS_SQL.FETCH_ROWS(lv_cursor_id_num) = 0;
      DBMS_SQL.COLUMN_VALUE(lv_cursor_id_num, 1, 
         lv_ord_rec.customer_id);
      DBMS_SQL.COLUMN_VALUE(lv_cursor_id_num, 2, lv_ord_rec.total);
      -- Provide output, tab delimited, in specified order
      DBMS_OUTPUT.PUT_LINE(lv_ord_rec.customer_id || CHR(9) ||
         TO_CHAR(lv_ord_rec.total, '$999,999,999.99'));
   END LOOP;
   -- Close cursor when processing complete
   DBMS_SQL.CLOSE_CURSOR(lv_cursor_id_num);
EXCEPTION
   WHEN OTHERS THEN
      IF DBMS_SQL.IS_OPEN(lv_cursor_id_num) THEN
         DBMS_SQL.CLOSE_CURSOR(lv_cursor_id_num);
      END IF;
      RAISE_APPLICATION_ERROR(-20101, 'Error processing SQL ' ||
         'statement in SHOW_ORDERS procedure', FALSE);
END show_orders;
/

SPOOL OFF
