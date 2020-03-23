/*
 * dbms_sql_01.sql
 * Chapter 13, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * Purpose:
 *   This is designed to test the DBMS_SQL_TUTORIAL package.
 */

-- Test block to create, increment and drop a sequence.
DECLARE

  -- Define local variables.
  value_in          VARCHAR2(30) := 'TESTING_S1';
  value_out         NUMBER;

BEGIN

  -- Break output stream.
  dbms_output.put_line(dbms_sql_tutorial.dline);

  -- Test create sequence.
  dbms_sql_tutorial.create_sequence(value_in);

  -- Break output stream.
  dbms_output.put_line(dbms_sql_tutorial.dline);

  -- Loop six times.
  FOR i IN 1..3 LOOP

    -- Test increment_sequence procedure.
    dbms_sql_tutorial.increment_sequence(value_in,value_out);

  END LOOP;

  -- Print line break.
  dbms_output.put_line(dbms_sql_tutorial.dline);

  -- Drop the sequence.
  dbms_sql_tutorial.drop_sequence(value_in);

  -- Print line break.
  dbms_output.put_line(dbms_sql_tutorial.dline);

END;
/
