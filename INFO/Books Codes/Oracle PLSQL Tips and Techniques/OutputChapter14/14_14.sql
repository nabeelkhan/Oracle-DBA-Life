-- ***************************************************************************
-- File: 14_14.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 14_14.lis

PROCEDURE analyze_error 
   (p_error_code_num      IN NUMBER,   -- Forms Error_Code value
    p_error_text_txt      IN VARCHAR2, -- Forms Error_Text value
    p_error_type_txt      IN VARCHAR2, -- Forms Error_Type value
    p_dbms_error_code_num IN NUMBER,   -- Forms DBMS_Error_Code value
    p_dbms_error_text_txt  IN VARCHAR2) -- Forms DBMS_Error_Text value
IS
   lv_button_pressed_num      PLS_INTEGER;
   lv_control_actions_txt     VARCHAR2(10);
   lv_error_var_name_txt      VARCHAR2(24);
BEGIN
   -- Search the control array for the specific runtime error.
   lv_error_var_name_txt := 'global.TLAECA_'||
      LPAD(TO_CHAR(ABS(p_error_code_num)), 5, '0')||
      LPAD(TO_CHAR(ABS(p_dbms_error_code_num)), 5, '0');
   DEFAULT_VALUE('?', lv_error_var_name_txt);
   lv_control_actions_txt := NAME_IN(lv_error_var_name_txt);
   IF lv_control_actions_txt = '?' THEN
      ERASE(lv_error_var_name_txt);
      lv_error_var_name_txt := 'global.TLAECA_'||
         LPAD(TO_CHAR(ABS(p_error_code_num)), 5, '0')||'00000';
      DEFAULT_VALUE('?', lv_error_var_name_txt);
      lv_control_actions_txt := NAME_IN(lv_error_var_name_txt);
      IF lv_control_actions_txt = '?' THEN
         ERASE(lv_error_var_name_txt);
         lv_control_actions_txt := '1100000000';
      END IF;
   END IF;
   -- Process the error as detailed by the lv_control_ations_txt
   -- variable. Display a message to the user.
   IF SUBSTR(lv_control_actions_txt, 1, 1) = 1 THEN
      MESSAGE('Error Analyzer ' || p_error_text_txt, NO_ACKNOWLEDGE);
   END IF;
   -- Log the error in an external file.
   IF SUBSTR(lv_control_actions_txt, 2, 1) = 1 THEN
      log_error('Runtime error trap.', p_error_code_num,
                 p_error_text_txt, p_error_type_txt,
                 p_dbms_error_code_num, p_dbms_error_text_txt);
   END IF;

-- As a final step, raise a FORM-TRIGGER-FAILURE.
-- The FORM_TRIGGER_FAILURE exception must be raised so that program
-- blocks which are monitoring the FORM_SUCCESS variable will not be
-- fooled into thinking that a packaged procedure succeeded.

   RAISE FORM_TRIGGER_FAILURE;
EXCEPTION
   WHEN FORM_TRIGGER_FAILURE THEN
      RAISE FORM_TRIGGER_FAILURE;
   WHEN OTHERS THEN
      log_error('Unhandled exception tusc_lib.analyze_error.',
         p_error_code_num,
         p_error_text_txt,
         p_error_type_txt,
         p_dbms_error_code_num,
         p_dbms_error_text_txt);
      RAISE FORM_TRIGGER_FAILURE;
END;

SPOOL OFF
