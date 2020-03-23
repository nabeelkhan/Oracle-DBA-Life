-- ***************************************************************************
-- File: 12_10.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_10.lis

SELECT what, job, priv_user,
       TO_CHAR(last_date, 'MM/DD/YYYY HH24:MI:SS') last,
       DECODE(this_date, NULL, 'NO', 'YES') running,
       TO_CHAR(next_date, 'MM/DD/YYYY HH24:MI:SS') next,
       interval, total_time, broken
FROM   dba_jobs
ORDER BY what;

SPOOL OFF
