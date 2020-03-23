-- ***************************************************************************
-- File: 5_32.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_32.lis

CREATE OR REPLACE PACKAGE order_insert IS
   -- Define a PL/SQL table type to store the order_id info
   TYPE pv_order_tab IS TABLE OF s_order.order_id%TYPE
      INDEX BY BINARY_INTEGER;
   -- Declare variables for the PL/SQL table and counter
   pv_order_tab_rec pv_order_tab;
   pv_tab_index_num PLS_INTEGER := 0;
END order_insert;
/

SPOOL OFF
