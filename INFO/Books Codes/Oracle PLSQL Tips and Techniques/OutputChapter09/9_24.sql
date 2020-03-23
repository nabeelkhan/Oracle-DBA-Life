-- ***************************************************************************
-- File: 9_24.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 9_24.lis

CREATE TABLE objects_to_pin
   (owner    VARCHAR2(30) NOT NULL,
    object   VARCHAR2(128) NOT NULL);

SPOOL OFF
