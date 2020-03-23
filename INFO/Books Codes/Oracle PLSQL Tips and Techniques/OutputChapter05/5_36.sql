-- ***************************************************************************
-- File: 5_36.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_36.lis

BEGIN
-- Procedure do_all( p_1_num NUMBER, 
--                   p_2_txt VARCHAR2 := NULL,
--                   p_3_txt VARCHAR2 := NULL,
--                   p_4_txt VARCHAR2 := NULL,
--                   p_5_txt VARCHAR2 := NULL,
--                   p_6_txt VARCHAR2 := NULL,
--                   p_7_txt VARCHAR2 := NULL,
--                   p_8_txt VARCHAR2 := NULL );
   do_all(1, p_4_txt => 'OLD', p_6_txt => 'NEW');
END;
/

SPOOL OFF
