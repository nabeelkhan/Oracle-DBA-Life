-- ***************************************************************************
-- File: 4_4.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_4.lis

SELECT sequence_name, increment_by,
       DECODE(cycle_flag,'y','  cycle','n', 'nocycle', 'nocycle')
              cycle_flag,
       DECODE(order_flag,'y','  order','n', 'noorder', 'noorder')
              order_flag,
       max_value, min_value, cache_size, last_number
FROM   user_sequences
ORDER BY sequence_name;

SPOOL OFF
