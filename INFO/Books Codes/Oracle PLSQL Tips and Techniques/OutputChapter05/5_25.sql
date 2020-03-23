-- ***************************************************************************
-- File: 5_25.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_25.lis

CREATE OR REPLACE TRIGGER bi_order
BEFORE INSERT
ON s_order
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
WHEN (NEW.payment_type = 'CREDIT')
DECLARE
   CURSOR cur_check_customer IS
      SELECT 'x'
      FROM   s_customer
      WHERE  customer_id = :NEW.customer_id
      AND    credit_rating = 'POOR';
   lv_temp_txt VARCHAR2(1);
BEGIN
   OPEN cur_check_customer;
   FETCH cur_check_customer INTO lv_temp_txt;
   IF (cur_check_customer%FOUND) THEN
      CLOSE cur_check_customer;
      RAISE_APPLICATION_ERROR(-20111, 'Cannot process CREDIT ' ||
         'order for a customer with a POOR credit rating.');
   ELSE
      CLOSE cur_check_customer;
   END IF;
END bi_order;
/

SPOOL OFF
