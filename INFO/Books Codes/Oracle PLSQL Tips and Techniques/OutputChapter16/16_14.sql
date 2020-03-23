-- ***************************************************************************
-- File: 16_14.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_14.lis

SELECT user_logged, 
       TO_CHAR(start_time, 'MM/DD/YYYY HH24:MI:SS') "START TIME",
       TO_CHAR(end_time, 'MM/DD/YYYY HH24:MI:SS') "END TIME"
FROM   session_logon_statistics
order by user_logged, start_time;

SPOOL OFF
