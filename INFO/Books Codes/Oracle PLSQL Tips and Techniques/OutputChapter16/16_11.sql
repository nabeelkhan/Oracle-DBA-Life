-- ***************************************************************************
-- File: 16_11.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_11.lis

CREATE TABLE session_logon_statistics
(user_logged VARCHAR2(30),
start_time   DATE,
end_time     DATE);

SPOOL OFF
