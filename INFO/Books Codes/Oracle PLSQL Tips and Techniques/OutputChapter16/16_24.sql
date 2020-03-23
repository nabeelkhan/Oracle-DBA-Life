-- ***************************************************************************
-- File: 16_24.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_24.lis

DECLARE
      lv_clob_pointer_txt CLOB;
BEGIN
      INSERT INTO test_clob 
   (clob_id, clob_object)
      VALUES 
   (1, '1234567890')
      RETURNING clob_object INTO lv_clob_pointer_txt;
END;
/

SPOOL OFF
