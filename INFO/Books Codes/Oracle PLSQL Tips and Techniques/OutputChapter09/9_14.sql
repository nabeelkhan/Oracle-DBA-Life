-- ***************************************************************************
-- File: 9_14.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 9_14.lis

SELECT SUM(pins) pins, SUM(pinhits) pinhits, 
       ((SUM(pinhits) / SUM(pins)) * 100) phitrat,
       SUM(reloads) reloads,
       ((SUM(pins) / (SUM(pins) + SUM(reloads))) * 100) rhitrat
FROM   v$librarycache;

SPOOL OFF
