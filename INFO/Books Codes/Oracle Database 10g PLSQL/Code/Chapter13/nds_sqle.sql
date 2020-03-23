/*
 * nds_sqle.sql
 * Chapter 13, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * Purpose:
 *   This is designed as a working tutorial of the Oracle
 *   Native Dynamic SQL (NDS) with an error in an OUT mode
 *   parameter. It will compile successfully and raise a
 *   runtime exception. 
 */

-- Set the SQL*PLUS environment for the script.
SET SERVEROUTPUT ON SIZE 1000000
SET ECHO OFF
SET FEEDBACK OFF
SET LINESIZE 90
SET PAGESIZE 0

@create_types.sql

--  Put package in log.
SELECT 'CREATE OR REPLACE PACKAGE nds_tutorial' FROM dual;

-- Create package specification.
CREATE OR REPLACE PACKAGE nds_tutorial AS

  -- Define formatting variables.
  dline               VARCHAR2(80) := 
   '============================================================';
  sline               VARCHAR2(80) := 
   '------------------------------------------------------------';

  -- Procedure creates a sequence using concatenation.
  PROCEDURE create_sequence
    ( sequence_name           IN     VARCHAR2);

  -- Procedure creates a table using concatenation.
  PROCEDURE create_table
    ( table_name              IN     VARCHAR2
    , table_definition        IN     VARCHAR2);

  -- Procedure drops a sequence using concatenation.
  PROCEDURE drop_sequence
    ( sequence_name           IN     VARCHAR2);

  -- Procedure drops table using concatenation.
  PROCEDURE drop_table
    ( table_name              IN     VARCHAR2);

  -- Procedure encapsulates a PL/SQL block SELECT-INTO.
  PROCEDURE increment_sequence
    ( sequence_name           IN     VARCHAR2
    , sequence_value          IN OUT NUMBER);

  -- Procedure demonstrates a DML without bind variables.
  PROCEDURE insert_into_table
    ( table_name              IN     VARCHAR2
    , table_column_value1     IN     NUMBER
    , table_column_value2     IN     VARCHAR2
    , table_column_value3     IN     VARCHAR2);

  -- Procedure demonstrates a DML with ordered bind variables.
  PROCEDURE inserts_into_table
    ( table_name              IN     VARCHAR2
    , table_column_value1     IN     NUMBER
    , table_column_value2     IN     VARCHAR2
    , table_column_value3     IN     VARCHAR2);

  -- Procedure demonstrates multiple row DQL.
  PROCEDURE multiple_row_return;

  -- Procedure demonstrates multiple row DQL.
  PROCEDURE multiple_row_return
    ( table_name    VARCHAR2
    , column_name1  VARCHAR2
    , column_name2  VARCHAR2
    , column_name3  VARCHAR2 );

  -- Procedure demonstrates single row DQL.
  PROCEDURE single_row_return;

  -- Procedure demonstrates single row DQL.
  PROCEDURE single_row_return
    ( table_name    VARCHAR2
    , column_name1  VARCHAR2
    , column_name2  VARCHAR2
    , column_name3  VARCHAR2 );

END nds_tutorial;
/

-- ==========================================================================
--  This is a debugging and log management technique for capturing the code
--  attempted to be compiled as a specification and then any error messages.
--  You would remark these out when your code is production ready and then
--  remove the remarking comments when debugging changes to your code.
-- ==========================================================================

SPOOL nds_tutorial_spec.log

list

show errors

SPOOL OFF

--  Put package body in log.
SELECT 'CREATE OR REPLACE PACKAGE BODY nds_tutorial' FROM dual;

