/*
 * create_pipe1.sql
 * Chapter 11, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script deletes a pipe if it exists in the context of the current
 * session, then recreates it.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

-- An anonymous block program to delete a pipe.
DECLARE

  -- Define and declare a variable by removing a pipe.
  retval INTEGER := DBMS_PIPE.REMOVE_PIPE('PLSQL$MESSAGE_INBOX');

BEGIN

 NULL; 

END;
/

-- An anonymous block program to create a pipe.
DECLARE

  -- Define and declare variables.
  message_pipe VARCHAR2(30) := 'PLSQL$MESSAGE_INBOX';
  message_size INTEGER      := 20000;
   
  -- Function output variable.
  retval INTEGER;

BEGIN

  -- Define a private pipe.
  retval := DBMS_PIPE.CREATE_PIPE(message_pipe
                                 ,message_size);

  -- Print the retval status.
  IF (retval = 0) THEN
    DBMS_OUTPUT.PUT_LINE('MESSAGE_INBOX pipe is created.');
  END IF;

EXCEPTION

  -- Raise generic exception.
  WHEN others THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    RETURN;

END;
/    

