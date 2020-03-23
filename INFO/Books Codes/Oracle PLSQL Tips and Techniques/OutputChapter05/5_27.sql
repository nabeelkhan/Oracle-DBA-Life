-- ***************************************************************************
-- File: 5_27.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_27.lis

CREATE TABLE s_item_log
 (order_id          NUMBER(7),
  item_id           NUMBER(7),
  product_id        NUMBER(7),
  price             NUMBER(11, 2),
  quantity          NUMBER(9),
  quantity_shipped  NUMBER(9),
  log_type          VARCHAR2(1),
  log_user          VARCHAR2(30),
  log_date          DATE);

SPOOL OFF
