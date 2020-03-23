-- ***************************************************************************
-- File: 15_5.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 15_5.lis

HTP.PRINT('<applet code="ScrollingText.class"
   ALIGN="center" WIDTH="500" HEIGHT="40"
   BACKGROUND="slbackgd.gif">
   <param name="name" value="'||scrolling_text||'">
   <param name="width" value="500">
   <param name="size" value="36">
   <param name="height" value="40">
   <param name="color" value="blue">
   <param name="font" value="TimesRoman">
   <param name="format" value="bold">
   <param name="speed" value="1">
   <param name="background" value="black"></applet>');

SPOOL OFF
