/*
 * DbmsOutput.sql
 * Chapter 2, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates the DBMS_OUTPUT package
 */

exec clean_schema.tables

set feedback on
set pages 9999 serveroutput off

PROMPT
PROMPT ** Attempt to print a line of text to the screen
PROMPT

BEGIN
   DBMS_OUTPUT.PUT_LINE('Oh Beautiful for Spacious Skies...');
END;
/

PROMPT 
PROMPT ** The procedure completes, but it does not print the line
PROMPT **  Set the SERVEROUTPUT setting to ON and retry
PROMPT

set serveroutput on

/

