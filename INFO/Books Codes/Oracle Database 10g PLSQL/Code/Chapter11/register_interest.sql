/*
 * register_interest.sql
 * Chapter 11, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script registers interest in a DBMS_ALERT
 * to the MESSAGES table.
 */

-- Remove your registered interest in a DBMS_ALERT.
BEGIN

  -- Remove/deregister interest from an alert.
  DBMS_ALERT.REMOVE('EVENT_MESSAGE_QUEUE');

END;
/

-- Call signal trigger, which also builds the table.
@create_signal_trigger.sql

-- Register interest in an alert.
BEGIN

  -- Register interest in an alert.
  DBMS_ALERT.REGISTER('EVENT_MESSAGE_QUEUE');

END;
/
