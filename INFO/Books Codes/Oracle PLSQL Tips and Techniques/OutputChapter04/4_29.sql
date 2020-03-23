-- ***************************************************************************
-- File: 4_29.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_29.lis

CREATE OR REPLACE PROCEDURE reset_ship_dates 
   (date_shipped IN DATE) IS
BEGIN
   UPDATE s_order
   SET    date_shipped = NULL
   WHERE  date_shipped = date_shipped;
   COMMIT;
END reset_ship_dates;
/

SPOOL OFF
