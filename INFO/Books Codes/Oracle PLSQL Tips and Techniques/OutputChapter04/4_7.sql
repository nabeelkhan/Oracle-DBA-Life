-- ***************************************************************************
-- File: 4_7.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_7.lis

SET SERVEROUTPUT ON SIZE 1000000
DECLARE
   lv_test_num     NUMBER(3);
   lv_test_txt     VARCHAR2(5);
   lv_complete_bln BOOLEAN;
BEGIN
   IF lv_test_num != 10 THEN                    -- lv_test_num is NULL
      DBMS_OUTPUT.PUT_LINE('Number Test: TRUE');
   ELSE
      DBMS_OUTPUT.PUT_LINE('Number Test: FALSE');
   END IF;
   IF lv_test_txt != 'TEMP' THEN                -- lv_test_txt is NULL
      DBMS_OUTPUT.PUT_LINE('Character Test: TRUE');
   ELSE
      DBMS_OUTPUT.PUT_LINE('Character Test: FALSE');
   END IF;
   IF NOT lv_complete_bln THEN                  -- lv_complete is NULL
      DBMS_OUTPUT.PUT_LINE('Boolean Test: TRUE');
   ELSE
      DBMS_OUTPUT.PUT_LINE('Boolean Test: FALSE');
   END IF;
END;
/

SPOOL OFF
