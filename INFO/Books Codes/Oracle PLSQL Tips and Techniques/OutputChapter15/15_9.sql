-- ***************************************************************************
-- File: 15_9.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 15_9.lis

CREATE OR REPLACE PROCEDURE hockey_pass (p_person_txt IN VARCHAR2) IS
   lv_assists_num PLS_INTEGER;
BEGIN
   SELECT num_assists 
   INTO   lv_assists_num
   FROM   hockey_stats
   WHERE  name = p_person_txt;
   HTP.PRINT(p_person_txt || ' has ' || to_char(lv_assists_num) ||
      ' assists this season');
END hockey_pass;
/

SPOOL OFF
