-- ***************************************************************************
-- File: 12_52.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_52.lis

CREATE OR REPLACE PROCEDURE process_products 
   (p_directory_txt VARCHAR2 := 'c:\apps\loaders',
    p_filename_txt  VARCHAR2 := 'prodlist.dat',
    p_string_txt VARCHAR2) IS
   -- DESCRIPTION: This package processes a product data file by 
   -- loading all product records into the s_product table. The
   -- file loaded is scanned while loaded to log each line that
   -- a specified string was found on. The statistics of the load
   -- are also logged.
   lv_file_id_num         UTL_FILE.FILE_TYPE; 
   lv_file_id_num_2       UTL_FILE.FILE_TYPE; 
   lv_output_filename_txt VARCHAR2(30);
   lv_filename_txt        VARCHAR2(30);
   lv_error_desc_txt      VARCHAR2(50);
   lv_line_cnt_num        PLS_INTEGER := 0;
   lv_error_cnt_num       PLS_INTEGER := 0;
   lv_buffer_txt          VARCHAR2(2000);
   lv_found_bln           BOOLEAN := FALSE;

   -- This procedure reduces the code redundancy in the exception
   -- handling process and is called by each exception condition.
   PROCEDURE error_processing (p_file_num UTL_FILE.FILE_TYPE,
      p_line_num PLS_INTEGER, p_error_txt VARCHAR2) IS
   BEGIN
      ROLLBACK;
      UTL_FILE.PUT_LINE(p_file_num, 'Line: ' || 
         p_line_num || '  Error: ' || p_error_txt);
      UTL_FILE.PUT_LINE(p_file_num, '----------------------------');
      UTL_FILE.PUT_LINE(p_file_num, 'File Process ABORTED');
      UTL_FILE.FCLOSE_ALL;
   END error_processing;
