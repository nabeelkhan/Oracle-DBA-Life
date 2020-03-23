-- ***************************************************************************
-- File: 2_42.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 2_42.lis

SELECT SUM(DECODE(credit_rating, 'EXCELLENT', 1, 0)) EXCELLENT,
       SUM(DECODE(credit_rating, 'GOOD', 1, 0)) GOOD,
       SUM(DECODE(credit_rating, 'POOR', 1, 0)) POOR
FROM   s_customer;

SPOOL OFF
