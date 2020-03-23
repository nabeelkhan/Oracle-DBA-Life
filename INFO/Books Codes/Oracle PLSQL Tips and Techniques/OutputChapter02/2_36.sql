-- ***************************************************************************
-- File: 2_36.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 2_36.lis

SELECT TO_DATE('01' || '&&input_date','DDMMYYYY') start_date,
       LAST_DAY(ADD_MONTHS(TO_DATE('01' || 
       '&&input_date','DDMMYYYY'),2)) end_date
FROM   DUAL;

SPOOL OFF
