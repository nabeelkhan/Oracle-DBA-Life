-- ***************************************************************************
-- File: 16_20.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_20.lis

SELECT COUNT(DISTINCT(DBMS_ROWID.ROWID_BLOCK_NUMBER(ROWID))) 
       "Distinct Blocks",
       AVG(COUNT(DBMS_ROWID.ROWID_ROW_NUMBER(ROWID))) 
       "Avg # Rows/Block",
       MIN(COUNT(DBMS_ROWID.ROWID_ROW_NUMBER(ROWID))) 
       "Min # Rows/BLock",
       MAX(COUNT(DBMS_ROWID.ROWID_ROW_NUMBER(ROWID))) 
       "Max # Rows/Block"
FROM   s_employee
GROUP BY DBMS_ROWID.ROWID_BLOCK_NUMBER(ROWID);

SPOOL OFF
