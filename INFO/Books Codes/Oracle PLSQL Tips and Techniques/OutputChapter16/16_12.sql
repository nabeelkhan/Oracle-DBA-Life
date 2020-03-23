-- ***************************************************************************
-- File: 16_12.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_12.lis

CREATE OR REPLACE TRIGGER logon_log_trigger
AFTER LOGON
ON DATABASE
BEGIN
   INSERT INTO session_logon_statistics
   (user_logged, start_time)
   VALUES
   (USER, SYSDATE);
END; 
/

SPOOL OFF
