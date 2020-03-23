-- ***************************************************************************
-- File: 9_31.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 9_31.lis

DECLARE
   CURSOR cur_trace IS
      SELECT a.username, a.sid, a.serial#, b.physical_reads,
             b.block_gets, b.consistent_gets
      FROM   v$session a, v$sess_io b
      WHERE  a.sid = b.sid
      AND    NVL(a.username,'XX') NOT IN ('SYS', 'SYSTEM', 'XX')
      ORDER BY b.physical_reads DESC;
   lv_count_num PLS_INTEGER := 0;
BEGIN
   FOR cur_trace_rec IN cur_trace LOOP
      lv_count_num := lv_count_num + 1;
      IF lv_count_num = 4 THEN
         EXIT;
      END IF;
      DBMS_SYSTEM.SET_SQL_TRACE_IN_SESSION(cur_trace_rec.sid,
         cur_trace_rec.serial#, TRUE);
      DBMS_OUTPUT.PUT_LINE('Sessions Traced---Username: ' ||
         RPAD(cur_trace_rec.username,20) || ' Sid: '     ||
         RPAD(cur_trace_rec.sid,8) || ' Serial#: ' ||
         cur_trace_rec.serial#);
   END LOOP;
END;
/

SPOOL OFF
