-- ***************************************************************************
-- File: 14_13.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 14_13.lis

PROCEDURE log_error 
   (p_message_txt         IN VARCHAR2, -- The programmer's message
    p_error_code_num      IN NUMBER,   -- Forms Error_Code value
    p_error_text_txt      IN VARCHAR2, -- Forms Error_Text value
    p_error_type_txt      IN VARCHAR2, -- Forms Error_Type value
    p_dbms_error_code_num IN NUMBER,   -- Forms DBMS_Error_Code value
    p_dbms_error_text_txt IN VARCHAR2) -- Forms DBMS_Error_Text value
   IS
   lv_button_pressed_num NUMBER;
   lv_done_excep         EXCEPTION;
   lv_error_file_txt     VARCHAR2(100);
   lv_file_handle_num    TEXT_IO.FILE_TYPE; -- File handle used to 
                                            -- write to the error log.
   lv_log_error_bln1     BOOLEAN; -- Used to track runtime errors that
                                  -- occur in this procedure.
   lv_log_error_bln2     BOOLEAN; -- Used to track runtime errors that
                                  -- occur in this procedure.
   lv_open_attempts_num  PLS_INTEGER := 0;
   lv_dir_txt            VARCHAR2(50);
BEGIN
   -- The following 4 lines can be uncommented if it is desired to
   -- ensure that a database connection has been established
   -- in order for this procedure to execute.
--   IF GET_APPLICATION_PROPERTY(DATASOURCE) <> 'ORACLE' THEN
--      MESSAGE('Not Connected to Database.', NO_ACKNOWLEDGE);
--      RAISE lv_done_excep;
--   END IF;
   -- Initialize variables.
   DEFAULT_VALUE('c:', 'global.error_log_dir');
   lv_dir_txt := NAME_IN('global.error_log_dir');
   lv_log_error_bln1 := FALSE;
   lv_log_error_bln2 := FALSE;
   -- Display the informational message.
   BEGIN
      MESSAGE('Recording application error...', NO_ACKNOWLEDGE);
      SYNCHRONIZE;
   EXCEPTION
      WHEN OTHERS THEN
         lv_log_error_bln2 := TRUE;
   END;
   -- Create the name of the error log file and then open it.
   WHILE lv_open_attempts_num < 100 LOOP
      IF lv_open_attempts_num <= 80 THEN
         lv_error_file_txt := lv_dir_txt || '\' || 
            TO_CHAR(SYSDATE, 'dddsssss')||'.rel';
      ELSE
         lv_error_file_txt := 'runform.rel';
      END IF;
      BEGIN
         lv_file_handle_num := TEXT_IO.FOPEN(lv_error_file_txt, 'A');
         EXIT;
      EXCEPTION
         WHEN OTHERS THEN
            lv_open_attempts_num := lv_open_attempts_num + 1;
            IF lv_open_attempts_num = 80 THEN
               -- Display an error indicating that the error file
               -- could not be opened,and a generic file will be used.
               NULL;
            END IF;
      END;
   END LOOP;
   IF lv_open_attempts_num >= 100 THEN
      -- Display an error indicating that the error file 
      -- could not be opened.
      RAISE FORM_TRIGGER_FAILURE;
   END IF;
   -- Record the name of the log file.
   COPY(lv_error_file_txt, 'global.last_rel_file');
   -- If any errors occurred in this program unit while attempting
   -- to log another error then write them to the file.
   IF lv_log_error_bln1 THEN
      -- text_io statements...
      NULL;
   END IF;
   IF lv_log_error_bln2 THEN
      -- text_io statements...
      NULL;
   END IF;
   -- Write error information to the file.
   TEXT_IO.PUT_LINE(lv_file_handle_num, USER);
   TEXT_IO.PUT_LINE(lv_file_handle_num, 
      TO_CHAR(SYSDATE, 'Mon DD, YYYY  HH24:MI:SS'));
   TEXT_IO.PUT_LINE(lv_file_handle_num, ' ');
   TEXT_IO.PUT_LINE(lv_file_handle_num, 
      'Error Code: '||TO_CHAR(p_error_code_num));
   TEXT_IO.PUT_LINE(lv_file_handle_num, 
      'Error Text: '||p_error_text_txt);
   TEXT_IO.PUT_LINE(lv_file_handle_num, 
      'Error Type: '||p_error_type_txt);
   TEXT_IO.PUT_LINE(lv_file_handle_num, 
      'DBMS Error Code: '||TO_CHAR(p_DBMS_error_code_num));
   TEXT_IO.PUT_LINE(lv_file_handle_num, 
      'DBMS Error Text: '||p_dbms_error_text_txt);
   TEXT_IO.PUT_LINE(lv_file_handle_num, ' ');
   TEXT_IO.PUT_LINE(lv_file_handle_num, p_message_txt);
   TEXT_IO.PUT_LINE(lv_file_handle_num, ' ');
   -- Use text_io to write the name and value of all system_variables.
   TEXT_IO.PUT_LINE(lv_file_handle_num, 
      'End of standard error report.');
   TEXT_IO.PUT_LINE(lv_file_handle_num, ' ');
   -- Close the error log file.
   TEXT_IO.FCLOSE(lv_file_handle_num);
   -- Display the informational message.
   BEGIN
      MESSAGE('Application error has been recorded.', NO_ACKNOWLEDGE);
      SYNCHRONIZE;
   EXCEPTION
      WHEN OTHERS THEN
          NULL;
   END;
EXCEPTION
   WHEN lv_done_excep THEN
      NULL;
   WHEN FORM_TRIGGER_FAILURE THEN
      RAISE FORM_TRIGGER_FAILURE;
   WHEN OTHERS THEN
      MESSAGE('An error has occurred during the error logging ' ||
         'procedure.', NO_ACKNOWLEDGE);
      RAISE FORM_TRIGGER_FAILURE;
END;

SPOOL OFF
