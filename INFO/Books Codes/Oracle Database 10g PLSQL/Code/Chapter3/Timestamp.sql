/*
 * Timestamp.sql
 * Chapter 3, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates the TIMESTAMP datatypes
 */

exec clean_schema.trigs
exec clean_schema.procs
exec clean_schema.tables

SET SERVEROUTPUT ON

PROMPT
PROMPT ** The TIMESTAMP datatype stores the date/time as follows:
PROMPT

DECLARE
   v_datetime TIMESTAMP := SYSTIMESTAMP;
BEGIN
   DBMS_OUTPUT.PUT_LINE(v_datetime);
END;
/


PROMPT
PROMPT ** The TIMESTAMP WITH TIME ZONE datatype stores the date/time
PROMPT **  slightly different:
PROMPT

DECLARE
   v_datetime TIMESTAMP (3) WITH TIME ZONE := SYSTIMESTAMP;
BEGIN
   DBMS_OUTPUT.PUT_LINE(v_datetime);
END;
/


PROMPT
PROMPT ** The TIMESTAMP WITH LOCAL TIME ZONE datatype stores the date/time
PROMPT **  slightly different:
PROMPT

DECLARE
   v_datetime TIMESTAMP (0) WITH LOCAL TIME ZONE := SYSTIMESTAMP;
BEGIN
   DBMS_OUTPUT.PUT_LINE(v_datetime);
END;
/


