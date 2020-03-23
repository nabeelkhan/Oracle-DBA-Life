-- ***************************************************************************
-- File: 15_10.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 15_10.lis

CREATE OR REPLACE PROCEDURE showvals
   (p_a_txt IN VARCHAR2 DEFAULT NULL,
    p_b_txt IN VARCHAR2 DEFAULT NULL) IS
BEGIN
   HTP.PRINT('a = '|| p_a_txt || HTF.BR);
   HTP.PRINT('b = '|| p_b_txt || HTF.BR);
END showvals;
/

SPOOL OFF
