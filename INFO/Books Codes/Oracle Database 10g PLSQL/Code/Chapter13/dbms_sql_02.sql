/*
 * dbms_sql_02.sql
 * Chapter 13, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * Purpose:
 *   This is designed to test the DBMS_SQL_TUTORIAL package.
 */

-- Set bind variable to pass table name.
VARIABLE table_name   VARCHAR2(30)
VARIABLE column_name1 VARCHAR2(30)
VARIABLE column_name2 VARCHAR2(30)
VARIABLE column_name3 VARCHAR2(30)

-- Test block to create, increment and drop a table.
DECLARE

  -- Define local variables.
  table_name_in          VARCHAR2(30) := 'TEST_MESSAGES';
  table_definition_in    VARCHAR2(2000);
  column_name1           VARCHAR2(30) := 'TEST_MESSAGE_ID';
  column_name2           VARCHAR2(30) := 'MESSAGE_SENT';
  column_name3           VARCHAR2(30) := 'REVIEWED_BY';
  table_column_value1    NUMBER       := '1';
  table_column_value2    VARCHAR2(20) := 'Hello World';
  table_column_value3    VARCHAR2(30) := USER;

BEGIN

  -- Assign table name to bind variable.
  :table_name := table_name_in;
  :column_name1 := column_name1;
  :column_name2 := column_name2;
  :column_name3 := column_name3;

  -- Initialize table definition.
  table_definition_in := '( test_message_id NUMBER'      ||CHR(10)
                      || ', message_sent    VARCHAR2(20)'||CHR(10)
                      || ', reviewed_by     VARCHAR2(30))';

  -- Print the output.
  dbms_output.put_line(dbms_sql_tutorial.dline);
  dbms_sql_tutorial.create_table(table_name_in,table_definition_in);

  -- Insert into the table.
  dbms_output.put_line(dbms_sql_tutorial.dline);
  dbms_sql_tutorial.insert_into_table( table_name_in
                                     , table_column_value1
                                     , table_column_value2
                                     , table_column_value3);
  dbms_output.put_line(dbms_sql_tutorial.dline);

END;
/

-- Set SQL*Plus environment formatting.
COL c1   FORMAT 999      HEADING "Test|Message|ID #"
COL c2   FORMAT A20      HEADING "Message Sent"
COL c3   FORMAT A30      HEADING "Reviewed By"

-- Select from the dynamically created table.
SELECT   test_message_id c1
,        message_sent c2
,        reviewed_by c3
FROM     test_messages;

-- Use DBMS_SQL_TUTORIAL to drop the table.
BEGIN

  -- Print line break.
  dbms_output.put_line(dbms_sql_tutorial.dline);

  -- Run dynamic DQL against table.
  dbms_sql_tutorial.single_row_return(:table_name
                                     ,:column_name1
                                     ,:column_name2
                                     ,:column_name3);

  -- Print line break.
  dbms_output.put_line(dbms_sql_tutorial.dline);

  -- Print line break.
  dbms_output.put_line(dbms_sql_tutorial.dline);

  -- Drop table.
  dbms_sql_tutorial.drop_table(:table_name);

  -- Print line break.
  dbms_output.put_line(dbms_sql_tutorial.dline);

END;
/
