-- ***************************************************************************
-- File: 8_11.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_11.lis

SELECT program_name,
       TO_CHAR(execution_date,'MM/DD/YYYY HH24:MI:SS') execution_time,
       records_processed, elapsed_time_sec
FROM   process_timing_log
ORDER BY 1,2;

SPOOL OFF
