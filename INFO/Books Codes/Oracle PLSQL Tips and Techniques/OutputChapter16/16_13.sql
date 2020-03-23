-- ***************************************************************************
-- File: 16_13.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_13.lis

CREATE OR REPLACE TRIGGER logoff_log_trigger
BEFORE LOGOFF
ON DATABASE
BEGIN
   UPDATE session_logon_statistics
   SET    end_time    = SYSDATE
   WHERE  user_logged = USER
   AND    end_time IS NULL;
END;
/

SPOOL OFF
