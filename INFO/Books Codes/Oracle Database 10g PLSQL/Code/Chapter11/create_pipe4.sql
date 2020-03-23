/*
 * create_pipe4.sql
 * Chapter 9, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script deletes a pipe if it exists in the context of the current
 * session, recreates a private pipe, sends a message and retrieves a message from the pipe.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

-- An anonymous block program to delete a pipe.
DECLARE

  -- Define and declare a variable by removing a pipe.
  retval INTEGER := DBMS_PIPE.REMOVE_PIPE('MESSAGE_INBOX');
  retval INTEGER := DBMS_PIPE.REMOVE_PIPE('MESSAGE_OUTBOX');

BEGIN

 NULL; 

END;
/

-- An anonymous block program to create a pipe.
DECLARE

  -- Define and declare variables.
  message_pipe_in   VARCHAR2(30) := 'MESSAGE_INBOX';
  message_pipe_out  VARCHAR2(30) := 'MESSAGE_OUTBOX';
  message_size      INTEGER      := 20000;
  message_flag      BOOLEAN      := FALSE;
   
  -- Function output variable.
  retval INTEGER;

  -- Define output variable.
  output VARCHAR2(4000 CHAR);

  -- Define custom exceptions.
  pipename_is_null  EXCEPTION;
  message_not_sized EXCEPTION;

  -- Define precompiler instructions for custom exceptions.
  PRAGMA EXCEPTION_INIT(pipename_is_null,-23321);
  PRAGMA EXCEPTION_INIT(message_not_sized,-6557);

  PROCEDURE print_status
    (pipename   VARCHAR2
    ,pipesize   INTEGER
    ,private    BOOLEAN DEFAULT TRUE
    ,value_in   INTEGER) IS
    
    -- Define a variable length string for Boolean.
    state       VARCHAR2(5 CHAR) := 'True';

  BEGIN

    -- Check boolean and change if not default.
    IF NOT private THEN
      state := 'False';
    END IF;

    -- Print the retval status.
    IF (value_in = 0) THEN
      DBMS_OUTPUT.PUT_LINE('Created successfully');
      DBMS_OUTPUT.PUT_LINE('Pipe Name ['||pipename||']');
      DBMS_OUTPUT.PUT_LINE('Pipe Size ['||pipesize||']');
      DBMS_OUTPUT.PUT_LINE('Private   ['||state   ||']');
      DBMS_OUTPUT.PUT(CHR(10));
    END IF;

  END print_status;

BEGIN

  -- Define a private pipe for inbound messages.
  retval := DBMS_PIPE.CREATE_PIPE(pipename    => message_pipe_in
                                 ,maxpipesize => message_size
                                 ,private     => message_flag);

  -- Print output value.
  print_status(message_pipe_in
              ,message_size
              ,message_flag
              ,retval);

  -- Define a private pipe for outbound messages.
  retval := DBMS_PIPE.CREATE_PIPE
              (pipename    => message_pipe_out
              ,maxpipesize => message_size
              ,private     => message_flag);

  -- Print output value.
  print_status(message_pipe_out
              ,message_size
              ,message_flag
              ,retval);

  -- Print the retval status.
  IF (retval = 0) THEN
    DBMS_OUTPUT.PUT(output);
  END IF;

EXCEPTION

  -- Raise when PIPENAME is null.
  WHEN pipename_is_null THEN
    DBMS_OUTPUT.PUT_LINE('No pipe name is defined.');
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    RETURN;

  -- Raise when MAXPIPESIZE is null.
  WHEN message_not_sized THEN
    DBMS_OUTPUT.PUT_LINE('A null cannot be the max size.');
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    RETURN;

  -- Raise generic exception.
  WHEN others THEN
    DBMS_OUTPUT.PUT_LINE('Another type of error.');
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    RETURN;

END;
/    

