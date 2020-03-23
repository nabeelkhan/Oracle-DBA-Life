-- ***************************************************************************
-- File: 5_1.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_1.lis

CREATE OR REPLACE PACKAGE global_def IS
   pv_execution_num PLS_INTEGER := 0;
   PROCEDURE increment_value (p_increment_num PLS_INTEGER);
END global_def;
/

SPOOL OFF
