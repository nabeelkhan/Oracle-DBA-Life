-- ***************************************************************************
-- File: 5_6.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_6.lis

<<main_loop>>
DECLARE
   lv_var_num_1 PLS_INTEGER := 5;
BEGIN
   -- Refers to the main_loop variable
   DBMS_OUTPUT.PUT_LINE('Step 1: ' || lv_var_num_1);
   <<inner_loop>>
   DECLARE
      -- Overrides the main_loop variable
      lv_var_num_1 PLS_INTEGER := 3; 
      lv_var_num_2 PLS_INTEGER := 9;
   BEGIN
      -- Refers to the inner_loop variable
      DBMS_OUTPUT.PUT_LINE('Step 2: ' || lv_var_num_1);
      -- Refers to the main_loop variable
      DBMS_OUTPUT.PUT_LINE('Step 3: ' || main_loop.lv_var_num_1);
      DBMS_OUTPUT.PUT_LINE('Step 4: ' || lv_var_num_2);
      -- Changes the value of the inner_loop variable
      lv_var_num_1 := 6;
      DBMS_OUTPUT.PUT_LINE('Step 5: ' || lv_var_num_1);
   END;
   -- Refers to the main_loop variable that does not know about the 
   -- value change that took place in the inner_loop
   DBMS_OUTPUT.PUT_LINE('Step 7: ' || lv_var_num_1);
END;
/

SPOOL OFF
