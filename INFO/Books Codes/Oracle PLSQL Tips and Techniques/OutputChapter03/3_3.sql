-- ***************************************************************************
-- File: 3_3.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 3_3.lis

DECLARE
CURSOR cur_employee IS SELECT employee_id, commission_pct FROM
s_employee;
lv_employee_rec cur_employee%ROWTYPE;
CURSOR cur_customer IS SELECT customer_name
FROM s_customer WHERE sales_rep_id = lv_employee_rec.employee_id;
BEGIN
OPEN cur_employee;
LOOP
FETCH cur_employee INTO lv_employee_rec;
EXIT WHEN cur_employee%NOTFOUND;
IF lv_employee_rec.commission_pct > 10 THEN
FOR lv_customer_rec IN cur_customer LOOP
DBMS_OUTPUT.PUT_LINE(lv_customer_rec.customer_name);
END LOOP;
END IF;
END LOOP;
CLOSE cur_employee;
END;

SPOOL OFF
