-- ***************************************************************************
-- File: 4_1.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_1.lis

-- ************************************************************
-- 4_1.SQL
-- ***********
-- Table Descriptions
-- All Tables for Current Schema
-- ************************************************************
SET NUMWIDTH 3
SET WRAP ON
SET VERIFY OFF
SET RECSEP OFF
SET FEEDBACK ON
SET SPACE 1
SET NEWPAGE 0
SET PAGESIZE 56
SET LINESIZE 80
SET TAB OFF
-- ************************************************************
BREAK ON today
COLUMN today NEW_VALUE _DATE
column user  NEW_VALUE _USER
SELECT TO_CHAR(SYSDATE, 'mm/dd/yyyy') today,
       USER
FROM   dual;
CLEAR BREAKS
-- ************************************************************
TTITLE LEFT '4_1.sql' RIGHT 'Printed: ' _DATE  SKIP 1 -
       CENTER 'Table / View Descriptions' SKIP 1-
       CENTER 'All Tables and Views for Schema ' _USER SKIP 2;
BTITLE SKIP 2 CENTER 'Page  ' SQL.PNO
BREAK ON table_name SKIP 1
COLUMN table_name  FORMAT A20    HEADING 'Table'
COLUMN column_name FORMAT A22    HEADING 'Column'
COLUMN data_type   FORMAT A10    HEADING 'Data|Type'
COLUMN data_length FORMAT 999999 HEADING 'Length'
COLUMN data_scale  FORMAT 99999  HEADING 'Scale'
COLUMN nullable    FORMAT A5     HEADING 'Null'

SPOOL 4_1.lis
SELECT table_name, column_name, data_type, 
       DECODE(data_length, 22, data_precision, 
              data_length) data_length,
       data_scale, nullable
FROM   user_tab_columns
ORDER BY table_name, column_id;
SPOOL OFF

SPOOL OFF
