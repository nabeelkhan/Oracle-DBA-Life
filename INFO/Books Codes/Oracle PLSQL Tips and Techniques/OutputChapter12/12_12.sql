-- ***************************************************************************
-- File: 12_12.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_12.lis

DECLARE
   lv_job_num NUMBER;
BEGIN
   DBMS_JOB.SUBMIT(lv_job_num, 'LOG_SOURCE;', SYSDATE, 
      'SYSDATE + 1/24', NULL);
   DBMS_OUTPUT.PUT_LINE('Assigned Job #: ' || lv_job_num);
END;
/

SPOOL OFF
