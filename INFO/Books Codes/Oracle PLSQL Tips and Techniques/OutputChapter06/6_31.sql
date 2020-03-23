-- ***************************************************************************
-- File: 6_31.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_31.lis

BEGIN
   DBMS_OUTPUT.PUT_LINE(ROUND(3.5));
   DBMS_OUTPUT.PUT_LINE(ROUND(105.09,1));
   DBMS_OUTPUT.PUT_LINE(ROUND(-3.5));
   DBMS_OUTPUT.PUT_LINE(ROUND(105.15,-2));
   DBMS_OUTPUT.PUT_LINE(ROUND(150.15,-2));
END;
/

SPOOL OFF
