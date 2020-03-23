-- ***************************************************************************
-- File: 16_6.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_6.lis

CREATE OR REPLACE PACKAGE maintain_state IS
   pv_base_count_num PLS_INTEGER := 0;
END;
/

SPOOL OFF
