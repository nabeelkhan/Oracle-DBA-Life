-- ***************************************************************************
-- File: 15_14.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 15_14.lis

CREATE OR REPLACE PACKAGE overload IS
   PROCEDURE proc1(p_val IN VARCHAR2);
   PROCEDURE proc1(p_val IN NUMBER);
END overload;
/

SPOOL OFF
