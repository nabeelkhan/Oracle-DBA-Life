-- ***************************************************************************
-- File: 5_23.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_23.lis

SELECT customer_name || CHR(10) || 
       address || CHR(10) ||
       customer_csz(customer_id) full_address
FROM   s_customer;

SPOOL OFF
