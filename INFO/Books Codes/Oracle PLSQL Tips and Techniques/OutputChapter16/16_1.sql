-- ***************************************************************************
-- File: 16_1.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_1.lis

DECLARE
   lv_sql_txt VARCHAR2(200);
BEGIN
   EXECUTE IMMEDIATE 'ALTER SESSION SET SQL_TRACE=TRUE';
   lv_sql_txt := 'ALTER SESSION SET SORT_AREA_SIZE = 1000000';
   EXECUTE IMMEDIATE lv_sql_txt;
END;
/

SPOOL OFF
