REM FILE NAME:  title132.sql
REM LOCATION:   SetUp
REM FUNCTION:   Define a 132 column report heading. Define DB and userid parameters
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   sys.v_$parameter
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN  TODAY    NEW_VALUE  CURRENT_DATE   NOPRINT
COLUMN  TIME     NEW_VALUE  CURRENT_TIME   NOPRINT
COLUMN  DATABASE NEW_VALUE  DATA_BASE      NOPRINT
COLUMN  PASSOUT  NEW_VALUE  DBNAME         NOPRINT
REM
DEFINE COMPANY = " "
DEFINE HEADING = "&1"
REM
SPOOL ON
TTITLE LEFT "Date: " current_date CENTER company col 118 "Page:" format 999 -
       SQL.PNO SKIP 1 LEFT "Time: " current_time CENTER heading RIGHT -
       format a15 SQL.USER SKIP 1 CENTER format a20 data_base SKIP 2
REM
REM
SET heading off termout off
REM
SELECT TO_CHAR (SYSDATE, 'MM/DD/YY') today, TO_CHAR (SYSDATE, 'HH:MI AM') TIME,
          VALUE
       || ' database' DATABASE, RTRIM (VALUE) passout
  FROM sys.v_$parameter
 WHERE NAME = 'db_name';
REM
SET heading on termout on
SET newpage 0
SET linesize 132
/
