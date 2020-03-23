-- ***************************************************************************
-- File: 16_27.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_27.lis

DECLARE
   TYPE lv_name_array IS VARRAY(5) OF VARCHAR2(10);
   lv_name_array_rec lv_name_array := lv_name_array('dave', 'pat',
      'bob');
BEGIN
   -- COUNT is currently at three
   FOR lv_loop_num in 1..lv_name_array_rec.COUNT LOOP
      DBMS_OUTPUT.PUT_LINE(lv_name_array_rec(lv_loop_num));
   END LOOP;
   -- Next Command: Pre-allocation necessary for subsequent statements
   lv_name_array_rec.EXTEND; 
   lv_name_array_rec(lv_name_array_rec.COUNT) := 'tony';
   DBMS_OUTPUT.PUT_LINE(lv_name_array_rec(4));
END; 
/

SPOOL OFF
