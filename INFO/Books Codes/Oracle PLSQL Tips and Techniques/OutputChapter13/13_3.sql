-- ***************************************************************************
-- File: 13_3.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 13_3.lis

CREATE TABLE extents_log
(log_date            DATE,
segment_name         VARCHAR2(81),
segment_type         VARCHAR2(17),
count_extents        NUMBER,
bytes_extents        NUMBER);

SPOOL OFF
