-- ***************************************************************************
-- File: 8_1.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_1.lis

CREATE OR REPLACE PACKAGE stop_watch AS
   pv_start_time_num     PLS_INTEGER;
   pv_stop_time_num      PLS_INTEGER;
   pv_last_stop_time_num PLS_INTEGER;

-- This procedure creates a starting point for the timer routine and
-- is usually called once at the beginning of the PL/SQL program unit.
PROCEDURE start_timer;

-- This procedure retrieves a point in time and subtracts the current
-- time from the start time to determine the elapsed time. The 
-- interval elapsed time is logged and displayed. This procedure is
-- usually called repetitively for each iteration or a specified 
-- number of iterations.
PROCEDURE stop_timer;
END stop_watch;
/

SPOOL OFF
