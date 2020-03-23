-- ***************************************************************************
-- File: 12_43.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_43.lis

SELECT b.segment_name, status, sum(bytes) sum_bytes
FROM   dba_extents a, dba_rollback_segs b
WHERE  a.segment_name = b.segment_name
AND    a.segment_type = 'ROLLBACK'
GROUP BY b.segment_name, status
ORDER BY status DESC, b.segment_name;

SPOOL OFF
