-- ***************************************************************************
-- File: 5_37.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_37.lis

CREATE OR REPLACE PACKAGE process_vacations IS
   TYPE pv_vacation_rec IS RECORD
      (pv_vacationing_user_txt    VARCHAR2(30),
       pv_start_date              VARCHAR2(10),
       pv_end_date                VARCHAR2(10),
       pv_redirect_interviews_txt VARCHAR2(30),
       pv_redirect_reviews_txt    VARCHAR2(30));
   TYPE pv_type_vacation_tab IS TABLE OF pv_vacation_rec 
      INDEX BY BINARY_INTEGER;
   PROCEDURE process_schedules (p_vac_tab IN pv_type_vacation_tab);
END process_vacations;
/

SPOOL OFF
