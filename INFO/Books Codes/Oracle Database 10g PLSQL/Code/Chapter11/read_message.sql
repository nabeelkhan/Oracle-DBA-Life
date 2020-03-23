/*
 * read_pipe.sql
 * Chapter 11, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script unpacks the local buffer.
*/

set serveroutput on size 1000000
DECLARE

  message VARCHAR2(30 CHAR) := NULL;
  success INTEGER;

BEGIN

  success := DBMS_PIPE.RECEIVE_MESSAGE('ORA$PIPE$00F3B7B50001',1);

  IF (success = 0) THEN
    DBMS_PIPE.UNPACK_MESSAGE(message);
  ELSE
    DBMS_OUTPUT.PUT_LINE('Error');
    message := TO_CHAR(success);
  END IF;

  DBMS_OUTPUT.PUT_LINE('Message ['||message||']');

END;
/
