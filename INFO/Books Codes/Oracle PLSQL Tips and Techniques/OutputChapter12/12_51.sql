-- ***************************************************************************
-- File: 12_51.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_51.lis

DECLARE
   lv_file_id_num  UTL_FILE.FILE_TYPE;
BEGIN
   lv_file_id_num := UTL_FILE.FOPEN('c:\apps\loaders',
      'test4.dat', 'W');
   UTL_FILE.FCLOSE(lv_file_id_num);
END;
/

SPOOL OFF
