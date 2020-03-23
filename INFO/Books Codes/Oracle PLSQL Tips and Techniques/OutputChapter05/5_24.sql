-- ***************************************************************************
-- File: 5_24.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_24.lis

CREATE OR REPLACE PACKAGE inline_pkg IS
-- First overloaded function version accepts customer_id
FUNCTION customer_csz (p_cust_id_num s_customer.customer_id%TYPE)
   RETURN VARCHAR2;
   PRAGMA RESTRICT_REFERENCES(customer_csz, WNDS, WNPS, RNPS);
-- Second overloaded function version accepts customer_name
FUNCTION customer_csz (p_cust_name_txt s_customer.customer_name%TYPE)
   RETURN VARCHAR2;
   PRAGMA RESTRICT_REFERENCES(customer_csz, WNDS, WNPS, RNPS);
END inline_pkg;
/

SPOOL OFF
