REM FILE NAME: 	flush_rep.sql  
REM LOCATION:   Database Tuning\Shared Pool Reports
REM FUNCTION:   Shared pool flushes 
REM FUNCTION:
REM TESTED ON:  8.1.7, 9.0.1
REM PLATFORM:  	non-specific
REM REQUIRES:   flush_it.sql dbms_revealnet.sql
REM
REM This is a part of the Knowledge Xpert for Oracle Administration library. 
REM Copyright (C) 2001 Quest Software 
REM All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM
REM Reports based on count of entries per day in the 
REM DBA_RUNNING_STATS table the number of flushes
REM of the shared pool. If average is excessive
REM increase the size of the shared pool or increase the 
REM ratio in the flush_it procedure.
REM
REM***********************************************************************************


COLUMN flushes heading 'Flushes|of|Shared Pool'
COLUMN meas_date heading 'Date|of|Flushes'
SET verify off feedback off
BREAK on report
COMPUTE avg of flushes on report
ACCEPT min_date prompt 'Enter date (dd-mon-yy) to start from:'
ACCEPT no_days prompt 'Enter number of days for report:'
START title80 'Shared Pool Flushes'
SPOOL rep_out/flush_rep
SELECT   COUNT (*) flushes, TRUNC (meas_date) meas_date
    FROM dba_running_stats
   WHERE TRUNC (meas_date) >= TO_DATE ('&min_date', 'dd-mon-yy')
     AND TRUNC (meas_date) <=
                      TO_DATE ('&min_date', 'dd-mon-yy')
                    + TO_NUMBER ('&no_days')
     AND NAME LIKE 'Flush%'
     AND UPPER (TO_CHAR (meas_date, 'DY')) NOT IN ('SAT', 'SUN')
GROUP BY TRUNC (meas_date)
/
SPOOL off
CLEAR computes
CLEAR breaks
UNDEF min_date
UNDEF no_days
SET verify on feedback on
