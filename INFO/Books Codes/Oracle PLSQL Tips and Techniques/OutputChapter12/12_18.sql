-- ***************************************************************************
-- File: 12_18.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_18.lis

CREATE OR REPLACE TRIGGER bu_order
   BEFORE UPDATE of order_filled ON s_order
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
   WHEN (NEW.order_filled = 'Y')
DECLARE
   CURSOR cur_user IS
      SELECT DISTINCT username 
      FROM   v$session
      WHERE  NVL(username,'*') NOT IN ( 'SYS', 'SYSTEM', '*');
   lv_pipe_status_num PLS_INTEGER;
BEGIN
   -- If an order has been filled, notify all sessions with ORDER_ID
   -- and TOTAL. For all non-system users, send the piped message
   FOR cur_user_rec IN cur_user LOOP
      DBMS_PIPE.PURGE (cur_user_rec.username);
      DBMS_PIPE.PACK_MESSAGE (:NEW.order_id);
      DBMS_PIPE.PACK_MESSAGE (:NEW.total);
      lv_pipe_status_num := DBMS_PIPE.SEND_MESSAGE 
         (cur_user_rec.username);
   END LOOP;
END bu_order;
/

SPOOL OFF
