-- ***************************************************************************
-- File: 5_17.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_17.lis

CREATE OR REPLACE PROCEDURE EE AS
BEGIN
   NULL;
END;
/
CREATE OR REPLACE PROCEDURE DD AS
BEGIN
   EE;
END;
/
CREATE OR REPLACE PROCEDURE CC AS
BEGIN
   DD;
END;
/
CREATE OR REPLACE PROCEDURE BB AS
BEGIN
   CC;
END;
/
CREATE OR REPLACE PROCEDURE AA AS
BEGIN
   BB;
END;
/

SPOOL OFF
