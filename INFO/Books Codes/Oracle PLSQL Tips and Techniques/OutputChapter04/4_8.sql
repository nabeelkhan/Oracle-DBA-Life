-- ***************************************************************************
-- File: 4_8.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_8.lis

DECLARE
   lv_three_month_forecast_date DATE         := ADD_MONTHS(SYSDATE,3);
   lv_current_user_txt          VARCHAR2(40) := TO_CHAR(UID) || 
                                                ': ' || USER;
   lv_date_as_number_num        PLS_INTEGER  := TO_NUMBER(TO_CHAR(
                                                SYSDATE, 'YYYYMMDD'));
BEGIN
   DBMS_OUTPUT.PUT_LINE(lv_three_month_forecast_date);
   DBMS_OUTPUT.PUT_LINE(lv_current_user_txt);
   DBMS_OUTPUT.PUT_LINE(lv_date_as_number_num);
END;
/

SPOOL OFF
