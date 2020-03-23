-- ***************************************************************************
-- File: 12_20.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_20.lis

BEGIN
   pipe_output.set_pipeoutput_on;
   FOR lv_loop_num IN 1..5 LOOP
      pipe_output.put_line('Currently in iteration: ' ||
         TO_CHAR(lv_loop_num) || '.' );
   END LOOP;
END;
/

SPOOL OFF
