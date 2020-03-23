/
 * dbms_sql.sql
 * Chapter 13, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * Purpose:
 *   This is designed as a working tutorial of the Oracle
 *   Built-in DBMS_SQL with examples of the for key methods. 
 */

-- Set the SQL*PLUS environment for the script.
SET SERVEROUTPUT ON SIZE 1000000
SET ECHO OFF
SET FEEDBACK OFF
SET LINESIZE 90
SET PAGESIZE 0

--  Put package in log.
SELECT 'CREATE OR REPLACE PACKAGE dbms_sql_tutorial' FROM dual;

-- Create package specification.
CREATE OR REPLACE PACKAGE dbms_sql_tutorial AS

  /*
  || =========================================================================
  ||  SUMMARY:
  ||  -------
  ||  This is designed as a working tutorial of the Oracle Built-in DBMS_SQL 
  ||  with simple examples of different approaches.  Since the tutorial is
  ||  constructed as a single script with both the package specification
  ||  and body together, the detailed descriptive information is only
  ||  stated in the specification.
  ||
  ||  METHODS       DESCRIPTION                        PROGRAMS USED
  ||  -------       ------------------------------     -------------
  ||  Method 1      DDL and DML statements without     EXECUTE
  ||                any bind variables and no DQL.     OPEN_CURSOR
  ||                                                   PARSE
  ||
  ||  Method 2      DML statements with a fixed        BIND_VARIABLE
  ||                number of bind variables and       EXECUTE
  ||                no DQL.                            OPEN_CURSOR
  ||                                                   PARSE
  ||
  ||  Method 3      DQL (queries) with a fixed         BIND_VARIABLE
  ||                number of columns, the method      COLUMN_VALUE
  ||                used in lieu of implicit and       DEFINE_COLUMN
  ||                explicit cursors.                  EXECUTE
  ||                                                   FETCH_ROWS
  ||                                                   OPEN_CURSOR
  ||                                                   PARSE
  ||                                                   VARIABLE_VALUE
  ||
  ||  Method 4      DQL (queries) with a variable      BIND_VARIABLE
  ||                number of columns. The method      COLUMN_VALUE
  ||                does not know the number or        DEFINE_COLUMN
  ||                type of columns and bind           EXECUTE
  ||                variables.                         FETCH_ROWS
  ||                                                   OPEN_CURSOR
  ||                                                   PARSE
  ||                                                   VARIABLE_VALUE
  ||
  ||  PACKAGE CONTENTS:
  ||  ----------------
  ||  The package contents are broken down into global variables, functions
  ||  and procedures.  If the procedures exhibit a DBMS_SQL method, the 
  ||  method number is listed.
  ||
  ||  PROCEDURE NAME               METHOD  DESCRIPTION
  ||  --------------               ------  -----------
  ||  close_open_cursor                    Verifies a cursor is open before
  ||                                       running DBMS_SQL.CLOSE_CURSOR(c).
  ||
  ||  create_sequence                #1    Demonstrates a DDL (creation of
  ||                                       a sequence) by using concatenation.
  ||
  ||  create_table                   #1    Demonstrates a DDL (creation of
  ||                                       a table) by using concatenation.
  ||
  ||  drop_sequence                  #1    Demonstrates a DDL (deletion of
  ||                                       a sequence) by using concatenation.
  ||
  ||  drop_table                     #1    Demonstrates a DDL (dropping of
  ||                                       a table) by using concatenation.
  ||
  ||  insert_into_table              #2    Demonstrates a DML (insert) to
  ||                                       a table using ordered bind 
  ||                                       varialbes.
  ||
  ||  increment_sequence             #2    Demonstrates a variable returned
  ||                                       from a cursor through the use of
  ||                                       PLSQL structure SELECT-INTO.  The
  ||                                       SELECT-INTO is encapsulated in
  ||                                       PLSQL block and the value returned
  ||                                       by a bind variable construct.
  ||
  ||  multiple_row_return            #3    Demonstrates multiple row return
  ||                                       using the DEFINE_COLUMN and
  ||                                       COLUMN_VALUE program units, as
  ||                                       you would in an explicit cursor.
  ||
  ||  single_row_return              #3    Demonstrates single row return
  ||                                       using the DEFINE_COLUMN and
  ||                                       COLUMN_VALUE program units, as
  ||                                       you would in an explicit cursor.
  ||
  || 
  || ------------------------------------------------------------------------
  ||  Standard or conventional variable names in DBMS_SQL or elsewhere in
  ||  Oracle documentation, Oracle Press and O'Reilly book series.
  || ------------------------------------------------------------------------
  ||  <c>         is for the cursor passed to DBMS_SQL.
  ||  <fdbk>      is for the feedback integer from DBMS_SQL.EXECUTE or
  ||                                          from DBMS_SQL.EXECUTE_AND_FETCH
  ||  <retval>    is for return values in functions.
  ||  <statement> is for the SQL statement passed to DBMS_SQL
  || =========================================================================
  */

  -- Define formatting variables.
  dline               VARCHAR2(80) := 
   '============================================================';
  sline               VARCHAR2(80) := 
   '------------------------------------------------------------';

  -- Procedure to close DBMS_SQL open cursor.
  PROCEDURE close_open_cursor
    ( c                       IN OUT INTEGER);

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

  -- Procedure demonstrates a DML with ordered bind variables.
  PROCEDURE insert_into_table
    ( table_name              IN     VARCHAR2
    , table_column_value1     IN     NUMBER
    , table_column_value2     IN     VARCHAR2
    , table_column_value3     IN     VARCHAR2);

  -- Procedure demonstrates a DML with ordered bind variables.
  PROCEDURE inserts_into_table
    ( table_name              IN     VARCHAR2
    , table_column_values1    IN     DBMS_SQL.NUMBER_TABLE
    , table_column_values2    IN     DBMS_SQL.VARCHAR2_TABLE
    , table_column_values3    IN     DBMS_SQL.VARCHAR2_TABLE);

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

