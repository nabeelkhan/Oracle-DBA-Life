REM FILE NAME:  title80.sql
REM LOCATION:  	SetUp
REM FUNCTION:   Define a 80 column report heading. Define DB and userid parameters
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$database
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN  TODAY     NEW_VALUE    CURRENT_DATE   NOPRINT
COLUMN  TIME      NEW_VALUE    CURRENT_TIME   NOPRINT
COLUMN  DATABASE  NEW_VALUE    DATA_BASE      NOPRINT
COLUMN  PASSOUT   NEW_VALUE    DBNAME         NOPRINT
COLUMN passout2 new_value user noprint
REM
DEFINE COMPANY = " "
DEFINE HEADING = "&1"
REM
TTITLE LEFT "Date: " current_date CENTER company col 66 "Page:" format 999 -
       SQL.PNO SKIP 1 LEFT "Time: " current_time CENTER heading RIGHT -
       format a15 SQL.USER SKIP 1 CENTER format a20 data_base SKIP 2
REM
REM
SET heading off
SET pagesize 0
REM
SET termout off
SELECT TO_CHAR (SYSDATE, 'MM/DD/YY') today, TO_CHAR (SYSDATE, 'HH:MI AM') TIME,
          NAME
       || ' database' DATABASE, RTRIM (NAME) passout, USER passout2
  FROM v$database;
REM
SET termout on
SET heading on
SET pagesize 58
SET newpage 0
DEFINE userid='&user'
/
