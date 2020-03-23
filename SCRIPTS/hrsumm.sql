REM FILE NAME:  hrsumm.sql
REM LOCATION:  	Database Tuning\Buffer Cache Reports
REM FUNCTION:   GENERATE SUMMARY REPORT OF PERIOD HIT RATIOS AND USAGE
REM             BETWEEN TWO DATES
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   hit_ratios, hratio.sql
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


SET VERIFY OFF PAGES 58 NEWPAGE 0
ACCEPT check_date1 PROMPT "Enter start date in DD-MON-YY format: "
ACCEPT check_date2 PROMPT "Enter ending date in DD-MON-YY format: "
START title80 "HIT RATIO AND USAGE FOR &&CHECK_DATE1 TO &&CHECK_DATE2"
SPOOL rep_out/hrsumm
SELECT   check_date, check_hour, period_hit_ratio, period_usage, users
    FROM hit_ratios
   WHERE check_date BETWEEN '&&check_date1' AND '&&check_date2'
ORDER BY check_date, check_hour;
SPOOL OFF
UNDEF check_date1
UNDEF check_date2
