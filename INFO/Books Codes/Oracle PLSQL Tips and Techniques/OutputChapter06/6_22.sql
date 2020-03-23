-- ***************************************************************************
-- File: 6_22.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_22.lis

BEGIN
  IF '&input_txt' BETWEEN 'A' AND 'D' THEN
      DBMS_OUTPUT.PUT_LINE('TRUE');
    ELSE
       DBMS_OUTPUT.PUT_LINE('FALSE');
    END IF;
END;
/

SPOOL OFF
