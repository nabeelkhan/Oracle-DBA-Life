-- ***************************************************************************
-- File: 8_9.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_9.lis

CREATE TABLE process_timing_log
   (program_name      VARCHAR2(30),
    execution_date    DATE,
    records_processed NUMBER,
    elapsed_time_sec  NUMBER);

SPOOL OFF
