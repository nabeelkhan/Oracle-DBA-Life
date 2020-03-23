-- ***************************************************************************
-- File: 4_9.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_9.lis

SET SERVEROUTPUT ON SIZE 1000000
<<default_test>> -- Naming the PL/SQL block
DECLARE
   lv_first_num      NUMBER(10) DEFAULT 0;    -- Defaulted to 0
   lv_second_num     NUMBER(10) := 10;        -- Defaulted to 10
   lv_third_num      NUMBER(10);              -- Defaulted to NULL
   lv_processed_bln  BOOLEAN DEFAULT FALSE;   -- Defaulted to FALSE
   lv_complete_bln1  BOOLEAN;                 -- Defaulted to NULL
   lv_complete_bln2  BOOLEAN;                 -- Defaulted to NULL
BEGIN
   -- Note the second reference to the lv_second_num variable. The 
   -- result in this example is to print the same variable.
   DBMS_OUTPUT.PUT_LINE('lv_first_num:      ' || 
             TO_CHAR(lv_first_num)  ||
             CHR(10) || 'lv_second_num:     ' || 
             TO_CHAR(lv_second_num) ||
             CHR(10) || 'lv_third_num:      ' || 
             TO_CHAR(lv_third_num)  ||
             CHR(10) || 'lv_processed_bln:  ' || 'FALSE' ||
             CHR(10) || 'lv_complete_bln1:  ' || ''      ||
             CHR(10) || 'lv_complete_bln2:  ' || ''      ||
             CHR(10) ||
             'default_test.lv_second_num: ' ||
             TO_CHAR(default_test.lv_second_num) || CHR(10));
   DBMS_OUTPUT.PUT_LINE('Is lv_second_num > lv_third_num?');
   IF lv_second_num > lv_third_num THEN
      DBMS_OUTPUT.PUT_LINE('lv_second_num > lv_third_num' || CHR(10));
   ELSE
      DBMS_OUTPUT.PUT_LINE('lv_second_num < lv_third_num' || CHR(10));
   END IF;
   DBMS_OUTPUT.PUT_LINE('Is lv_first_num = lv_third_num?');
   IF lv_first_num = lv_third_num THEN
      DBMS_OUTPUT.PUT_LINE('lv_first_num = lv_third_num');
   ELSE
      DBMS_OUTPUT.PUT_LINE('lv_first_num <> lv_third_num');
   END IF;
   DBMS_OUTPUT.PUT_LINE('Is lv_complete_bln1 = TRUE?');
   IF lv_complete_bln1 THEN
      DBMS_OUTPUT.PUT_LINE('lv_complete_bln1 = TRUE');
   ELSE
      DBMS_OUTPUT.PUT_LINE('lv_complete_bln1 <> TRUE');
   END IF;
   DBMS_OUTPUT.PUT_LINE('Is NOT lv_complete_bln1 = TRUE?');
   IF NOT lv_complete_bln1 THEN
      DBMS_OUTPUT.PUT_LINE('NOT lv_complete_bln1 = TRUE');
   ELSE
      DBMS_OUTPUT.PUT_LINE('NOT lv_complete_bln1 <> TRUE');
   END IF;
   DBMS_OUTPUT.PUT_LINE('Is lv_complete_bln1 = lv_complet_bln2?');
   IF lv_complete_bln1 = lv_complete_bln2 THEN
      DBMS_OUTPUT.PUT_LINE('lv_complete_bln1 = lv_complete_bln2');
   ELSE
      DBMS_OUTPUT.PUT_LINE('lv_complete_bln1 <> lv_complete_bln2');
   END IF;
END default_test;
/

SPOOL OFF
