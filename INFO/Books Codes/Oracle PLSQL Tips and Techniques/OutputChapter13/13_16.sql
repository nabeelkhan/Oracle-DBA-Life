-- ***************************************************************************
-- File: 13_16.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 13_16.lis

COLUMN    table_name FORMAT a10
COLUMN    trigger_name FORMAT a25
COLUMN    event FORMAT a10
SELECT    table_name, trigger_name, trigger_type type, 
          triggering_event event, status
FROM      user_triggers
ORDER BY  table_name;

SPOOL OFF
