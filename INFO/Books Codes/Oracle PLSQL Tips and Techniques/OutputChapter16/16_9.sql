-- ***************************************************************************
-- File: 16_9.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_9.lis

CREATE OR REPLACE PROCEDURE insert_product
   (p_product_num VARCHAR2) IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   INSERT INTO s_product
   (product_id, product_name)
   VALUES
   (p_product_num, 'NEW PRODUCT');
   COMMIT;
END;
/

SPOOL OFF
