-- ***************************************************************************
-- File: 15_13a.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 15_13a.lis

CREATE OR REPLACE PACKAGE BODY overload IS
PROCEDURE proc1(p_charval_txt IN VARCHAR2) IS
BEGIN
   HTP.PRINT('The character value is ' || p_charval_txt);
END proc1; 

PROCEDURE proc1(p_numval_num IN NUMBER) IS
BEGIN
   HTP.PRINT('The number value is '||p_numval_num);
END proc1;
END overload;
/

SPOOL OFF
