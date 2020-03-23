-- ***************************************************************************
-- File: 14_10.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 14_10.lis

CREATE OR REPLACE PROCEDURE validate_title
   (p_title_txt VARCHAR2) IS
   CURSOR cur_title IS
      SELECT 'x'
      FROM   s_title
      WHERE  title = p_title_txt;
   lv_title_txt    VARCHAR2(1);
   pu_failure_excep EXCEPTION;
   PRAGMA EXCEPTION_INIT(pu_failure_excep, -20000);
BEGIN
   IF p_title_txt IS NOT NULL THEN
   OPEN cur_title;
      FETCH cur_title into lv_title_txt;
      IF cur_title%NOTFOUND THEN
         CLOSE cur_title;
         RAISE pu_failure_excep;
      END IF;
   CLOSE cur_title;
  END IF;
EXCEPTION
   WHEN pu_failure_excep THEN
      RAISE;
   WHEN OTHERS THEN
      -- The call to the error logging procedure would be inserted
      -- in this location.
      RAISE;
END validate_title;
/

SPOOL OFF
