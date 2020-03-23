-- ***************************************************************************
-- File: 4_11.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_11.lis

CREATE OR REPLACE FUNCTION date_range
   (p_low_end_date  DATE,
    p_high_end_date DATE,
    p_to_check_date DATE)
    RETURN BOOLEAN IS
-- This function accepts a low range date, a high range date, and a
-- date to check. Then the function determines if the date to check
-- is between the low range and high range. This function handles 
-- dates with time values other than 00:00:00. 
-- If the date to check is in the range, then a TRUE is returned.
    lv_return_bln BOOLEAN := FALSE;
    lv_low_date   DATE := TRUNC(p_low_end_date); -- Time 00:00:00
    -- The next date value is defaulted to the current date and 
    -- time of 23:59:59
    lv_high_date  DATE := TRUNC(p_high_end_date + 1) - .000011574;
BEGIN
   IF p_to_check_date >  lv_low_date  AND
      p_to_check_date <= lv_high_date THEN
      lv_return_bln := TRUE;
   END IF;
   -- The display statements are used to see the values used
   DBMS_OUTPUT.PUT_LINE('Low Date     : ' ||
      TO_CHAR(lv_low_date, 'MM/DD/YYYY:HH24:MI:SS'));
   DBMS_OUTPUT.PUT_LINE('Date To Check: ' ||
      TO_CHAR(p_to_check_date, 'MM/DD/YYYY:HH24:MI:SS'));
   DBMS_OUTPUT.PUT_LINE('High Date    : ' ||
      TO_CHAR(lv_high_date,    'MM/DD/YYYY:HH24:MI:SS'));
   RETURN lv_return_bln;
END date_range;
/

SPOOL OFF
