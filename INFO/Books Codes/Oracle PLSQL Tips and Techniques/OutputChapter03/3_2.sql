-- ***************************************************************************
-- File: 3_2.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 3_2.lis

DECLARE
   lv_class_txt  VARCHAR2(18);
   lv_count_num  NUMBER;
BEGIN
   -- The following SELECT executes without error in SQL*Plus
   -- (without the INTO clause), however in PL/SQL it results
   -- in the error below. The reason for the error is that 'count'
   -- is a SQL reserved word. 
   SELECT class, count
   INTO   lv_class_txt, lv_count_num
   FROM   v$waitstat a
   WHERE  ROWNUM < 2;
END;
/

DECLARE
*
ERROR at line 1:
ORA-00937: not a single-group group function
ORA-06512: at line 5

SPOOL OFF
