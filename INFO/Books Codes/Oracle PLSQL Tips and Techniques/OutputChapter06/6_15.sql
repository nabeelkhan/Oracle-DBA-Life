-- ***************************************************************************
-- File: 6_15.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_15.lis

BEGIN
   IF validate_date_format('&&valid_date') THEN
      DBMS_OUTPUT.PUT_LINE('Date: ' || '&&valid_date' ||
         CHR(9) || ' is a VALID Date.');
   ELSE
      DBMS_OUTPUT.PUT_LINE('Date: ' || '&&valid_date' ||
         CHR(9) || ' is an INVALID Date.');
   END IF;
END;
/

SPOOL OFF
