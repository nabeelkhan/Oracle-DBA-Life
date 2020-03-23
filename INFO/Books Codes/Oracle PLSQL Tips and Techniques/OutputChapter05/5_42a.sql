-- ***************************************************************************
-- File: 5_42a.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_42a.lis

CREATE OR REPLACE PACKAGE BODY process_orders IS
   lv_package_txt VARCHAR2(30) := 'PROCESS_ORDERS';
   lv_order_processed_num PLS_INTEGER;
PROCEDURE fill_and_send IS
   lv_procedure_txt VARCHAR2(30) := 'FILL_AND_SEND';
BEGIN
   -- Processing logic...
   NULL;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      -- Order data for this order could not be found.
      log_error(lv_package_txt, lv_procedure_txt);
      RAISE NO_DATA_FOUND;
   WHEN OTHERS THEN
      -- An unanticipated error has occurred.
      log_error(lv_package_txt, lv_procedure_txt);
      RAISE NO_DATA_FOUND;
END fill_and_send;
PROCEDURE fill_orders IS
   CURSOR cur_orders IS
      SELECT *
      FROM   s_order
      WHERE order_filled = 'N';
   lv_procedure_txt VARCHAR2(30) := 'FILL_ORDERS';
BEGIN
   FOR cur_orders_rec IN cur_orders LOOP
      BEGIN
         lv_order_processed_num := cur_orders_rec.order_id;
         -- Retrieve inventory for product type...
         -- Retrieve dependency data for current order...
         -- Processing logic...
         COMMIT;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            log_error(lv_package_txt, lv_procedure_txt);
         WHEN OTHERS THEN
            -- An unanticipated error has occurred.
            -- Log the error then abort run...
            log_error(lv_package_txt, lv_procedure_txt);
            RAISE NO_DATA_FOUND;
      END;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      -- Handle condition...
      log_error(lv_package_txt, lv_procedure_txt);
END fill_orders;
END process_orders;
/

SPOOL OFF
