-- ***************************************************************************
-- File: 2_9.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 2_9.lis

SELECT a.customer_id, a.customer_name, a.zip_code
FROM   s_customer a, s_customer_temp b
WHERE  a.customer_id = b.customer_id
AND    a.zip_code    = b.zip_code;

SPOOL OFF
