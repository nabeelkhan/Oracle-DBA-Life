-- ***************************************************************************
-- File: 13_5.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 13_5.lis

SELECT     segment_name, log_date, segment_type, 
           count_extents, bytes_extents
FROM       extents_log
ORDER BY   segment_name, log_date;

SPOOL OFF
