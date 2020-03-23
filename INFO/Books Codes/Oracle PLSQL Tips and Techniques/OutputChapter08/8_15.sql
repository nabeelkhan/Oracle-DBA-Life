-- ***************************************************************************
-- File: 8_15.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_15.lis

DECLARE
   TYPE type_dept_table IS TABLE OF s_department%ROWTYPE
      INDEX BY BINARY_INTEGER;
   lv_dept_table type_dept_table;
   CURSOR cur_dept IS
      SELECT department_id, department_name
      FROM   s_department;
   CURSOR cur_employee IS
      SELECT employee_id, department_id, salary
      FROM   s_employee_test;
   lv_dept_name_txt s_department.department_name%TYPE;
   lv_index_num     PLS_INTEGER := 0;
   lv_match_bln     BOOLEAN := FALSE;
BEGIN
   stop_watch.start_timer;
   FOR cur_dept_rec IN cur_dept LOOP
      lv_index_num := lv_index_num + 1;
      lv_dept_table(lv_index_num).department_id
         := cur_dept_rec.department_id;
      lv_dept_table(lv_index_num).department_name
         := cur_dept_rec.department_name;
   END LOOP;
   FOR cur_employee_rec IN cur_employee LOOP
      lv_index_num := lv_dept_table.FIRST;
      lv_match_bln := FALSE;
      LOOP
         IF lv_dept_table(lv_index_num).department_id =
            cur_employee_rec.department_id THEN
            lv_match_bln := TRUE;
            lv_dept_name_txt := 
               lv_dept_table(lv_index_num).department_name;
         END IF;
         EXIT WHEN (lv_index_num = lv_dept_table.LAST) OR 
            lv_match_bln;
         lv_index_num := lv_dept_table.NEXT(lv_index_num);
      END LOOP;
      -- Main Logic
   END LOOP;
   stop_watch.stop_timer;
END;
/

SPOOL OFF
