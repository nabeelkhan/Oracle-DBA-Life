-- ***************************************************************************
-- File: 4_15.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_15.lis

CREATE OR REPLACE PROCEDURE LOAD_DATA IS
-- Declarations
BEGIN
   DBMS_OUTPUT.PUT_LINE('Load Data Processing Starting...');
   -- Processing Logic...
   DBMS_OUTPUT.PUT_LINE('Load Data Processing Complete.');
END;
/

SPOOL OFF
