-- ***************************************************************************
-- File: 14_5a.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 14_5a.lis

CREATE OR REPLACE PACKAGE BODY pkg_vars IS
PROCEDURE set_pvar(p_varname_txt VARCHAR2, p_val NUMBER) IS
BEGIN
   pv_cursor_num := DBMS_SQL.OPEN_CURSOR;
   DBMS_SQL.PARSE(pv_cursor_num,
      'BEGIN ' ||p_varname_txt || ' := :the_value; END;',
      DBMS_SQL.NATIVE);
   DBMS_SQL.BIND_VARIABLE(pv_cursor_num, ':the_value', p_val);
   pv_temp_num := DBMS_SQL.EXECUTE(pv_cursor_num);
   DBMS_SQL.CLOSE_CURSOR(pv_cursor_num);
END set_pvar;
----------------------------------------------------------------
PROCEDURE set_pvar(p_varname_txt VARCHAR2, p_val VARCHAR2) IS
BEGIN
   pv_cursor_num := DBMS_SQL.OPEN_CURSOR;
   DBMS_SQL.PARSE(pv_cursor_num,
      'BEGIN ' ||p_varname_txt || ' := :the_value; END;',
      DBMS_SQL.NATIVE);
   DBMS_SQL.BIND_VARIABLE(pv_cursor_num, ':the_value', p_val, 
      2000);
   pv_temp_num := DBMS_SQL.EXECUTE(pv_cursor_num);
   DBMS_SQL.CLOSE_CURSOR(pv_cursor_num);
END set_pvar;
----------------------------------------------------------------
PROCEDURE set_pvar(p_varname_txt VARCHAR2, p_val DATE) IS
BEGIN
   pv_cursor_num := DBMS_SQL.OPEN_CURSOR;
   DBMS_SQL.PARSE(pv_cursor_num,
      'BEGIN ' ||p_varname_txt || ' := :the_value; END;',
      DBMS_SQL.NATIVE);
   DBMS_SQL.BIND_VARIABLE(pv_cursor_num, ':the_value', p_val);
   pv_temp_num := DBMS_SQL.EXECUTE(pv_cursor_num);
   DBMS_SQL.CLOSE_CURSOR(pv_cursor_num);
END set_pvar;
----------------------------------------------------------------
FUNCTION get_pnumber(p_varname_txt VARCHAR2)
   RETURN NUMBER IS
   lv_value_num NUMBER;
BEGIN
   pv_cursor_num := DBMS_SQL.OPEN_CURSOR;
   DBMS_SQL.PARSE(pv_cursor_num,
      'BEGIN :the_value := ' ||p_varname_txt || '; END;',
      DBMS_SQL.NATIVE);
   DBMS_SQL.BIND_VARIABLE(pv_cursor_num, ':the_value', lv_value_num);
   pv_temp_num := DBMS_SQL.EXECUTE(pv_cursor_num);
   DBMS_SQL.VARIABLE_VALUE(pv_cursor_num, ':the_value', lv_value_num);
   DBMS_SQL.CLOSE_CURSOR(pv_cursor_num);
   RETURN lv_value_num;
END get_pnumber;
----------------------------------------------------------------
FUNCTION get_pvarchar2 (p_varname_txt VARCHAR2)
   RETURN VARCHAR2 IS
   lv_value_txt VARCHAR2(2000);
BEGIN
   pv_cursor_num := DBMS_SQL.OPEN_CURSOR;
   DBMS_SQL.PARSE(pv_cursor_num,
      'BEGIN :the_value := ' ||p_varname_txt || '; END;',
      DBMS_SQL.NATIVE);
   DBMS_SQL.BIND_VARIABLE(pv_cursor_num, ':the_value', 
      lv_value_txt, 2000);
   pv_temp_num := DBMS_SQL.EXECUTE(pv_cursor_num);
   DBMS_SQL.VARIABLE_VALUE(pv_cursor_num, ':the_value', lv_value_txt);
   DBMS_SQL.CLOSE_CURSOR(pv_cursor_num);
   RETURN lv_value_txt;
END get_pvarchar2;
----------------------------------------------------------------
FUNCTION get_pdate(p_varname_txt VARCHAR2)
   RETURN DATE IS
   lv_value_date DATE;
BEGIN
   pv_cursor_num := DBMS_SQL.OPEN_CURSOR;
   DBMS_SQL.PARSE(pv_cursor_num,
      'BEGIN :the_value := ' ||p_varname_txt || '; END;',
      DBMS_SQL.NATIVE);
   DBMS_SQL.BIND_VARIABLE(pv_cursor_num, ':the_value', lv_value_date);
   pv_temp_num := DBMS_SQL.EXECUTE(pv_cursor_num);
   DBMS_SQL.VARIABLE_VALUE(pv_cursor_num, ':the_value',lv_value_date);
   DBMS_SQL.CLOSE_CURSOR(pv_cursor_num);
   RETURN lv_value_date;
END get_pdate;
----------------------------------------------------------------
END pkg_vars;
/

SPOOL OFF
