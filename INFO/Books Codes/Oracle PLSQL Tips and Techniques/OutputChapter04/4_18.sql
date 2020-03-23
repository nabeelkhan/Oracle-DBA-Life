-- ***************************************************************************
-- File: 4_18.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_18.lis

DECLARE  --Explicit Cursor: Too many rows
   CURSOR cur_employee IS
      SELECT *
      FROM   s_employee;
   lv_emp_rec s_employee%ROWTYPE;
BEGIN
   OPEN cur_employee;
   FETCH cur_employee INTO lv_emp_rec;
   IF cur_employee%NOTFOUND THEN
      DBMS_OUTPUT.PUT_LINE('No Employee Record Found.');
   END IF;
   CLOSE cur_employee;
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Unknown Error.');
      IF cur_employee%ISOPEN THEN
         CLOSE cur_employee;
      END IF;
END;
/

SPOOL OFF
