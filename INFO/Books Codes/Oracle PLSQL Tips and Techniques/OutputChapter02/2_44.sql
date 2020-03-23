-- ***************************************************************************
-- File: 2_44.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 2_44.lis

SELECT customer_id, customer_name,
       TRANSLATE(phone, '1234567890','XXXXXXXXXX') phone
FROM  s_customer
WHERE TRANSLATE(phone, '1234567890','XXXXXXXXXX') = 
      'X-XXX-XXX-XXXX';

SPOOL OFF
