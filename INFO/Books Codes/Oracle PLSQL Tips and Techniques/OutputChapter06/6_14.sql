-- ***************************************************************************
-- File: 6_14.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_14.lis

CREATE OR REPLACE FUNCTION validate_date_format 
   (p_input_date VARCHAR2) RETURN BOOLEAN IS
   lv_result_date DATE;
BEGIN
   lv_result_date := TO_DATE(p_input_date, 'MM/DD/YYYY');
   IF LENGTH(SUBSTR(input_date,
      INSTR(input_date, '/', 1, 2) + 1)) = 4 THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      RETURN FALSE;
END validate_date_format;
/

SPOOL OFF
