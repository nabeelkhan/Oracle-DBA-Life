-- ***************************************************************************
-- File: 5_40.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_40.lis

CREATE OR REPLACE PACKAGE order_entry IS
   TYPE pv_type_error_tab IS TABLE OF VARCHAR2(500) 
      INDEX BY BINARY_INTEGER;
   PROCEDURE process_errors 
      (p_txt_1 IN VARCHAR2, p_txt_2 IN VARCHAR2, p_txt_3 IN VARCHAR2,
       p_txt_4 IN VARCHAR2, p_txt_5 IN VARCHAR2, 
       p_error_tab OUT order_entry.pv_type_error_tab);
END order_entry;
/

SPOOL OFF
