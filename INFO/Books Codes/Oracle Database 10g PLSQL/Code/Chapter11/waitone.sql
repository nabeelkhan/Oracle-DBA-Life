/*
 * waitone.sql
 * Chapter 11, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script waits for a DBMS_ALERT alert, which is
 * triggered on DML to the MESSAGES table.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

-- Call scripts that support this program.
@register_interest.sql

-- Register interest in an alert.
DECLARE

  -- Define OUT mode variables required from WAITONE.
  message        VARCHAR2(30 CHAR);
  status         INTEGER;

BEGIN

  -- Register interest in an alert.
  DBMS_ALERT.WAITONE('EVENT_MESSAGE_QUEUE'
                    ,message
                    ,status
                    ,30);

  IF (STATUS <> 0) THEN

    -- Print an error message.
    DBMS_OUTPUT.PUT_LINE('A timeout has happened.');

  ELSE

    -- Print title.
    DBMS_OUTPUT.PUT_LINE('Alert Messages Received');
    DBMS_OUTPUT.PUT_LINE('-----------------------');

    -- Print alert message received.
    DBMS_OUTPUT.PUT_LINE(message);

  END IF;

END;
/

-- Use SQL*Plus to format column.
COL message FORMAT A30

-- Select list of all messages sent.
SELECT * FROM messages_alerts;
