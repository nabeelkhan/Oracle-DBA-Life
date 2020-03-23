/*
 * StringLiteral.sql
 * Chapter 3, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates the different ways in which 10g handles
 *  apostrophes.
 */

exec clean_schema.trigs
exec clean_schema.procs
exec clean_schema.tables

SET SERVEROUTPUT ON

PROMPT
PROMPT ** The following block throws an exception
PROMPT

BEGIN
   DBMS_OUTPUT.PUT_LINE('Colorado's National Parks are BEAUTIFUL');
END;
/

PROMPT
PROMPT ** Using two single-quotes print the string correctly
PROMPT

BEGIN
   DBMS_OUTPUT.PUT_LINE('Colorado''s National Parks are BEAUTIFUL');
END;
/

PROMPT
PROMPT ** New quoting syntax is q'[ ... ]' where the [] is the user-defined
PROMPT **  delimiter.  The [] can be any character not present in the string
PROMPT **  literal.
PROMPT


BEGIN
   DBMS_OUTPUT.PUT_LINE('Colorado''s National Parks are BEAUTIFUL');
   DBMS_OUTPUT.PUT_LINE(q'!Colorado's National Parks are BEAUTIFUL!');
   DBMS_OUTPUT.PUT_LINE(q'[Colorado's National Parks are BEAUTIFUL]');
   DBMS_OUTPUT.PUT_LINE(q'<Colorado's National Parks are BEAUTIFUL>');
   DBMS_OUTPUT.PUT_LINE(q'%Colorado's National Parks are BEAUTIFUL%');
END;
/
