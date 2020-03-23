-- ***************************************************************************
-- File: 15_11.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 15_11.lis

CREATE OR REPLACE PROCEDURE query_form
   (p_table_txt IN VARCHAR2) IS
   CURSOR cur_cols IS
   SELECT column_name
   FROM   user_tab_columns
   WHERE  table_name = UPPER(p_table_txt);
BEGIN
   HTP.HTMLOPEN;
   HTP.HEADOPEN;
   HTP.HTITLE('Query the ' || p_table_txt || ' table!');
   HTP.HEADCLOSE;
   HTP.BODYOPEN;
   -- Use owa_util.get_owa_service path to automatically retrieve
   HTP.FORMOPEN(OWA_UTIL.GET_OWA_SERVICE_PATH||'do_query');
   -- Put in the table as a hidden field to pass on to do_query
   HTP.FORMHIDDEN('p_table_txt', p_table_txt);
   -- Put in a dummy value, as we cannot DEFAULT NULL a PL/SQL
   -- table.
   HTP.FORMHIDDEN('COLS', 'dummy');
   FOR cur_cols_rec IN cur_cols LOOP
      -- Create a checkbox for each column. The form field name
      -- will be COLS and the value will be the given column name.
      -- Will need to use a PL/SQL table to retrieve a set of
      -- values like this. Can use the owa_util.ident_arr type
      -- since the columns are identifiers.
      HTP.FORMCHECKBOX('COLS', cur_cols_rec.column_name);
      HTP.PRINT(cur_cols_rec.column_name);
      HTP.NL;
   END LOOP;
   -- Pass a NULL field name for the Submit field; that way, a
   -- name/value pair is not sent in. Wouldn't want to do this
   -- if there were multiple submit buttons.
   HTP.FORMSUBMIT(NULL, 'Execute Query');
   HTP.FORMCLOSE;
   HTP.BODYCLOSE;
   HTP.HTMLCLOSE;
END query_form;
/

SPOOL OFF
