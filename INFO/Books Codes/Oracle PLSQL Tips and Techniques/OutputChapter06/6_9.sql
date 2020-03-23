-- ***************************************************************************
-- File: 6_9.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_9.lis

DECLARE
   CURSOR cur_employee IS
      SELECT employee_last_name || ', ' ||
             employee_first_name name,
             DECODE(commission_pct, NULL, 'NO',
                    0, 'NO', 'YES') comm_flag
      FROM   s_employee
      ORDER BY DECODE(COMMISSION_PCT, NULL, 'NO',
                      0, 'NO', 'YES') DESC;
BEGIN
   FOR lv_cur_employee_rec IN cur_employee LOOP
      DBMS_OUTPUT.PUT_LINE('Employee: ' ||
         lv_cur_employee_rec.name || CHR(9) ||
         'Commission?: ' || lv_cur_employee_rec.comm_flag);
  END LOOP;
END;
/

SPOOL OFF
