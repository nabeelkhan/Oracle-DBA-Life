/*
 * firingOrder.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates user defined trigger sequencing.
 */

SET ECHO ON

BEGIN
  FOR i IN (SELECT   null
            FROM     user_sequences
            WHERE    sequence_name = 'trig_seq') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE trig_seq';
  END LOOP;
END;
/

CREATE SEQUENCE trig_seq
  START WITH 1
  INCREMENT BY 1;

CREATE OR REPLACE PACKAGE TrigPackage AS
  -- Global counter for use in the triggers
  v_Counter NUMBER;
END TrigPackage;
/
show errors

CREATE OR REPLACE TRIGGER BooksBStatement
  BEFORE UPDATE ON books
BEGIN
  -- Reset the counter first.
  TrigPackage.v_Counter := 0;
  
  INSERT INTO temp_table (num_col, char_col)
    VALUES (trig_seq.NEXTVAL,
      'Before Statement: counter = ' || TrigPackage.v_Counter);

  -- And now increment it for the next trigger.
  TrigPackage.v_Counter := TrigPackage.v_Counter + 1;
END BooksBStatement;
/
show errors

CREATE OR REPLACE TRIGGER BooksAStatement1
  AFTER UPDATE ON books
BEGIN
  INSERT INTO temp_table (num_col, char_col)
    VALUES (trig_seq.NEXTVAL,
      'After Statement 1: counter = ' || TrigPackage.v_Counter);

  -- Increment for the next trigger.
  TrigPackage.v_Counter := TrigPackage.v_Counter + 1;
END BooksAStatement1;
/
show errors

CREATE OR REPLACE TRIGGER BooksAStatement2
  AFTER UPDATE ON books
BEGIN
  INSERT INTO temp_table (num_col, char_col)
    VALUES (trig_seq.NEXTVAL,
      'After Statement 2: counter = ' || TrigPackage.v_Counter);

  -- Increment for the next trigger.
  TrigPackage.v_Counter := TrigPackage.v_Counter + 1;
END BooksAStatement2;
/
show errors

CREATE OR REPLACE TRIGGER BooksBRow1
  BEFORE UPDATE ON books
  FOR EACH ROW
BEGIN
  INSERT INTO temp_table (num_col, char_col)
    VALUES (trig_seq.NEXTVAL,
      'Before Row 1: counter = ' || TrigPackage.v_Counter);

  -- Increment for the next trigger.
  TrigPackage.v_Counter := TrigPackage.v_Counter + 1;
END BooksBRow1;
/
show errors

CREATE OR REPLACE TRIGGER BooksBRow2
  BEFORE UPDATE ON books
  FOR EACH ROW
BEGIN
  INSERT INTO temp_table (num_col, char_col)
    VALUES (trig_seq.NEXTVAL,
      'Before Row 2: counter = ' || TrigPackage.v_Counter);

  -- Increment for the next trigger.
  TrigPackage.v_Counter := TrigPackage.v_Counter + 1;
END BooksBRow2;
/
show errors

CREATE OR REPLACE TRIGGER BooksBRow3
  BEFORE UPDATE ON books
  FOR EACH ROW
BEGIN
  INSERT INTO temp_table (num_col, char_col)
    VALUES (trig_seq.NEXTVAL,
      'Before Row 3: counter = ' || TrigPackage.v_Counter);

  -- Increment for the next trigger.
  TrigPackage.v_Counter := TrigPackage.v_Counter + 1;
END BooksBRow3;
/
show errors

CREATE OR REPLACE TRIGGER BooksARow
  AFTER UPDATE ON books
  FOR EACH ROW
BEGIN
  INSERT INTO temp_table (num_col, char_col)
    VALUES (trig_seq.NEXTVAL,
      'After Row: counter = ' || TrigPackage.v_Counter);

  -- Increment for the next trigger.
  TrigPackage.v_Counter := TrigPackage.v_Counter + 1;
END BooksARow;
/
show errors

DELETE temp_table;

UPDATE books
  SET category = category
  WHERE category = 'Oracle Ebusiness';
  
SELECT *
  FROM temp_table
  ORDER BY num_col;
