-- ***************************************************************************
-- File: 9_18.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 9_18.lis

SELECT oc.user_name, s.sql_text
FROM   v$open_cursor oc, v$sqltext s
WHERE  oc.address    = s.address
AND    oc.hash_value = s.hash_value
ORDER BY oc.user_name, s.piece;

SPOOL OFF