BEGIN
   -- Opens the input data file on the server for reading.
   lv_file_id_num := UTL_FILE.FOPEN(p_directory_txt, 
      p_filename_txt, 'R');
   -- Creates the log file name by stripping the file
   -- extension and adding .log on the end.
   lv_output_filename_txt := SUBSTR(p_filename_txt, 1, 
      INSTR(p_filename_txt, '.') - 1) || '.log';
   -- Opens the log file on the server for writing.
   lv_file_id_num_2 := UTL_FILE.FOPEN(p_directory_txt, 
      lv_output_filename_txt, 'W');
   UTL_FILE.PUT_LINE(lv_file_id_num_2,
      'Processing Products Log File');
   UTL_FILE.PUT_LINE(lv_file_id_num_2,
      '----------------------------');
   UTL_FILE.PUT_LINE(lv_file_id_num_2, 'Directory:     ' ||
      p_directory_txt);
   UTL_FILE.PUT_LINE(lv_file_id_num_2, 'Input File:    ' ||
      p_filename_txt);
   UTL_FILE.PUT_LINE(lv_file_id_num_2, 'Output File:   ' ||
      lv_output_filename_txt);
   UTL_FILE.PUT_LINE(lv_file_id_num_2, 'Search String: ' ||
      p_string_txt);
   UTL_FILE.PUT_LINE(lv_file_id_num_2,
      '----------------------------');
   LOOP
      lv_buffer_txt   := NULL;
      -- When end of file reached, the loop is terminated.
      BEGIN <<read_file>>
         UTL_FILE.GET_LINE(lv_file_id_num, lv_buffer_txt);
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            EXIT;
      END read_file;
      lv_line_cnt_num := lv_line_cnt_num + 1;
      -- If an error encountered on the insert, then the line
      -- and error are logged to the log file and processing
      -- continues.
      BEGIN <<insert_product>>
         -- When processing fixed length data files, if the spaces
         -- are not trimmed off the left and right side, the spaces
         -- will be part of the value inserted.
         INSERT INTO s_product
            (product_id, product_name, short_desc)
         VALUES
            (RTRIM(LTRIM(SUBSTR(lv_buffer_txt, 1, 7), ' '), ' '),
             RTRIM(LTRIM(SUBSTR(lv_buffer_txt, 8, 50), ' '), ' '),
             RTRIM(LTRIM(SUBSTR(lv_buffer_txt, 58), ' '), ' '));
      EXCEPTION
         WHEN OTHERS THEN
            UTL_FILE.PUT_LINE(lv_file_id_num_2,
               'Line: ' || lv_line_cnt_num || '  Error: ' ||
               SUBSTR(SQLERRM,1,200));
            lv_error_cnt_num := lv_error_cnt_num + 1;
      END insert_product;
      -- The line number is written to the log file every time
      -- the search string is found.
      IF INSTR(UPPER(lv_buffer_txt), UPPER(p_string_txt)) > 0 THEN
         UTL_FILE.PUT_LINE(lv_file_id_num_2, 
            'String Found on Line: ' || lv_line_cnt_num);
         lv_found_bln := TRUE;
      END IF;
   END LOOP;
   COMMIT;   -- If the search string is not found in the file, a message is
   -- written to the log file to indicate this condition.
   IF NOT lv_found_bln THEN
      UTL_FILE.PUT_LINE(lv_file_id_num_2,
         'The string was not found in the file.');
   END IF;
   -- Final processing statistics are written to the log file.
   UTL_FILE.PUT_LINE(lv_file_id_num_2,
      '----------------------------');
   UTL_FILE.PUT_LINE(lv_file_id_num_2,
      'Number of Total Products Processed: ' ||
      TO_CHAR(lv_line_cnt_num, '999,999'));
   UTL_FILE.PUT_LINE(lv_file_id_num_2,
      'Number of Products Inserted:        ' ||
     TO_CHAR(lv_line_cnt_num - lv_error_cnt_num, '999,999'));
   UTL_FILE.PUT_LINE(lv_file_id_num_2,
      'Number of Products with Error:      ' ||
      TO_CHAR(lv_error_cnt_num, '999,999'));
   UTL_FILE.PUT_LINE(lv_file_id_num_2,
      '----------------------------');
   UTL_FILE.PUT_LINE(lv_file_id_num_2,
      'File Processed Successfully');
   UTL_FILE.FCLOSE_ALL;
EXCEPTION
   -- If any of the UTL_FILE exceptions are raised or any errors
   -- encountered, the entire process is rolled back, and the line
   -- number and error number are written to the log file.
   WHEN UTL_FILE.internal_error THEN
      error_processing(lv_file_id_num_2, lv_line_cnt_num,
         'UTL_FILE.INTERNAL_ERROR encountered');
   WHEN UTL_FILE.invalid_filehandle THEN
      error_processing(lv_file_id_num_2, lv_line_cnt_num,
         'UTL_FILE.INVALID_FILEHANDLE encountered');
   WHEN UTL_FILE.invalid_mode THEN
      error_processing(lv_file_id_num_2, lv_line_cnt_num,
         'UTL_FILE.INVALID_MODE encountered');
   WHEN UTL_FILE.invalid_operation THEN
      error_processing(lv_file_id_num_2, lv_line_cnt_num,
         'UTL_FILE.INVALID_OPERATION encountered');
   WHEN UTL_FILE.invalid_path THEN
      error_processing(lv_file_id_num_2, lv_line_cnt_num,
         'UTL_FILE.INVALID_PATH encountered');
   WHEN UTL_FILE.read_error THEN
      error_processing(lv_file_id_num_2, lv_line_cnt_num,
         'UTL_FILE.READ_ERROR encountered');
   WHEN UTL_FILE.write_error THEN
      error_processing(lv_file_id_num_2, lv_line_cnt_num,
         'UTL_FILE.WRITE_ERROR encountered');
   WHEN OTHERS THEN
      error_processing(lv_file_id_num_2, lv_line_cnt_num,
         SUBSTR(SQLERRM,1,200));
END process_products; 
/

SPOOL OFF
