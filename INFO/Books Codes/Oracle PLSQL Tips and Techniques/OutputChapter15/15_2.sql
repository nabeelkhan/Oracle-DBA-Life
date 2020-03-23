-- ***************************************************************************
-- File: 15_2.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 15_2.lis

CREATE OR REPLACE PROCEDURE list_dads_tables IS
   CURSOR cur_tables IS
      SELECT table_name 
      FROM   user_tables
      ORDER BY table_name;
BEGIN
   HTP.PRINT('<HTML>');
   HTP.PRINT('<HEAD>');
   HTP.PRINT('<TITLE>Display a List of the Current DAD''s ' ||
      'Tables</TITLE>');
   HTP.PRINT('</HEAD>');
   HTP.PRINT('<BODY>');
   HTP.PRINT('<UL>');
      FOR cur_tables_rec IN cur_tables LOOP
         HTP.PRINT('<LI>' || cur_tables_rec.table_name);
      END LOOP;
   HTP.PRINT('</UL>');
   HTP.PRINT('</BODY>');
   HTP.PRINT('</HTML>');
END list_dads_tables;
/

SPOOL OFF
