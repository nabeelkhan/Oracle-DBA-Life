-- ***************************************************************************
-- File: 14_5.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 14_5.lis

CREATE OR REPLACE PACKAGE pkg_vars AS
-- Purpose: This package can be used to process server-side package
-- global variables.  Each global variable can be declared below or 
-- in any other PL/SQL package. Any variable in this section has a 
-- scope of the current session. The set_pvar PROCEDURE is overloaded
-- and can accept either a NUMBER, VARCHAR2, OR DATE as the second 
-- parameter. The first parameter should be in the format
-- package_name.variable_name.  The get_pnumber, get_pdate, and
-- get_pvarchar2 FUNCTIONs can be used to receive either a NUMBER, 
-- DATE, and VARCHAR2, respectively.
   pv_cursor_num PLS_INTEGER;
   pv_temp_num   PLS_INTEGER;
   pv_ord_num    NUMBER;
   pv_cust_num   NUMBER;
   PROCEDURE set_pvar(p_varname_txt VARCHAR2, p_val NUMBER);
   PROCEDURE set_pvar(p_varname_txt VARCHAR2, p_val VARCHAR2);
   PROCEDURE set_pvar(p_varname_txt VARCHAR2, p_val DATE);
   FUNCTION get_pnumber(p_varname_txt VARCHAR2)
      RETURN NUMBER;
   FUNCTION get_pvarchar2(p_varname_txt VARCHAR2)
      RETURN VARCHAR2;
   FUNCTION get_pdate(p_varname_txt VARCHAR2)
      RETURN DATE;
END pkg_vars;
/ 

SPOOL OFF
