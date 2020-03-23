-- ***************************************************************************
-- File: 4_14.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_14.lis

-- Assuming execution in SQL*Plus
DECLARE
   lv_product_exists_bln  BOOLEAN := FALSE;
   lv_product_num         s_product.product_id%TYPE;
   CURSOR cur_product IS
      SELECT product_id
      FROM   s_product
      WHERE  product_id = &&p_product;  -- Prompts for product
BEGIN
   OPEN cur_product;
   FETCH cur_product INTO lv_product_num;
   IF cur_product%ROWCOUNT > 0 THEN
      lv_product_exists_bln := TRUE;
   END IF;
   CLOSE cur_product;
   IF lv_product_exists_bln THEN
      -- Product Processing Logic...
      DBMS_OUTPUT.PUT_LINE('Product Id: ' ||TO_CHAR(&&p_product) ||
         ' Exists. ');
   ELSE
      DBMS_OUTPUT.PUT_LINE('Product Id: ' ||TO_CHAR(&&p_product) ||
                           ' Does NOT Exists. ');
   END IF;
END;
/

SPOOL OFF
