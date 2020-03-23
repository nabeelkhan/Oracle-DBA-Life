-- ***************************************************************************
-- File: 16_19.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_19.lis

SELECT DBMS_ROWID.ROWID_BLOCK_NUMBER(ROWID) "Block Number",
        DBMS_ROWID.ROWID_ROW_NUMBER(ROWID) "Row in Block",
        employee_id
FROM    s_employee;

SPOOL OFF
