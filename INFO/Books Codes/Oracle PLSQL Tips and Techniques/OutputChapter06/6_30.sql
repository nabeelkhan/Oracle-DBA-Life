-- ***************************************************************************
-- File: 6_30.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_30.lis

BEGIN
   DBMS_OUTPUT.PUT_LINE('Orignal Number: ' ||
      &&test_var || CHR(9) || ' Ceil Number: ' ||
      CEIL(&&test_var) || CHR(9) || ' Floor Number: '||
      FLOOR(&&test_var));
END;
/

SPOOL OFF
