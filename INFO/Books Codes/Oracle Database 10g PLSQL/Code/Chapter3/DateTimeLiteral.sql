/*
 * DateTimeLiteral.sql
 * Chapter 3, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates Date/Time literals
 */


SET SERVEROUTPUT ON

DECLARE
   v_date DATE := DATE '2004-06-05';
   v_timestamp TIMESTAMP := TIMESTAMP '2004-06-05 22:14:01';
   v_timestamp_tz TIMESTAMP WITH TIME ZONE := TIMESTAMP '2004-06-05 22:14:01 +06:00';
   v_timestamp_ltz TIMESTAMP WITH LOCAL TIME ZONE := TIMESTAMP '2004-06-05 22:14:01';
BEGIN
   DBMS_OUTPUT.PUT_LINE(v_date);
   DBMS_OUTPUT.PUT_LINE(v_timestamp);
   DBMS_OUTPUT.PUT_LINE(v_timestamp_tz);
   DBMS_OUTPUT.PUT_LINE(v_timestamp_ltz);
END;
/

