-- ***************************************************************************
-- File: 12_19.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_19.lis

CREATE OR REPLACE PACKAGE pipe_output IS
   pv_pipe_on_bln BOOLEAN := FALSE;
PROCEDURE set_pipeoutput_on;
PROCEDURE put_line (p_message_txt VARCHAR2);
PROCEDURE get_line (p_waittime_num NUMBER := 1);
END pipe_output;
/

SPOOL OFF
