-- ***************************************************************************
-- File: 12_19b.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_19b.lis

CREATE OR REPLACE PACKAGE BODY pipe_output IS
PROCEDURE set_pipeoutput_on IS
-- Opens the communication pipe
BEGIN
   pv_pipe_on_bln := TRUE;
END set_pipeoutput_on;

PROCEDURE put_line (p_message_txt VARCHAR2) IS
-- Sends the username of the executing user and a message to the pipe 
  lv_status_num PLS_INTEGER;
BEGIN
   IF (pv_pipe_on_bln) THEN
      DBMS_PIPE.PACK_MESSAGE(USER);
      DBMS_PIPE.PACK_MESSAGE(p_message_txt);
      lv_status_num := DBMS_PIPE.SEND_MESSAGE('OUTPUT');
   END IF;
END put_line;

PROCEDURE get_line (p_waittime_num NUMBER := 1) IS
-- Monitors the pipe based on a specified wait time, reading and 
-- displaying the username and messages as they are sent from the
-- executing process.
   lv_status_num            PLS_INTEGER;
   lv_username_txt          VARCHAR2(30);
   lv_message_txt           VARCHAR2(2000);
   lv_message_processed_bln BOOLEAN := FALSE;
BEGIN
   LOOP
      lv_status_num := DBMS_PIPE.RECEIVE_MESSAGE('OUTPUT', 
         p_waittime_num);
      EXIT WHEN (lv_status_num != 0);
      lv_message_processed_bln := TRUE;
      DBMS_PIPE.UNPACK_MESSAGE(lv_username_txt);
      DBMS_PIPE.UNPACK_MESSAGE(lv_message_txt);
      DBMS_OUTPUT.PUT_LINE(RPAD('USER: '||lv_username_txt,30)||
                           'MESSAGE: '||lv_message_txt);
   END LOOP;
   IF NOT lv_message_processed_bln THEN
      DBMS_OUTPUT.PUT_LINE('No output in pipe.');
   END IF;
END get_line;
END pipe_output;
/

SPOOL OFF
