-- ***************************************************************************
-- File: 5_16.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_16.lis

SELECT name, type, referenced_owner r_owner, referenced_name r_name,
       referenced_type r_type
FROM   user_dependencies
WHERE  name IN ('CALL_TEST_PROC', 'TEST_PACK')
OR     referenced_name IN ('CALL_TEST_PROC', 'TEST_PACK');

SPOOL OFF
