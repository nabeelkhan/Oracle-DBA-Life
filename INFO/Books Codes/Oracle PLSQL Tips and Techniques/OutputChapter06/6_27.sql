-- ***************************************************************************
-- File: 6_27.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_27.lis

DECLARE
   lv_training_code_txt VARCHAR2(10) := 'T_CLASS1';
   lv_non_training_code_txt VARCHAR2(10) := 'TUSC';
   PROCEDURE training_class_check (p_class_check VARCHAR) IS
      p_class_check1 VARCHAR2(10) := p_class_check;    -- NL
   BEGIN
      IF SUBSTR(p_class_check1,1,2) = 'T_' THEN        -- NL
         p_class_check1 := 'T-' || SUBSTR(p_class_check1, 3); -- NL
      END IF;                                          -- NL
      IF p_class_check1 LIKE 'T-%' THEN                -- CL
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
