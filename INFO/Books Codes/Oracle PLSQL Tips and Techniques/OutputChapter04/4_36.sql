-- ***************************************************************************
-- File: 4_36.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_36.lis

-- Creates the employee log table 
CREATE TABLE EMPLOYEE_PROCESS_LOG
(PROCESS_USER      VARCHAR2(30),
 PROCESS_DATE      DATE,
 PROCESS_TIME      VARCHAR2(6),
 RECORDS_PROCESSED NUMBER(10));

SPOOL OFF
