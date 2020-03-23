/*
 * nds_sql_01.sql
 * Chapter 13, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * Purpose:
 *   This is designed to test the Native Dynamic SQL package.
 */

-- Test block to create, increment and drop a sequence.
DECLARE

  -- Define local variables.
  value_in          VARCHAR2(30) := 'TESTING_S1';
  value_out         NUMBER;

BEGIN

  -- Break output stream.
  dbms_output.put_line(nds_tutorial.dline);

  -- Test create sequence.
  nds_tutorial.create_sequence(value_in);

  -- Break output stream.
  dbms_output.put_line(nds_tutorial.dline);

  -- Use for loop to increment sequence three times.
  FOR i IN 1..3 LOOP

    -- Increment sequence.
    nds_tutorial.increment_sequence(value_in,value_out);

    -- Break output stream.
    dbms_output.put_line(nds_tutorial.sline);

  END LOOP;

  -- Break output stream.
  dbms_output.put_line(nds_tutorial.dline);

  -- Drop the sequence.
  nds_tutorial.drop_sequence(value_in);

  -- Break output stream.
  dbms_output.put_line(nds_tutorial.dline);

END;
/
