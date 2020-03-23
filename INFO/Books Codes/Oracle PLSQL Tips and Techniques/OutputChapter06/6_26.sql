-- ***************************************************************************
-- File: 6_26.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_26.lis

DECLARE
   lv_training_code_txt VARCHAR2(10) := 'T_CLASS1';
   lv_non_training_code_txt VARCHAR2(10) := 'TUSC';
   PROCEDURE training_class_check (p_class_check VARCHAR) IS
   BEGIN
      IF p_class_check LIKE 'T_%' THEN
         DBMS_OUTPUT.PUT_LINE(p_class_check ||
            ' is a Training Class');
      ELSE
         DBMS_OUTPUT.PUT_LINE(p_class_check ||
            ' is a Non-Training Class');
      END IF;
   END training_class_check;
BEGIN
   training_class_check(lv_training_code_txt);
   training_class_check(lv_non_training_code_txt);
END;
/

SPOOL OFF
