-- ***************************************************************************
-- File: 5_42.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_42.lis

CREATE OR REPLACE PACKAGE process_orders IS
PROCEDURE fill_and_send;
PROCEDURE fill_orders;
END process_orders;
/

SPOOL OFF
