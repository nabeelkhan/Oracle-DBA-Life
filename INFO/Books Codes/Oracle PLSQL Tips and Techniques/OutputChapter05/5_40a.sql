-- ***************************************************************************
-- File: 5_40a.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_40a.lis

CREATE OR REPLACE PACKAGE BODY order_entry IS
PROCEDURE process_errors 
   (p_txt_1 IN VARCHAR2, p_txt_2 IN VARCHAR2, p_txt_3 IN VARCHAR2,
   p_txt_4 IN VARCHAR2, p_txt_5 IN VARCHAR2,
   p_error_tab OUT order_entry.pv_type_error_tab) IS
BEGIN
   IF p_txt_1 IS NULL THEN
      p_error_tab(p_error_tab.COUNT + 1) := 
         'You must enter your first name.';
   END IF;
   IF p_txt_2 IS NULL THEN
      p_error_tab(p_error_tab.COUNT + 1) := 
         'You must enter your last name.';
   END IF;
   IF p_txt_3 IS NULL THEN
      p_error_tab(p_error_tab.COUNT + 1) := 
         'You must enter your credit card number.';
   END IF;
   IF p_txt_4 IS NULL THEN
      p_error_tab(p_error_tab.COUNT + 1) := 
         'You must enter the expiration date of your credit card.';
   END IF;
   IF p_txt_5 IS NULL THEN
      p_error_tab(p_error_tab.COUNT + 1) := 
         'You must indicate VISA or Mastercard.';
   END IF;
   -- Additional processing logic...
EXCEPTION
   WHEN OTHERS THEN
      p_error_tab(p_error_tab.COUNT + 1) := 
         'Unable to process your order.';
      p_error_tab(p_error_tab.COUNT + 1) :=  
         'Please call our 800 number for assistance';
END process_errors;
END order_entry;
/

SPOOL OFF
