-- ***************************************************************************
-- File: 12_38.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_38.lis

CREATE OR REPLACE FUNCTION math_calc(p_statement_txt VARCHAR2, 
   p_precision_num PLS_INTEGER := 2)
RETURN NUMBER IS
   -- This function uses a character string of arithmetic logic, 
   -- selecting against the DUAL table to return a number value.
   lv_cursor_id_num    PLS_INTEGER;
   lv_statement_txt    VARCHAR2(500);
   lv_rowcount_num     PLS_INTEGER;
   lv_return_value_num NUMBER;
BEGIN
   -- Open a cursor to be used
   lv_cursor_id_num := DBMS_SQL.OPEN_CURSOR;
   -- Set up PL/SQL block to assign variable statement value
   lv_statement_txt := 
      'BEGIN ' ||
      '    :lv_value_num := ' || p_statement_txt || ';' ||
      'END;';
   -- Parse the PL/SQL block
   DBMS_SQL.PARSE(lv_cursor_id_num, lv_statement_txt,DBMS_SQL.NATIVE);
   -- Set up bind variable for usage
   DBMS_SQL.BIND_VARIABLE(lv_cursor_id_num, ':lv_value_num', 
      lv_return_value_num);
   -- Execute the cursor
   lv_rowcount_num := DBMS_SQL.EXECUTE(lv_cursor_id_num);
   -- Retrieve variable value
   DBMS_SQL.VARIABLE_VALUE(lv_cursor_id_num, ':lv_value_num', 
      lv_return_value_num);
   DBMS_SQL.CLOSE_CURSOR(lv_cursor_id_num);
   RETURN ROUND(lv_return_value_num, p_precision_num);
EXCEPTION
   WHEN OTHERS THEN
      IF DBMS_SQL.IS_OPEN(lv_cursor_id_num) THEN
         DBMS_SQL.CLOSE_CURSOR(lv_cursor_id_num);
      END IF;
      RAISE_APPLICATION_ERROR(-20101, 'Error processing SQL ' ||
         'statement in MATH_CALC procedure', FALSE);
END math_calc;
/

SPOOL OFF
