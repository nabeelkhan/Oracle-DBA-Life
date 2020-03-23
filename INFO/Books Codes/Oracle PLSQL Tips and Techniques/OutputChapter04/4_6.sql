-- ***************************************************************************
-- File: 4_6.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_6.lis

SET SERVEROUTPUT ON SIZE 1000000
DECLARE
   -- Examples of %ROWTYPE Usage
   -- PL/SQL Record mirroring S_ORDER table
   lv_ord_rec s_order%ROWTYPE; 
   CURSOR cur_get_order IS
      SELECT order_id, customer_id, total
      FROM   s_order;
   lv_ord_cur_rec cur_get_order%ROWTYPE; -- Mirroring GET_ORDER cursor
BEGIN
   -- Customer Processing...
   lv_ord_rec.total := 10;
   DBMS_OUTPUT.PUT_LINE('Total: '|| lv_ord_rec.total);
   lv_ord_cur_rec.total := 20;
   DBMS_OUTPUT.PUT_LINE('Total: '|| lv_ord_cur_rec.total);
END;
/

SPOOL OFF