END dbms_sql_tutorial;
/

-- ==========================================================================
--  This is a debugging and log management technique for capturing the code
--  attempted to be compiled as a specification and then any error messages.
--  You would remark these out when your code is production ready and then
--  remove the remarking comments when debugging changes to your code.
-- ==========================================================================

SPOOL dbms_sql_spec.log

list

show errors

SPOOL OFF

--  Put package body in log.
SELECT 'CREATE OR REPLACE PACKAGE BODY dbms_sql_tutorial' FROM dual;

-- Create package body.
CREATE OR REPLACE PACKAGE BODY dbms_sql_tutorial IS

  /*
  || =========================================================================
  ||  SUMMARY:
  ||  -------
  ||  This is designed as a working tutorial of the Oracle Built-in DBMS_SQL 
  ||  with simple examples of different approaches.
  ||
  ||  This statement definition is used to point a developer to the package
  ||  specification for the detailed information. Since large packages are
  ||  easily difficult to navigate for maintenance programmers, a line 
  ||  break is used to separate procedures and functions.
  || =========================================================================
  */

  /*
  || ------------------------------------------------------------------
  */

  -- Procedure to close DBMS_SQL open cursor.
  PROCEDURE close_open_cursor
    ( c                       IN OUT INTEGER) IS

  BEGIN

    /*
    || If the cursor is open, then close it.
    */

    IF dbms_sql.is_open(c) THEN
      dbms_sql.close_cursor(c);
    END IF;

  END close_open_cursor;

  /*
  || ------------------------------------------------------------------
  */

  -- Procedure creates a sequence using concatenation.
  PROCEDURE create_sequence
    ( sequence_name           IN     VARCHAR2) IS

    -- Define local DBMS_SQL variables.
    c               INTEGER := dbms_sql.open_cursor;
    fdbk            INTEGER;
    statement       VARCHAR2(2000);

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

      -- Parse and execute the statement.
      dbms_sql.parse(c,statement,dbms_sql.native);
      fdbk := dbms_sql.execute(c);
  
      -- Close the open cursor.
      dbms_sql.close_cursor(c);

      -- Print module name message.
      dbms_output.put_line(
        '-> dbms_sql_tutorial.create_sequence');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print the output message.
      dbms_output.put_line(
        'Created Sequence <'||sequence_name||'>');

    ELSE

      -- Print module name message.
      dbms_output.put_line(
        '-> dbms_sql_tutorial.create_sequence');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print the output message.
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

    -- Define local DBMS_SQL variables.
    c                         INTEGER := dbms_sql.open_cursor;
    fdbk                      INTEGER;
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

      /*
      || Debugging Tip:
      || =============
      || Parse the statement, which reads the concatenated string in the
      || statement variable and execute the statement.  It is possible to
      || get an insufficient privileges error because the executing user
      || does not have "CREATE TABLE" privileges.  They can be granted
      || by SYS to the user/schema.  This  type of error occurs when the
      || schema executing the DDL has permissions via a role as opposed
      || to directly granted privileges.
      || -------------------------------------------------------------------
      ||   ORA-01031: insufficient privileges 
      */

      -- Parse and execute the statement.
      dbms_sql.parse(c,statement,dbms_sql.native);
      fdbk := dbms_sql.execute(c);
  
      -- Close the open cursor.
      dbms_sql.close_cursor(c);

      -- Print module name message.
      dbms_output.put_line(
        '-> dbms_sql_tutorial.create_table');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print the output message.
      dbms_output.put_line(
        'Created Table <'||table_name||'>');

    ELSE

      -- Print module name message.
      dbms_output.put_line(
        '-> dbms_sql_tutorial.create_table');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print the output message.
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

    -- Define local DBMS_SQL variables.
    c                         INTEGER := dbms_sql.open_cursor;
    fdbk                      INTEGER;
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

    -- If sequence exists delete it.
    IF verify_sequence(sequence_name) = TRUE THEN

      -- Build dynamic SQL statement.
      statement := 'DROP SEQUENCE '||sequence_name;

      -- Parse and execute the statement.
      dbms_sql.parse(c,statement,dbms_sql.native);
      fdbk := dbms_sql.execute(c);

      -- Close the open cursor.
      dbms_sql.close_cursor(c);

      -- Print module name message.
      dbms_output.put_line(
        '-> dbms_sql_tutorial.drop_sequence');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print output line.
      dbms_output.put_line(
        'Dropped Sequence <'||sequence_name||'>');

    ELSE

      -- Print module name message.
      dbms_output.put_line(
        '-> dbms_sql_tutorial.drop_sequence');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print output line.
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

    -- Define local DBMS_SQL variables.
    c                         INTEGER := dbms_sql.open_cursor;
    fdbk                      INTEGER;
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

      -- Parse and execute the statement.
      dbms_sql.parse(c,statement,dbms_sql.native);
      fdbk := dbms_sql.execute(c);

      -- Close the open cursor.
      dbms_sql.close_cursor(c);

      -- Print module name message.
      dbms_output.put_line('
        -> dbms_sql_tutorial.drop_table');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print output message.
      dbms_output.put_line(
        'Dropped Table <'||table_name||'>');

    ELSE

      -- Print module name message.
      dbms_output.put_line(
        '-> dbms_sql_tutorial.drop_table');

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

    -- Define local DBMS_SQL variables.
    c                         INTEGER := dbms_sql.open_cursor;
    fdbk                      INTEGER;
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

    IF verify_sequence(sequence_name) = TRUE THEN

      /*
      || Debugging Tip:
      || =============
      || When you are using a SELECT-INTO-FROM within DBMS_SQL, which is a
      || reserved PLSQL syntax not directly supported by DBMS_SQL.  You  
      || need to encapsulate it in a PLSQL wrapper.  When you use a PLSQL
      || wrapper, the semicolons must be used in the statement and the
      || PLSQL block because DBMS_SQL adds a single semicolon to execute
      || the PLSQL block.  If you forget to encapsulate the SQL in a
      || PLSQL wrapper, you will raise the following error message.
      || -------------------------------------------------------------------
      || ORA-01006: bind variable does not exist
      */

      -- Build dynamic SQL statement as anonymous block PL/SQL unit.
      statement := 'BEGIN'||CHR(10)
                || ' SELECT PLSQL.'||sequence_name||'.nextval'||CHR(10)
                || ' INTO   :retval'||CHR(10)
                || ' FROM   DUAL;'||CHR(10)
                || 'END;';

      -- Parse the statement.
      dbms_sql.parse(c,statement,dbms_sql.native);

      /*
      || Technical Note:
      || ==============
      || The BIND_VARIABLE procedure is returning a NUMBER
      || and does not require parameter four.
      */

      -- Bind variable retval to an output sequence value.
      dbms_sql.bind_variable(c,'retval',sequence_value);

      -- Execute the dynamic cursor.
      fdbk := dbms_sql.execute(c);

      -- Copy the variable value from the bind variable.
      dbms_sql.variable_value(c,'retval',sequence_value);

      -- Close the open cursor.
      dbms_sql.close_cursor(c);

      -- Print module name message.
      dbms_output.put(
        'Sequence <'||sequence_name||'> ');

      -- Print output message.
      dbms_output.put_line(
        'Value <'||sequence_value||'>');

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

  -- Procedure demonstrates a DML with ordered bind variables.
  PROCEDURE insert_into_table
    ( table_name              IN     VARCHAR2
    , table_column_value1     IN     NUMBER
    , table_column_value2     IN     VARCHAR2
    , table_column_value3     IN     VARCHAR2) IS

    -- Define local DBMS_SQL variables.
    c                         INTEGER := dbms_sql.open_cursor;
    fdbk                      INTEGER;
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

      /*
      || Debugging Tip:
      || =============
      || Statement strings are terminated by a line return CHR(10) to
      || ensure that a space is not missing between concatenated segments.
      || Using a BIND variable provides efficiencies in SQL statements
      || because it avoids the reparsing of the statement.  Therefore,
      || they should be used as follows for performance gains:
      ||
      ||   SQL STATEMENTS    PREDICATES
      ||   --------------    ----------
      ||   SELECT            WHERE
      ||   UPDATE            SET
      ||                     WHERE
      ||   DELETE            WHERE
      ||
      || Error Explanations:
      || ------------------
      || 1. An explicit size is always required for a VARCHAR2 variable
      ||    and the overloaded procedure has an output size variable in the
      ||    fourth position that you may need to use.  The output length is
      ||    provided below to demonstrate it.
      || 2. A bad bind variable message typically means the identifier is
      ||    outside of the VARCHAR2 string and treated as a session level
      ||    undefined bind variable.
      || 3. A "missing SELECT keyword" can occur on an insert statement
      ||    if you put bind variables into the INTO clause for column
      ||    names.
      || 4. If you have quote marks around VARCHAR2 bind variables, you
      ||    may raise the "bind variable does not exist" error.  If you
      ||    need to use that syntax, you can encapsulate the DML in a
      ||    PLSQL wrapper.
      || -------------------------------------------------------------------
      || 1. ORA-06502: PL/SQL: numeric or value error
      || 2. PLS-00049: bad bind variable
      || 3. ORA-00928: missing SELECT keyword
      || 4. ORA-01006: bind variable does not exist
      */

      -- Build dynamic SQL statement.
      statement := 'INSERT '
                || 'INTO '||table_name||' '
                || 'VALUES '
                || '( :table_column_value1'
                || ', :table_column_value2'
                || ', :table_column_value3)';

      -- Parse the statement.
      dbms_sql.parse(c,statement,dbms_sql.native);

      -- Bind each bind variable.
      dbms_sql.bind_variable(c,'table_column_value1',table_column_value1);
      dbms_sql.bind_variable(c,'table_column_value2',table_column_value2);
      dbms_sql.bind_variable(c,'table_column_value3',table_column_value3);

      -- Execute the dynamic statement.
      fdbk := dbms_sql.execute(c);

      -- Close the open cursor.
      dbms_sql.close_cursor(c);

      -- Commit the records.
      commit;

      -- Print module name message.
      dbms_output.put_line(
        '-> dbms_sql_tutorial.insert_into_table');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print output messages.
      dbms_output.put_line(
        'Value inserted <'||table_column_value1||'>');
      dbms_output.put_line(
        'Value inserted <'||table_column_value2||'>');
      dbms_output.put_line(
        'Value inserted <'||table_column_value3||'>');

    ELSE

      -- Print module name message.
      dbms_output.put_line(
        '-> dbms_sql_tutorial.insert_into_table');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print output message.
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
    , table_column_values1    IN     DBMS_SQL.NUMBER_TABLE
    , table_column_values2    IN     DBMS_SQL.VARCHAR2_TABLE
    , table_column_values3    IN     DBMS_SQL.VARCHAR2_TABLE) IS

    -- Define local DBMS_SQL variables.
    c                         INTEGER := dbms_sql.open_cursor;
    fdbk                      INTEGER;
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

      /*
      || Debugging Tip:
      || =============
      || Statement strings are terminated by a line return CHR(10) to
      || ensure that a space is not missing between concatenated segments.
      || Using a BIND variable provides efficiencies in SQL statements
      || because it avoids the reparsing of the statement.  Therefore,
      || they should be used as follows for performance gains:
      ||
      ||   SQL STATEMENTS    PREDICATES
      ||   --------------    ----------
      ||   SELECT            WHERE
      ||   UPDATE            SET
      ||                     WHERE
      ||   DELETE            WHERE
      ||
      || Error Explanations:
      || ------------------
      || 1. An explicit size is always required for a VARCHAR2 variable
      ||    and the overloaded procedure has an output size variable in the
      ||    fourth position that you may need to use.  The output length is
      ||    provided below to demonstrate it.
      || 2. A bad bind variable message typically means the identifier is
      ||    outside of the VARCHAR2 string and treated as a session level
      ||    undefined bind variable.
      || 3. A "missing SELECT keyword" can occur on an insert statement
      ||    if you put bind variables into the INTO clause for column
      ||    names.
      || 4. If you have quote marks around VARCHAR2 bind variables, you
      ||    may raise the "bind variable does not exist" error.  If you
      ||    need to use that syntax, you can encapsulate the DML in a
      ||    PLSQL wrapper.
      || -------------------------------------------------------------------
      || 1. ORA-06502: PL/SQL: numeric or value error
      || 2. PLS-00049: bad bind variable
      || 3. ORA-00928: missing SELECT keyword
      || 4. ORA-01006: bind variable does not exist
      */

      -- Build dynamic SQL statement.
      statement := 'INSERT '
                || 'INTO '||table_name||' '
                || '( card_number '
                || ', card_name '
                || ', card_suit)'
                || 'VALUES '
                || '( :card_number'
                || ', :card_name'
                || ', :card_suit)';

      -- Parse the statement.
      dbms_sql.parse(c,statement,dbms_sql.native);

      -- Bind each bind variable.
      dbms_sql.bind_array(c,'card_number',table_column_values1);
      dbms_sql.bind_array(c,'card_name',table_column_values2);
      dbms_sql.bind_array(c,'card_suit',table_column_values3);

      -- Execute the dynamic statement.
      fdbk := dbms_sql.execute(c);

      -- Print the number of rows inserted.
      dbms_output.put_line('Inserted ['||fdbk||'].');

      -- Close the open cursor.
      dbms_sql.close_cursor(c);

      -- Commit the records.
      commit;

      -- Print module name message.
      dbms_output.put_line('-> dbms_sql_tutorial.inserts_into_table');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Use a for-loop to print values.
      FOR i IN 1..table_column_values1.COUNT LOOP

        -- Print output message.
        dbms_output.put_line(
          'Value inserted <'||table_column_values1(i)||'>');
        dbms_output.put_line(
          'Value inserted <'||table_column_values2(i)||'>');
        dbms_output.put_line(
          'Value inserted <'||table_column_values3(i)||'>');

      END LOOP;

    ELSE

      -- Print module name message.
      dbms_output.put_line(
        '-> dbms_sql_tutorial.inserts_into_table');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print output message.
      dbms_output.put_line(
        'Object <'||table_name||'> does not exist');

    END IF;

  END inserts_into_table;

  /*
  || ------------------------------------------------------------------
  */

  -- Procedure demonstrates multiple row DQL.
  PROCEDURE multiple_row_return IS

    -- Define local DBMS_SQL variables.
    c                         INTEGER := dbms_sql.open_cursor;
    fdbk                      INTEGER;
    statement                 VARCHAR2(2000);
    value_out                 VARCHAR2(1);

  BEGIN

    -- Build dynamic SQL statement.
    statement := 'SELECT ''A'' FROM DUAL';

    -- Parse dynamic SQL statement.
    dbms_sql.parse(c,statement,dbms_sql.native);

    /*
    || Debugging Tip:
    || =============
    || Define the column values and DO NOT forget to assign a size
    || parameter for a string datatype, like VARCHAR2; however, if you
    || forget, the error message is:
    || -------------------------------------------------------------------
    || PLS-00307: too many declarations of 'DEFINE_COLUMN' match this call
    */

    -- Define the column mapping to the value_out variable.
    dbms_sql.define_column(c,1,value_out,1);

    -- Execute dynamic SQL statement.
    fdbk := dbms_sql.execute(c);

    -- Use a loop to read all rows.
    LOOP

      -- Exit when no more rows to fetch.
      EXIT WHEN dbms_sql.fetch_rows(c) = 0;

      -- Copy the contents of column #1 to the value_out variable.
      dbms_sql.column_value(c,1,value_out);

      -- Print module name message.
      dbms_output.put_line('-> dbms_sql_tutorial.multiple_row_return');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print output message.
      dbms_output.put_line('Value from COLUMN_VALUE <'||value_out||'>');

    END LOOP;

    -- Close the open cursor.
    dbms_sql.close_cursor(c);

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

    -- Define local DBMS_SQL variables.
    c                         INTEGER := dbms_sql.open_cursor;
    fdbk                      INTEGER;
    statement                 VARCHAR2(2000);
    cvalue_out1               VARCHAR2(2000);
    cvalue_out2               VARCHAR2(2000);
    nvalue_out                NUMBER;

  BEGIN

    -- Build dynamic SQL statement.
    statement := 'SELECT '
              ||  column_name1 ||','
              ||  column_name2 ||','
              ||  column_name3 ||' '
              || 'FROM '|| table_name;

    -- Parse dynamic SQL statement.
    dbms_sql.parse(c,statement,dbms_sql.native);

    /*
    || Debugging Tip:
    || =============
    || Define the column values and DO NOT forget to assign a size
    || parameter for a string datatype, like VARCHAR2; however, if you
    || forget, the error message is:
    || -------------------------------------------------------------------
    || PLS-00307: too many declarations of 'DEFINE_COLUMN' match this call
    */

    -- Define the column mapping to the value_out variable.
    dbms_sql.define_column(c,1,nvalue_out);
    dbms_sql.define_column(c,2,cvalue_out1,2000);
    dbms_sql.define_column(c,3,cvalue_out2,2000);

    -- Execute dynamic SQL statement.
    fdbk := dbms_sql.execute(c);

    -- Use a loop to read all rows.
    LOOP

      -- Exit when no more rows to fetch.
      EXIT WHEN dbms_sql.fetch_rows(c) = 0;

      -- Copy the contents of column #1 to the value_out variable.
      dbms_sql.column_value(c,1,nvalue_out);
      dbms_sql.column_value(c,2,cvalue_out1);
      dbms_sql.column_value(c,3,cvalue_out2);

      -- Print module name.
      dbms_output.put_line(
        '-> dbms_sql_tutorial.multiple_row_return');

      -- Print line break.
      dbms_output.put_line(sline);

      -- Print output message.
      dbms_output.put_line(
        'Value from ['||column_name1||'] '||
        'is: ['||nvalue_out||']');
      dbms_output.put_line(
        'Value from ['||column_name1||'] '||
        'is: ['||SUBSTR(cvalue_out1,1,5)||']');
      dbms_output.put_line(
        'Value from ['||column_name1||'] '||
        'is: ['||SUBSTR(cvalue_out2,1,8)||']');

    END LOOP;

    -- Close the open cursor.
    dbms_sql.close_cursor(c);

  END multiple_row_return;

  /*
  || ------------------------------------------------------------------
  */

  /*
  || Demonstrate a single row return using the DEFINE_COLUMN and COLUMN_VALUE
  || program unit, as you would in an explicit cursor.
  */
  -- Procedure single row DQL.
  PROCEDURE single_row_return IS

    -- Define local DBMS_SQL variables.
    c                         INTEGER := dbms_sql.open_cursor;
    fdbk                      INTEGER;
    statement                 VARCHAR2(2000);
    value_out                 VARCHAR2(1);

  BEGIN

    -- Build dynamic SQL statement.
    statement := 'SELECT ''A'' FROM DUAL';

    -- Parse the dynamic SQL statement.
    dbms_sql.parse(c,statement,dbms_sql.native);

    /*
    || Debugging Tip:
    || =============
    || Define the column values and DO NOT forget to assign a size
    || parameter for a string datatype, like VARCHAR2; however, if you
    || forget, the error message is:
    || -------------------------------------------------------------------
    || PLS-00307: too many declarations of 'DEFINE_COLUMN' match this call
    ||
    || This is the message returned because the DEFINE_COLUMN procedure 
    || is overloaded and it doesn't know how to implicitly cast without
    || the OUT_VALUE_SIZE argument. Only CHAR, RAW and VARCHAR2 support
    || a fourth argument.
    */

    -- Define the column mapping to the value_out variable.
    dbms_sql.define_column(c,1,value_out,1);

    -- Execute dynamic SQL statement.
    fdbk := dbms_sql.execute_and_fetch(c);

    -- Copy the contents of column #1 to the value_out variable.
    dbms_sql.column_value(c,1,value_out);

    -- Print module name message.
    dbms_output.put_line(
      '-> dbms_sql_tutorial.single_row_return');

    -- Print line break.
    dbms_output.put_line(sline);

    -- Print output message.
    dbms_output.put_line(
      'Value from COLUMN_VALUE <'||value_out||'>');

    -- Close the open cursor.
    dbms_sql.close_cursor(c);

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

    -- Define local DBMS_SQL variables.
    c                         INTEGER := dbms_sql.open_cursor;
    fdbk                      INTEGER;
    statement                 VARCHAR2(2000);
    cvalue_out1               VARCHAR2(20);
    cvalue_out2               VARCHAR2(30);
    nvalue_out                NUMBER;

  BEGIN

    -- Build dynamic SQL statement.
    statement := 'SELECT '
              ||  column_name1 ||','
              ||  column_name2 ||','
              ||  column_name3 ||' '
              || 'FROM '|| table_name;

    -- Parse the dynamic SQL statement.
    dbms_sql.parse(c,statement,dbms_sql.native);

    /*
    || Debugging Tip:
    || =============
    || Define the column values and DO NOT forget to assign a size
    || parameter for a string datatype, like VARCHAR2; however, if you
    || forget, the error message is:
    || -------------------------------------------------------------------
    || PLS-00307: too many declarations of 'DEFINE_COLUMN' match this call
    ||
    || This is the message returned because the DEFINE_COLUMN procedure 
    || is overloaded and it doesn't know how to implicitly cast without
    || the OUT_VALUE_SIZE argument. Only CHAR, RAW and VARCHAR2 support
    || a fourth argument.
    */

    -- Define the column mapping to the value_out variable.
    dbms_sql.define_column(c,1,nvalue_out);
    dbms_sql.define_column(c,2,cvalue_out1,20);
    dbms_sql.define_column(c,3,cvalue_out2,30);

    -- Execute dynamic SQL statement.
    fdbk := dbms_sql.execute_and_fetch(c);

    -- Copy the contents of column #1 to the value_out variable.
    dbms_sql.column_value(c,1,nvalue_out);
    dbms_sql.column_value(c,2,cvalue_out1);
    dbms_sql.column_value(c,3,cvalue_out2);

    -- Print module name message.
    dbms_output.put_line(
      '-> dbms_sql_tutorial.single_row_return');

    -- Print line break.
    dbms_output.put_line(sline);

    -- Print output message.
    dbms_output.put_line(
      'Value from COLUMN_VALUE <'||nvalue_out||'>');
    dbms_output.put_line(
      'Value from COLUMN_VALUE <'||cvalue_out1||'>');
    dbms_output.put_line(
      'Value from COLUMN_VALUE <'||cvalue_out2||'>');

    -- Close the open cursor.
    dbms_sql.close_cursor(c);

  END single_row_return;

  /*
  || ------------------------------------------------------------------
  */

END dbms_sql_tutorial;
/

-- ==========================================================================
--  This is a debugging and log management technique for capturing the code
--  attempted to be compiled as a specification and then any error messages.
--  You would remark these out when your code is production ready and then
--  remove the remarking comments when debugging changes to your code.
-- ==========================================================================

SPOOL dbms_sql_body.log

list

show errors

SPOOL OFF
