-- ***************************************************************************
-- File: 5_35.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_35.lis

CREATE OR REPLACE PROCEDURE string_line (p_string_txt VARCHAR2,
   p_directory_txt VARCHAR2 := 'c:\temp', 
   p_filename_txt VARCHAR2 := 'prodlist.dat') IS 
-- This procedure searches the specified file line by line to 
-- determine if the string is located in the file.
   lv_line_cnt_num PLS_INTEGER := 0;
   lv_buffer_txt   VARCHAR2(2000);
   lv_found_bln    BOOLEAN := FALSE;
   lv_file_id_num  UTL_FILE.file_type;
BEGIN
   -- Open the data load file on the server so it can be read.
   lv_file_id_num := UTL_FILE.fopen(p_directory_txt, 
      p_filename_txt, 'R');
   LOOP
      lv_buffer_txt   := NULL;
      lv_line_cnt_num := lv_line_cnt_num + 1;
      BEGIN << get_next_line >>
         UTL_FILE.get_line(lv_file_id_num, lv_buffer_txt);
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            EXIT;
      END get_next_line;
      IF (INSTR(UPPER(lv_buffer_txt), UPPER(p_string_txt)) > 0) THEN
         DBMS_OUTPUT.PUT_LINE('Line ' || lv_line_cnt_num || 
            ':  ' || lv_buffer_txt);
         lv_found_bln := TRUE;
      END IF;
   END LOOP;
   IF NOT lv_found_bln THEN
      DBMS_OUTPUT.PUT_LINE('The string was not found in the file.');
   END IF;
   UTL_FILE.fclose_all;
EXCEPTION
   WHEN OTHERS THEN
      UTL_FILE.fclose_all;
      RAISE_APPLICATION_ERROR(-20103, 
         'Unhandled exception occurred while reading data file ' || 
         '(string_line).'); 
END string_line;
/

SPOOL OFF
