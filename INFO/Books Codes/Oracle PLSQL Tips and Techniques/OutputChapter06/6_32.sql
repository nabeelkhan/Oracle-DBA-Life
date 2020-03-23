-- ***************************************************************************
-- File: 6_32.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_32.lis

BEGIN
   DBMS_OUTPUT.PUT_LINE(TRUNC(3.5));
   DBMS_OUTPUT.PUT_LINE(TRUNC(105.09,1));
   DBMS_OUTPUT.PUT_LINE(TRUNC(-3.5));
   DBMS_OUTPUT.PUT_LINE(TRUNC(105.15,-2));
   DBMS_OUTPUT.PUT_LINE(TRUNC(150.15,-2));
END;
/

SPOOL OFF
