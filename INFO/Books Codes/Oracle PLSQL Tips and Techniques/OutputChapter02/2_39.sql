-- ***************************************************************************
-- File: 2_39.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 2_39.lis

SELECT customer_id, customer_name,
       DECODE(preferred_customer, 'Y', 'Yes', 'No') preferred
FROM   s_customer
ORDER BY preferred_customer, customer_name;

SPOOL OFF
