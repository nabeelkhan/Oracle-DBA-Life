-- ***************************************************************************
-- File: 15_12.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 15_12.lis

-- DO_QUERY executes the query on the specified columns and table.
-- The OWA_UTIL.IDENT_ARR datatype is defined as:
-- type ident_arr is table of VARCHAR2(30) index by binary_integer
CREATE OR REPLACE PROCEDURE do_query
   (p_table_txt IN VARCHAR2,
    p_cols_rec  IN owa_util.ident_arr) IS
   lv_column_list_txt VARCHAR2(32000);
   lv_col_counter_num INTEGER;
   lv_ignore_bln      BOOLEAN;
BEGIN
   -- For PL/SQL tables, have to just loop through until you raise
   -- the NO_DATA_FOUND exception. Start the counter at 2 since we 
   -- put in a dummy hidden field.
   lv_col_counter_num := 2;
   LOOP
      -- build a comma-delimited list of columns
      lv_column_list_txt := lv_column_list_txt || 
         p_cols_rec(lv_col_counter_num) || ',';
      lv_col_counter_num := lv_col_counter_num + 1;
   END LOOP;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      -- strip out the last trailing comma
      lv_column_list_txt := SUBSTR(lv_column_list_txt, 1,
         LENGTH(lv_column_list_txt) - 1);
      -- print the table - assumes HTML table support
      lv_ignore_bln := OWA_UTIL.TABLEPRINT(p_table_txt, 'BORDER',
                   OWA_UTIL.HTML_TABLE, lv_column_list_txt);
END do_query;
/

SPOOL OFF
