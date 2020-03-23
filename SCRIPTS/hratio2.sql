REM FILE NAME:  hratio2.sql
REM LOCATION:   Database Tuning\Buffer Cache Reports
REM FUNCTION:   CREATE PLOT OF PERIOD HIT RATIO FOR 1 DAY
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   hit_ratios, hratio.sql 
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


SET lines 131 newpage 0 VERIFY OFF pages 180 space 0 feedback off 
COLUMN hr format 99
ACCEPT check_date1 PROMPT "Enter start date in DD-MON-YY format: "
ACCEPT check_date2 PROMPT "Enter ending date in DD-MON-YY format: "
START title132 "Period HR for &&check_date1 TO &&check_date2" 
SPOOL rep_out/hratio2
SELECT   check_hour hr, DECODE (ROUND (period_hit_ratio), 0, 'o', NULL) zchk0,
         DECODE (ROUND (period_hit_ratio), 1, 'o', NULL) chk1,
         DECODE (ROUND (period_hit_ratio), 2, 'o', NULL) chk2,
         DECODE (ROUND (period_hit_ratio), 3, 'o', NULL) chk3,
         DECODE (ROUND (period_hit_ratio), 4, 'o', NULL) chk4,
         DECODE (ROUND (period_hit_ratio), 5, 'o', NULL) chk5,
         DECODE (ROUND (period_hit_ratio), 6, 'o', NULL) chk6,
         DECODE (ROUND (period_hit_ratio), 7, 'o', NULL) chk7,
         DECODE (ROUND (period_hit_ratio), 8, 'o', NULL) chk8,
         DECODE (ROUND (period_hit_ratio), 9, 'o', NULL) chk9,
         DECODE (ROUND (period_hit_ratio), 10, 'o', NULL) chk10,
         DECODE (ROUND (period_hit_ratio), 11, 'o', NULL) chk11,
         DECODE (ROUND (period_hit_ratio), 12, 'o', NULL) chk12,
         DECODE (ROUND (period_hit_ratio), 13, 'o', NULL) chk13,
         DECODE (ROUND (period_hit_ratio), 14, 'o', NULL) chk14,
         DECODE (ROUND (period_hit_ratio), 15, 'o', NULL) chk15,
         DECODE (ROUND (period_hit_ratio), 16, 'o', NULL) chk16,
         DECODE (ROUND (period_hit_ratio), 17, 'o', NULL) chk17,
         DECODE (ROUND (period_hit_ratio), 18, 'o', NULL) chk18,
         DECODE (ROUND (period_hit_ratio), 19, 'o', NULL) chk19,
         DECODE (ROUND (period_hit_ratio), 20, 'o', NULL) chk20,
         DECODE (ROUND (period_hit_ratio), 21, 'o', NULL) chk21,
         DECODE (ROUND (period_hit_ratio), 22, 'o', NULL) chk22,
         DECODE (ROUND (period_hit_ratio), 23, 'o', NULL) chk23,
         DECODE (ROUND (period_hit_ratio), 24, 'o', NULL) chk24,
         DECODE (ROUND (period_hit_ratio), 25, 'o', NULL) chk25,
         DECODE (ROUND (period_hit_ratio), 26, 'o', NULL) chk26,
         DECODE (ROUND (period_hit_ratio), 27, 'o', NULL) chk27,
         DECODE (ROUND (period_hit_ratio), 28, 'o', NULL) chk28,
         DECODE (ROUND (period_hit_ratio), 29, 'o', NULL) chk29,
         DECODE (ROUND (period_hit_ratio), 30, 'o', NULL) chk30,
         DECODE (ROUND (period_hit_ratio), 31, 'o', NULL) chk31,
         DECODE (ROUND (period_hit_ratio), 32, 'o', NULL) chk32,
         DECODE (ROUND (period_hit_ratio), 33, 'o', NULL) chk33,
         DECODE (ROUND (period_hit_ratio), 34, 'o', NULL) chk34,
         DECODE (ROUND (period_hit_ratio), 35, 'o', NULL) chk35,
         DECODE (ROUND (period_hit_ratio), 36, 'o', NULL) chk36,
         DECODE (ROUND (period_hit_ratio), 37, 'o', NULL) chk37,
         DECODE (ROUND (period_hit_ratio), 38, 'o', NULL) chk38,
         DECODE (ROUND (period_hit_ratio), 39, 'o', NULL) chk39,
         DECODE (ROUND (period_hit_ratio), 40, 'o', NULL) chk40,
         DECODE (ROUND (period_hit_ratio), 41, 'o', NULL) chk41,
         DECODE (ROUND (period_hit_ratio), 42, 'o', NULL) chk42,
         DECODE (ROUND (period_hit_ratio), 43, 'o', NULL) chk43,
         DECODE (ROUND (period_hit_ratio), 44, 'o', NULL) chk44,
         DECODE (ROUND (period_hit_ratio), 45, 'o', NULL) chk45,
         DECODE (ROUND (period_hit_ratio), 46, 'o', NULL) chk46,
         DECODE (ROUND (period_hit_ratio), 47, 'o', NULL) chk47,
         DECODE (ROUND (period_hit_ratio), 48, 'o', NULL) chk48,
         DECODE (ROUND (period_hit_ratio), 49, 'o', NULL) chk49,
         DECODE (ROUND (period_hit_ratio), 50, 'o', NULL) chk50,
         DECODE (ROUND (period_hit_ratio), 51, 'o', NULL) chk51,
         DECODE (ROUND (period_hit_ratio), 52, 'o', NULL) chk52,
         DECODE (ROUND (period_hit_ratio), 53, 'o', NULL) chk53,
         DECODE (ROUND (period_hit_ratio), 54, 'o', NULL) chk54,
         DECODE (ROUND (period_hit_ratio), 55, 'o', NULL) chk55,
         DECODE (ROUND (period_hit_ratio), 56, 'o', NULL) chk56,
         DECODE (ROUND (period_hit_ratio), 57, 'o', NULL) chk57,
         DECODE (ROUND (period_hit_ratio), 58, 'o', NULL) chk58,
         DECODE (ROUND (period_hit_ratio), 59, 'o', NULL) chk59,
         DECODE (ROUND (period_hit_ratio), 60, 'o', NULL) chk60,
         DECODE (ROUND (period_hit_ratio), 61, 'o', NULL) chk61,
         DECODE (ROUND (period_hit_ratio), 62, 'o', NULL) chk62,
         DECODE (ROUND (period_hit_ratio), 63, 'o', NULL) chk63,
         DECODE (ROUND (period_hit_ratio), 64, 'o', NULL) chk64,
         DECODE (ROUND (period_hit_ratio), 65, 'o', NULL) chk65,
         DECODE (ROUND (period_hit_ratio), 66, 'o', NULL) chk66,
         DECODE (ROUND (period_hit_ratio), 67, 'o', NULL) chk67,
         DECODE (ROUND (period_hit_ratio), 68, 'o', NULL) chk68,
         DECODE (ROUND (period_hit_ratio), 69, 'o', NULL) chk69,
         DECODE (ROUND (period_hit_ratio), 70, 'o', NULL) chk70,
         DECODE (ROUND (period_hit_ratio), 71, 'o', NULL) chk71,
         DECODE (ROUND (period_hit_ratio), 72, 'o', NULL) chk72,
         DECODE (ROUND (period_hit_ratio), 73, 'o', NULL) chk73,
         DECODE (ROUND (period_hit_ratio), 74, 'o', NULL) chk74,
         DECODE (ROUND (period_hit_ratio), 75, 'o', NULL) chk75,
         DECODE (ROUND (period_hit_ratio), 76, 'o', NULL) chk76,
         DECODE (ROUND (period_hit_ratio), 77, 'o', NULL) chk77,
         DECODE (ROUND (period_hit_ratio), 78, 'o', NULL) chk78,
         DECODE (ROUND (period_hit_ratio), 79, 'o', NULL) chk79,
         DECODE (ROUND (period_hit_ratio), 80, 'o', NULL) chk80,
         DECODE (ROUND (period_hit_ratio), 81, 'o', NULL) chk81,
         DECODE (ROUND (period_hit_ratio), 82, 'o', NULL) chk82,
         DECODE (ROUND (period_hit_ratio), 83, 'o', NULL) chk83,
         DECODE (ROUND (period_hit_ratio), 84, 'o', NULL) chk84,
         DECODE (ROUND (period_hit_ratio), 85, 'o', NULL) chk85,
         DECODE (ROUND (period_hit_ratio), 86, 'o', NULL) chk86,
         DECODE (ROUND (period_hit_ratio), 87, 'o', NULL) chk87,
         DECODE (ROUND (period_hit_ratio), 88, 'o', NULL) chk88,
         DECODE (ROUND (period_hit_ratio), 89, 'o', NULL) chk89,
         DECODE (ROUND (period_hit_ratio), 90, 'o', NULL) chk90,
         DECODE (ROUND (period_hit_ratio), 91, 'o', NULL) chk91,
         DECODE (ROUND (period_hit_ratio), 92, 'o', NULL) chk92,
         DECODE (ROUND (period_hit_ratio), 93, 'o', NULL) chk93,
         DECODE (ROUND (period_hit_ratio), 94, 'o', NULL) chk94,
         DECODE (ROUND (period_hit_ratio), 95, 'o', NULL) chk95,
         DECODE (ROUND (period_hit_ratio), 96, 'o', NULL) chk96,
         DECODE (ROUND (period_hit_ratio), 97, 'o', NULL) chk97,
         DECODE (ROUND (period_hit_ratio), 98, 'o', NULL) chk98,
         DECODE (ROUND (period_hit_ratio), 99, 'o', NULL) chk99,
         DECODE (ROUND (period_hit_ratio), 100, 'o', NULL) chk100
    FROM hit_ratios
   WHERE check_date BETWEEN TO_DATE ('&&CHECK_DATE1', 'dd-mm-yy')
                        AND TO_DATE ('&&CHECK_DATE2', 'dd-mm-yy')
ORDER BY check_date, check_hour;
SPOOL off
UNDEF CHECK_DATE1
UNDEF CHECK_DATE2
