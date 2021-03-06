-- ***************************************************************************
-- File: 5_19.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_19.lis

SELECT 'ALTER ' || object_type || ' ' ||
       object_name || ' COMPILE;'
FROM   user_objects
WHERE  OBJECT_NAME IN ('AA', 'BB', 'CC', 'DD', 'EE')
ORDER BY object_type, object_name;

SPOOL OFF
