-- ***************************************************************************
-- File: 4_16.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_16.lis

DECLARE  -- Implicit Cursor: Too many rows
   lv_emp_rec s_employee%ROWTYPE;
BEGIN
   SELECT * INTO lv_emp_rec
   FROM   s_employee;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No Employee Record Found.');
   WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.PUT_LINE('More Than One Employee Record Found.');
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Unknown Error.');
END;
/

SPOOL OFF