-- Create package body.
CREATE OR REPLACE PACKAGE BODY nds_tutorial IS

  /*
  || =========================================================================
  ||  SUMMARY:
  ||  -------
  ||  This is designed as a working tutorial of the Oracle Native Dynamic
  ||  DBMS_SQL with simple examples of different approaches.
  || =========================================================================
  */

  /*
  || ------------------------------------------------------------------
  */

  -- Procedure creates a sequence using concatenation.
  PROCEDURE create_sequence
    ( sequence_name           IN     VARCHAR2) IS

    -- Define local variable.
    statement           VARCHAR2(2000);

    -- Define a local function to ensure sequence does not exist.
    FUNCTION verify_not_sequence
      ( sequence_name_in      IN     VARCHAR2)
    RETURN BOOLEAN IS

      -- Defines default return value.
      retval                  BOOLEAN := TRUE;

      -- Cursor returns a single row when finding a sequence.
      CURSOR find_sequence IS
        SELECT   null
        FROM     user_objects
        WHERE    object_name = sequence_name_in;
      
    BEGIN

      -- The for-loop sets the Boolean when a sequence is found.
      FOR i IN find_sequence LOOP
        retval := FALSE;
      END LOOP;

      -- Return Boolean state.
      RETURN retval;

    END verify_not_sequence;

  BEGIN

    -- If sequence does not exist create it.
    IF verify_not_sequence(sequence_name) = TRUE THEN 

      -- Build dynamic SQL statement.
      statement := 'CREATE SEQUENCE '||sequence_name||CHR(10)
                || '  INCREMENT BY   1'             ||CHR(10)
                || '  START WITH     1'             ||CHR(10)
                || '  CACHE          20'            ||CHR(10)
                || '  ORDER';

      -- Use NDS to run the statement.
      EXECUTE IMMEDIATE statement;

      -- Print successful output message.
      dbms_output.put_line(
        '-> nds_tutorial.create_sequence');

      -- Print output break.
      dbms_output.put_line(sline);

      -- Print sequence created.
      dbms_output.put_line(
        'Created Sequence <'||sequence_name||'>');

    ELSE

      -- Print module name output message.
      dbms_output.put_line(
        '-> nds_tutorial.create_sequence');

      -- Print output line break.
      dbms_output.put_line(sline);

      -- Print output message.
      dbms_output.put_line(
        'Sequence <'||sequence_name||'> already exists');

    END IF;

  END create_sequence;

  /*
  || ------------------------------------------------------------------
  */

  -- Procedure creates a table using concatenation.
  PROCEDURE create_table
    ( table_name              IN     VARCHAR2
    , table_definition        IN     VARCHAR2) IS

    -- Define local native dynamic SQL variables.
    statement                 VARCHAR2(2000);

    -- Define a local function to ensure table does not exist.
    FUNCTION verify_not_table
      ( object_name_in        IN     VARCHAR2)
    RETURN BOOLEAN IS

      -- Defines default return value.
      retval                  BOOLEAN := TRUE;

      -- Cursor returns a single row when finding a table.
      CURSOR find_object IS
        SELECT   null
        FROM     user_objects
        WHERE    object_name = object_name_in;
      
    BEGIN

      -- The for-loop sets the Boolean when a table is found.
      FOR i IN find_object LOOP
        retval := FALSE;
      END LOOP;

      -- Return Boolean state.
      RETURN retval;

    END verify_not_table;

  BEGIN

    -- If table does not exist create it.
    IF verify_not_table(table_name) = TRUE THEN 

      -- Build dynamic SQL statement.
      statement := 'CREATE TABLE '||table_name||CHR(10)
                || table_definition;

      -- Use NDS to run the statement.
      EXECUTE IMMEDIATE statement;

      -- Print module name message.
      dbms_output.put_line(
        '-> nds_tutorial.create_table');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print output message.
      dbms_output.put_line('Created Table <'||table_name||'>');

    ELSE

      -- Print module name message.
      dbms_output.put_line(
        '-> nds_tutorial.create_table');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print output message.
      dbms_output.put_line(
        'Object <'||table_name||'> already exists');

    END IF;

  END create_table;

  /*
  || ------------------------------------------------------------------
  */

  -- Procedure drops a sequence using concatenation.
  PROCEDURE drop_sequence
    ( sequence_name           IN     VARCHAR2) IS

    -- Define local variable.
    statement          VARCHAR2(2000);

    -- Define a local function to ensure sequence does not exist.
    FUNCTION verify_sequence
      ( sequence_name_in      IN     VARCHAR2)
    RETURN BOOLEAN IS

      -- Defines default return value.
      retval                  BOOLEAN := FALSE;

      -- Cursor returns a single row when finding a sequence.
      CURSOR find_sequence IS
        SELECT   null
        FROM     user_objects
        WHERE    object_name = sequence_name_in;
      
    BEGIN

      -- The for-loop sets the Boolean when a sequence is found.
      FOR i IN find_sequence LOOP
        retval := TRUE;
      END LOOP;

      -- Return Boolean state.
      RETURN retval;

    END verify_sequence;

  BEGIN

    -- If sequence exists delete it.
    IF verify_sequence(sequence_name) = TRUE THEN

      -- Build dynamic SQL statement.
      statement := 'DROP SEQUENCE '||sequence_name;

      -- Use NDS to run the statement.
      EXECUTE IMMEDIATE statement;

      -- Print module name message.
      dbms_output.put_line(
        '-> nds_tutorial.drop_sequence');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print the output message.
      dbms_output.put_line(
        'Dropped Sequence <'||sequence_name||'>');

    ELSE

      -- Print module name message.
      dbms_output.put_line(
        '-> nds_tutorial.drop_sequence');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print output message.
      dbms_output.put_line(
        'Sequence <'||sequence_name||'> does not exists');

    END IF;

  END drop_sequence;

  /*
  || ------------------------------------------------------------------
  */

  -- Procedure drops a table using concatenation.
  PROCEDURE drop_table
    ( table_name              IN     VARCHAR2) IS

    -- Define local variables.
    statement                 VARCHAR2(2000);

    -- Define a local function to ensure table does exist.
    FUNCTION verify_table
      ( object_name_in        IN     VARCHAR2)
    RETURN BOOLEAN IS

      -- Defines default return value.
      retval                  BOOLEAN := FALSE;

      -- Cursor returns a single row when finding a table.
      CURSOR find_object IS
        SELECT   null
        FROM     user_objects
        WHERE    object_name = object_name_in;
      
    BEGIN

      -- The for-loop sets the Boolean when a table is found.
      FOR i IN find_object LOOP
        retval := TRUE;
      END LOOP;

      -- Return Boolean state.
      RETURN retval;

    END verify_table;

  BEGIN

    IF verify_table(table_name) = TRUE THEN

      -- Build dynamic SQL statement.
      statement := 'DROP TABLE '||table_name;

      -- Execute DNS statement.
      EXECUTE IMMEDIATE statement;

      -- Print method output message.
      dbms_output.put_line(
        '-> nds_tutorial.drop_table');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print actual action.
      dbms_output.put_line(
        'Dropped Table <'||table_name||'>');

    ELSE

      -- Print failure output message.
      dbms_output.put_line(
        '-> nds_tutorial.drop_table');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print output message.
      dbms_output.put_line(
        'Object <'||table_name||'> does not exist');

    END IF;

  END drop_table;

  /*
  || ------------------------------------------------------------------
  */

  -- Procedure encapsulates a PL/SQL block SELECT-INTO.
  PROCEDURE increment_sequence
    ( sequence_name           IN     VARCHAR2
    , sequence_value          IN OUT NUMBER  ) IS

    -- Define local native dynamic SQL variables.
    statement                 VARCHAR2(2000);

    -- Define a local function to ensure sequence does not exist.
    FUNCTION verify_sequence
      ( sequence_name_in      IN     VARCHAR2)
    RETURN BOOLEAN IS

      -- Defines default return value.
      retval                  BOOLEAN := FALSE;

      -- Cursor returns a single row when finding a sequence.
      CURSOR find_sequence IS
        SELECT   null
        FROM     user_objects
        WHERE    object_name = sequence_name_in;
      
    BEGIN

      -- The for-loop sets the Boolean when a sequence is found.
      FOR i IN find_sequence LOOP
        retval := TRUE;
      END LOOP;

      -- Return Boolean state.
      RETURN retval;

    END verify_sequence;

  BEGIN

    -- Check if sequence already exists.
    IF verify_sequence(sequence_name) = TRUE THEN

      -- Build dynamic SQL statement as anonymous block PL/SQL unit.
      statement := 'BEGIN'                                 ||CHR(10)
                || '  SELECT   PLSQL.'||sequence_name||'.nextval'||CHR(10)
                || '  INTO     :retval'                    ||CHR(10)
                || '  FROM     DUAL;'                      ||CHR(10)
                || 'END;';

      -- Execute dynamic SQL statement.
      EXECUTE IMMEDIATE statement
        USING OUT sequence_value; 

      -- Print module name message.
      dbms_output.put_line(
        '-> nds_tutorial.increment_sequence');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print output message.
      dbms_output.put     ('Sequence <'||sequence_name||'> ');
      dbms_output.put_line('Value <'||sequence_value||'>');

    ELSE

      -- Print module name message.
      dbms_output.put_line(
        '-> dbms_sql_tutorial.increment_sequence');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print output message.
      dbms_output.put_line(
        'Sequence <'||sequence_name||'> does not exist');

    END IF;

  END increment_sequence;

  /*
  || ------------------------------------------------------------------
  */

  -- Procedure demonstrates a DML without bind variables.
  PROCEDURE insert_into_table
    ( table_name              IN     VARCHAR2
    , table_column_value1     IN     NUMBER
    , table_column_value2     IN     VARCHAR2
    , table_column_value3     IN     VARCHAR2) IS

    -- Define local variables.
    statement                 VARCHAR2(2000);

    -- Define a local function to ensure table does exist.
    FUNCTION verify_table
      ( object_name_in        IN     VARCHAR2)
    RETURN BOOLEAN IS

      -- Defines default return value.
      retval                  BOOLEAN := FALSE;

      -- Cursor returns a single row when finding a table.
      CURSOR find_object IS
        SELECT   null
        FROM     user_objects
        WHERE    object_name = object_name_in;
      
    BEGIN

      -- The for-loop sets the Boolean when a table is found.
      FOR i IN find_object LOOP
        retval := TRUE;
      END LOOP;

      -- Return Boolean state.
      RETURN retval;

    END verify_table;

  BEGIN

    -- If table exists insert into it.
    IF verify_table(table_name) = TRUE THEN

      -- Build dynamic SQL statement.
      statement := 'INSERT '
                || 'INTO '||table_name||' '
                || 'VALUES ('
                || ''''||table_column_value1||''','
                || ''''||table_column_value2||''','
                || ''''||table_column_value3||''')';

      -- Execute the NDS statement.
      EXECUTE IMMEDIATE statement;

      -- Commit the records.
      commit;

      -- Print module name output message.
      dbms_output.put_line(
        '-> nds_tutorial.insert_into_table');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print data output.
      dbms_output.put_line(
        'Value inserted <'||table_column_value1||'>');
      dbms_output.put_line(
        'Value inserted <'||table_column_value2||'>');
      dbms_output.put_line(
        'Value inserted <'||table_column_value3||'>');

    ELSE

      -- Print module name output message.
      dbms_output.put_line(
        '-> nds_tutorial.insert_into_table');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print error output message.
      dbms_output.put_line(
        'Object <'||table_name||'> does not exist');

    END IF;

  END insert_into_table;

  /*
  || ------------------------------------------------------------------
  */

  -- Procedure demonstrates a DML with ordered bind variables.
  PROCEDURE inserts_into_table
    ( table_name              IN     VARCHAR2
    , table_column_value1     IN     NUMBER
    , table_column_value2     IN     VARCHAR2
    , table_column_value3     IN     VARCHAR2) IS

    -- Define local variables.
    statement                 VARCHAR2(2000);

    -- Define a local function to ensure table does exist.
    FUNCTION verify_table
      ( object_name_in        IN     VARCHAR2)
    RETURN BOOLEAN IS

      -- Defines default return value.
      retval                  BOOLEAN := FALSE;

      -- Cursor returns a single row when finding a table.
      CURSOR find_object IS
        SELECT   null
        FROM     user_objects
        WHERE    object_name = object_name_in;
      
    BEGIN

      -- The for-loop sets the Boolean when a table is found.
      FOR i IN find_object LOOP
        retval := TRUE;
      END LOOP;

      -- Return Boolean state.
      RETURN retval;

    END verify_table;

  BEGIN

    -- If table exists insert into it.
    IF verify_table(table_name) = TRUE THEN

      -- Build dynamic SQL statement.
      statement := 'INSERT '
                || 'INTO '||table_name||' '
                || 'VALUES (:col_one, :col_two, :col_three)';

      -- Execute the NDS statement.
      EXECUTE IMMEDIATE statement
        USING table_column_value1
        ,     table_column_value2
        ,     table_column_value3;

      -- Commit the records.
      commit;

      -- Print module name output message.
      dbms_output.put_line(
        '-> nds_tutorial.insert_into_table');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print data output.
      dbms_output.put_line(
        'Value inserted <'||table_column_value1||'>');
      dbms_output.put_line(
        'Value inserted <'||table_column_value2||'>');
      dbms_output.put_line(
        'Value inserted <'||table_column_value3||'>');

    ELSE

      -- Print module name output message.
      dbms_output.put_line(
        '-> nds_tutorial.insert_into_table');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print error output message.
      dbms_output.put_line(
        'Object <'||table_name||'> does not exist');

    END IF;

  END inserts_into_table;

  /*
  || ------------------------------------------------------------------
  */

  -- Procedure demonstrates multiple row DQL.
  PROCEDURE multiple_row_return IS

    -- Define local variables.
    statement                 VARCHAR2(2000);
    value_out                 VARCHAR2_TABLE1;

  BEGIN

    -- Build dynamic SQL statement.
    statement := 'BEGIN '
              || 'SELECT ''A'' '
              || 'BULK COLLECT INTO :col_val '
              || 'FROM DUAL;'
              || 'END;';

    -- Use Bulk NDS to query a static string.
      EXECUTE IMMEDIATE statement
        USING OUT value_out;

      -- Print module name message.
      dbms_output.put_line(
        '-> nds_tutorial.multiple_row_return');

      -- Print line break.
      dbms_output.put_line(sline);

    -- Use a range loop to read the values.
    FOR i IN 1..value_out.COUNT LOOP

      -- Print output message.
      dbms_output.put_line(
        'Value from COLUMN_VALUE <'||value_out(i)||'>');

    END LOOP;

  END multiple_row_return;

  /*
  || ------------------------------------------------------------------
  */

  -- Procedure demonstrates multiple row with columns DQL.
  PROCEDURE multiple_row_return
    ( table_name    VARCHAR2
    , column_name1  VARCHAR2
    , column_name2  VARCHAR2
    , column_name3  VARCHAR2 )IS

    -- Define local Native Dynamic SQL variables.
    statement                 VARCHAR2(2000);
    cvalue_out1               CARD_NAME_VARRAY;
    cvalue_out2               CARD_SUIT_VARRAY;
    nvalue_out                CARD_NUMBER_VARRAY;

  BEGIN

    -- Build dynamic SQL statement.
    statement := 'BEGIN '
              || 'SELECT '
              ||  column_name1 ||','
              ||  column_name2 ||','
              ||  column_name3 ||' '
              || 'BULK COLLECT INTO :col1, :col2, :col3 '
              || 'FROM '|| table_name ||';'
              || 'END;';

    -- Execute native dynamic SQL.
    EXECUTE IMMEDIATE statement
      USING OUT nvalue_out, OUT cvalue_out1, cvalue_out2;

      -- Print module name message.
      dbms_output.put_line('-> nds_tutorial.multiple_row_return');

      -- Print line break.
      dbms_output.put_line(sline);

      FOR i IN 1..nvalue_out.COUNT LOOP

        -- Print data output.
        dbms_output.put_line(
          'Value from ['||column_name1||'] '||
          'is: ['||nvalue_out(i)||']');
        dbms_output.put_line(
          'Value from ['||column_name1||'] '||
          'is: ['||SUBSTR(cvalue_out1(i),1,20)||']');
        dbms_output.put_line(
          'Value from ['||column_name1||'] '||
          'is: ['||SUBSTR(cvalue_out2(i),1,30)||']');

      END LOOP;

  END multiple_row_return;

  /*
  || ------------------------------------------------------------------
  */

  -- Procedure single row DQL.
  PROCEDURE single_row_return IS

    -- Define local variables.
    statement                 VARCHAR2(2000);
    value_out                 VARCHAR2(1);

  BEGIN

    -- Build dynamic SQL statement.
    statement := 'SELECT ''A'' FROM DUAL';

    -- Use NDS to query a static string.
    EXECUTE IMMEDIATE statement
      INTO value_out;

    -- Print module name message.
    dbms_output.put_line('-> nds_tutorial.single_row_return');

    -- Print line break.
    dbms_output.put_line(sline);

    -- Print output message.
    dbms_output.put_line('Value from COLUMN_VALUE <'||value_out||'>');

  END single_row_return;

  /*
  || ------------------------------------------------------------------
  */

  -- Procedure demonstrates single row DQL.
  PROCEDURE single_row_return
    ( table_name    VARCHAR2
    , column_name1  VARCHAR2
    , column_name2  VARCHAR2
    , column_name3  VARCHAR2 ) IS

    -- Define local variables.
    statement                 VARCHAR2(2000);
    cvalue_out1               VARCHAR2(20);
    cvalue_out2               VARCHAR2(30);
    nvalue_out                NUMBER;

  BEGIN

    -- Build dynamic SQL statement.
    statement := 'SELECT '
              || column_name1 ||','
              || column_name2 ||','
              || column_name3 ||' '
              || 'FROM '|| table_name;

    EXECUTE IMMEDIATE statement
      INTO nvalue_out, cvalue_out1, cvalue_out2;

    -- Print module name message.
    dbms_output.put_line('-> nds_tutorial.single_row_return');

    -- Print line break.
    dbms_output.put_line(sline);

    -- Print data output.
    dbms_output.put_line(
      'Value from COLUMN_VALUE <'||nvalue_out||'>');
    dbms_output.put_line(
      'Value from COLUMN_VALUE <'||cvalue_out1||'>');
    dbms_output.put_line(
      'Value from COLUMN_VALUE <'||cvalue_out2||'>');

  END single_row_return;

  /*
  || ------------------------------------------------------------------
  */

END nds_tutorial;
/

-- ==========================================================================
--  This is a debugging and log management technique for capturing the code
--  attempted to be compiled as a specification and then any error messages.
--  You would remark these out when your code is production ready and then
--  remove the remarking comments when debugging changes to your code.
-- ==========================================================================

SPOOL nds_tutorial_body.log

list

show errors

SPOOL OFF
