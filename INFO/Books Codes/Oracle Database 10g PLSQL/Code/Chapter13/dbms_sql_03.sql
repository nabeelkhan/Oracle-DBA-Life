/*
 * dbms_sql_03.sql
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

  -- Define a nested tables.
  TYPE card_number_table IS TABLE OF NUMBER
                            INDEX BY BINARY_INTEGER;
  TYPE card_name_table   IS TABLE OF VARCHAR2(2000)
                            INDEX BY BINARY_INTEGER;
  TYPE card_suit_table   IS TABLE OF VARCHAR2(2000)
                            INDEX BY BINARY_INTEGER;

  -- Declare and initialize a nested table with three rows.
  card_numbers CARD_NUMBER_TABLE;
  card_names   CARD_NAME_TABLE;
  card_suits   CARD_SUIT_TABLE;

  -- Define local variables.
  column_name1          VARCHAR2(30) := 'CARD_NUMBER';
  column_name2          VARCHAR2(30) := 'CARD_NAME';
  column_name3          VARCHAR2(30) := 'CARD_SUIT';
  table_name_in         VARCHAR2(30)   := 'CARD_DECK';
  table_definition_in   VARCHAR2(2000);
  table_column_value1   DBMS_SQL.NUMBER_TABLE;
  table_column_value2   DBMS_SQL.VARCHAR2_TABLE;
  table_column_value3   DBMS_SQL.VARCHAR2_TABLE;

BEGIN

  -- Assign table name to bind variable.
  :table_name   := table_name_in;
  :column_name1 := column_name1;
  :column_name2 := column_name2;
  :column_name3 := column_name3;

  -- Initialize the card numbers;
  FOR i IN 1..13 LOOP
    card_numbers(i) := i;
  END LOOP;

  -- Initialize the care names.
  card_names(1)  := 'Ace';
  card_names(2)  := 'Two';
  card_names(3)  := 'Three';
  card_names(4)  := 'Four';
  card_names(5)  := 'Five';
  card_names(6)  := 'Six';
  card_names(7)  := 'Seven';
  card_names(8)  := 'Eight';
  card_names(9)  := 'Nine';
  card_names(10) := 'Ten';
  card_names(11) := 'Jack';
  card_names(12) := 'Queen';
  card_names(13) := 'King';

  -- Initialize the care suits.
  card_suits(1)  := 'Spades';
  card_suits(2)  := 'Hearts';
  card_suits(3)  := 'Diamonds';
  card_suits(4)  := 'Clubs';
  card_suits(5)  := 'Spades';
  card_suits(6)  := 'Hearts';
  card_suits(7)  := 'Diamonds';
  card_suits(8)  := 'Clubs';
  card_suits(9)  := 'Spades';
  card_suits(10) := 'Hearts';
  card_suits(11) := 'Diamonds';
  card_suits(12) := 'Clubs';
  card_suits(13) := 'Spades';

  -- Assign card numbers in a for-loop.
  FOR i IN CARD_NUMBERS.FIRST..CARD_NUMBERS.LAST LOOP
    table_column_value1(i) := card_numbers(i);
  END LOOP;

  -- Assign card names in a for-loop.
  FOR i IN CARD_NAMES.FIRST..CARD_NAMES.LAST LOOP
    table_column_value2(i) := card_names(i);
  END LOOP;

  -- Assign card names in a for-loop.
  FOR i IN CARD_SUITS.FIRST..CARD_SUITS.LAST LOOP
    table_column_value3(i) := card_suits(i);
  END LOOP;

  -- Initialize table definition.
  table_definition_in := '('||column_name1||' NUMBER'        ||CHR(10)
                      || ','||column_name2||' VARCHAR2(2000)'||CHR(10)
                      || ','||column_name3||' VARCHAR2(2000))';

  -- Print the output.
  dbms_output.put_line(dbms_sql_tutorial.dline);
  dbms_sql_tutorial.create_table(table_name_in,table_definition_in);

  -- Insert into the table.
  dbms_output.put_line(dbms_sql_tutorial.dline);
  dbms_sql_tutorial.inserts_into_table( table_name_in
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
SELECT   card_number c1
,        card_name c2
,        card_suit c3
FROM     card_deck;

-- Use DBMS_SQL_TUTORIAL to drop the table.
BEGIN

  -- Run dynamic DQL against table.
  dbms_output.put_line(dbms_sql_tutorial.dline);
  dbms_sql_tutorial.multiple_row_return(:table_name
                                       ,:column_name1
                                       ,:column_name2
                                       ,:column_name3);
  dbms_output.put_line(dbms_sql_tutorial.dline);

  -- Drop table.
  dbms_output.put_line(dbms_sql_tutorial.dline);
  dbms_sql_tutorial.drop_table(:table_name);
  dbms_output.put_line(dbms_sql_tutorial.dline);

END;
/
