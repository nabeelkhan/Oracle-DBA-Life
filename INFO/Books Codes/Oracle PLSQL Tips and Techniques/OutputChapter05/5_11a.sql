-- ***************************************************************************
-- File: 5_11a.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_11a.lis

CREATE OR REPLACE PACKAGE BODY globals IS
   -- Declare package variables.
   -- You must change the version variable with every package change.
   pv_version_txt VARCHAR2(30) := '19980519.1'; 
   -- Declare local program units.
   -- Declare global program units.
   FUNCTION what_version RETURN VARCHAR2 IS
   BEGIN
      RETURN pv_version_txt;
   END; -- what_version
END globals;
/

SPOOL OFF
