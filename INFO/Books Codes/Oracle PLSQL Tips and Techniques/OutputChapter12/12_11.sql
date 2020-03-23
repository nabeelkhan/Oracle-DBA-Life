-- ***************************************************************************
-- File: 12_11.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_11.lis

SELECT a.job, what,
       TO_CHAR(SYSDATE, 'mm/dd/yyyy hh24:mi:ss') now,
       TO_CHAR(a.this_date, 'mm/dd/yyyy hh24:mi:ss') this
FROM   dba_jobs_running a, dba_jobs b
WHERE  a.job = b.job;

SPOOL OFF
