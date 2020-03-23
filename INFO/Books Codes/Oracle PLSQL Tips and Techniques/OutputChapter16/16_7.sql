-- ***************************************************************************
-- File: 16_7.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_7.lis

BEGIN
   DBMS_OUTPUT.PUT_LINE('Original Value: ' ||
      maintain_state.pv_base_count_num);
   maintain_state.pv_base_count_num :=
      maintain_state.pv_base_count_num + 10;
   DBMS_OUTPUT.PUT_LINE('New Value:      ' ||
      maintain_state.pv_base_count_num);
END;
/

SPOOL OFF
