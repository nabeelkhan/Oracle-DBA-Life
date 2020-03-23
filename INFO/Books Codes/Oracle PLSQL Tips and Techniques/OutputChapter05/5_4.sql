-- ***************************************************************************
-- File: 5_4.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_4.lis

BEGIN
   global_def.increment_value(5);
   global_def.increment_value(3);
   global_def.increment_value(1);
END;
/

SPOOL OFF
