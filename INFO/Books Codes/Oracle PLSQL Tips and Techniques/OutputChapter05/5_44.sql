-- ***************************************************************************
-- File: 5_44.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_44.lis

-- log_error (procedure) - Records a error in the error logging table.
CREATE OR REPLACE PROCEDURE log_error  
   (p_package_txt   VARCHAR2 DEFAULT 'UNKNOWN',
   p_procedure_txt VARCHAR2 DEFAULT 'UNKNOWN',
   p_location_txt  VARCHAR2 DEFAULT 'UNKNOWN',
   p_error_txt     VARCHAR2 DEFAULT 'UNKNOWN',
   p_text_txt      VARCHAR2 DEFAULT 'NONE',
   p_commit_bln    BOOLEAN  DEFAULT TRUE,
   p_user_txt      VARCHAR2 DEFAULT USER,
   p_time_date     DATE     DEFAULT SYSDATE) IS
   -- p_package_txt - The name of the package in which the error
   --    occurred. Should be the literal FORM for errors submitted 
   --    from the Forms error handler.
   -- p_procedure_txt - The name of the procedure/function in which
   --    the error occurred. Should be the name of the form for 
   --    errors submitted from the Forms error handler.
   -- p_location_txt - The reference to a physical location within the
   --    procedure/function in which the error occurred.
   -- p_error_txt - The Oracle error message.
   -- p_text_txt - Any additional information provided by the
   --    developer to aid in identify the problem. For example,
   --    this might be a rowid or account number.
   -- p_commit_bln - Boolean flag to determine if this procedure
   --    should perform a commit after writing to the error table.
   -- p_user_txt - The oracle user account that generated the
   --    error. If left NULL, the current user will be assumed.
   -- p_time_date - The date and time when the error occurred.
   --    If left NULL, the current date and time will be used.
   lv_call_stack_txt VARCHAR2(2000);
   lv_error_stack_txt VARCHAR2(2000);
   pu_failure_excep EXCEPTION;
   PRAGMA EXCEPTION_INIT (pu_failure_excep, -20000);
BEGIN
   lv_call_stack_txt := SUBSTR(DBMS_UTILITY.FORMAT_CALL_STACK, 
      1, 2000);
   lv_error_stack_txt := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK, 
      1, 2000);
   INSERT INTO system_errors 
      (system_error_id, package_name, procedure_name, 
       execution_location, oracle_error_text, additional_information,
       call_stack, error_stack, insert_time, insert_user)
   VALUES 
      (system_error_id.NEXTVAL, SUBSTR(p_package_txt, 1, 50),
       SUBSTR(p_procedure_txt, 1, 50), 
       SUBSTR(p_location_txt, 1, 20), SUBSTR(p_error_txt, 1, 200),
       SUBSTR(p_text_txt, 1, 2000), lv_call_stack_txt, 
       lv_error_stack_txt, p_time_date, p_user_txt);
   IF p_commit_bln THEN
      COMMIT;
    END IF;
EXCEPTION
   WHEN OTHERS THEN
      RAISE pu_failure_excep;
END log_error;
/

SPOOL OFF
