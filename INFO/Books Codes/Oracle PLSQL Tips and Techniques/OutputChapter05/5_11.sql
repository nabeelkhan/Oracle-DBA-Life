-- ***************************************************************************
-- File: 5_11.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_11.lis

CREATE OR REPLACE PACKAGE globals IS
   FUNCTION what_version RETURN VARCHAR2;
   PRAGMA RESTRICT_REFERENCES(what_version, WNDS, WNPS, RNDS);
END globals;
/

SPOOL OFF
