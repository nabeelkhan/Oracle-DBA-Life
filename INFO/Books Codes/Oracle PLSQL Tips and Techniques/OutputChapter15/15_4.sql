-- ***************************************************************************
-- File: 15_4.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 15_4.lis

HTP.APPLET('ScrollingText.class','40','500','ALIGN=center,
   BACKGROUND=slbackgd.gif');
HTP.PARAM('name',scrolling_text);
HTP.PARAM('width','500');
HTP.PARAM('size','36');
HTP.PARAM('height','40');
HTP.PARAM('color','blue');
HTP.PARAM('font','TimesRoman');
HTP.PARAM('format','bold');
HTP.PARAM('speed','1');
HTP.PARAM('background','black');
HTP.APPLETCLOSE;

SPOOL OFF
