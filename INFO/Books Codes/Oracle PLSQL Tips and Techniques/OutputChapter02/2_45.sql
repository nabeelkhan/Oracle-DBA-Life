-- ***************************************************************************
-- File: 2_45.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 2_45.lis

SELECT filename, SUBSTR(filename, 1, 
       DECODE(INSTR(filename, '.') -1, -1, LENGTH(filename), 
       INSTR(filename, '.') -1)) new_filename
FROM   s_image;

SPOOL OFF
