-- ***************************************************************************
-- File: 16_22.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_22.lis

CREATE PUBLIC SYNONYM display_customers FOR display_customers;
GRANT EXECUTE ON display_customers TO plsql_test;

SPOOL OFF
