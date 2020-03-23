-- ***************************************************************************
-- File: 15_3.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 15_3.lis

CREATE OR REPLACE PROCEDURE pageopen 
   (p_in_title_txt IN VARCHAR2) IS
BEGIN
   HTP.HTMLOPEN;
   HTP.HEADOPEN;
   HTP.TITLE (p_in_title_txt);
   HTP.HEADCLOSE;
   HTP.BODYOPEN;
   HTP.HEADER (1, p_in_title_txt, 'CENTER');
END pageopen;
/

SPOOL OFF
