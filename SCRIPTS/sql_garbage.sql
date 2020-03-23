REM FILE NAME:	sql_garbage.sql  
REM LOCATION:   Database Tuning\Shared Pool Reports
REM FUNCTION:   Shared SQL utilization
REM FUNCTION:
REM TESTED ON: 	7.3.3.5, 8.0.4.1, 8.1.5, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM
REM Determines system reusable code ratios
REM
REM***********************************************************************************
REM
REM ORA-00942: TABLE OR VIEW DOES NOT EXIST


COLUMN garbage format 9,999,999,999 heading 'Non-Shared SQL'
COLUMN good format 9,999,999,999 heading 'Shared SQL'
COLUMN good_percent format 999.99 heading 'Percent Shared'
SET feedback off 
BREAK on report
COMPUTE sum of garbage on report
COMPUTE sum of good on report
COMPUTE avg of good_percent on report
@title80 'Shared Pool Utilization'
SPOOL rep_out\sql_garbage
SELECT a.users, a.garbage, b.good,
       (b.good / (  b.good
                  + a.garbage
                 )
       ) * 100 good_percent
  FROM sql_garbage a, sql_garbage b
 WHERE a.users = b.users AND a.garbage IS NOT NULL AND b.good IS NOT NULL
/
SPOOL off
