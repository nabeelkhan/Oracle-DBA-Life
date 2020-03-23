-- ***************************************************************************
-- File: 5_21.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_21.lis

CREATE OR REPLACE FUNCTION format_money (p_value_num NUMBER)
   RETURN VARCHAR2 IS
   lv_value_txt VARCHAR2(100); 
BEGIN
   -- This function assumes the value is not > $999,999,999.99
   IF (p_value_num >= 1000000) THEN
      lv_value_txt := LTRIM(TO_CHAR(p_value_num, '$999,999,999.00'));
   ELSIF (p_value_num < 1000000) AND (p_value_num >= 1000) THEN
      lv_value_txt := LTRIM( TO_CHAR(p_value_num, '$999,999.00'));
   ELSE
      lv_value_txt := LTRIM(TO_CHAR(p_value_num, '$999.00'));
   END IF;
   RETURN lv_value_txt;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR( -20123, 'Error occurred in MONEY ' ||
         'function for incoming value:' || TO_CHAR(p_value_num) ||
         ' and outgoing value:' || lv_value_txt);
END format_money;
/

SPOOL OFF
