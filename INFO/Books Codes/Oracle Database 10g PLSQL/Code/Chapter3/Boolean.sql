/*
 * Boolean.sql
 * Chapter 3, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates how to assign a value to a variable of type boolean
 */

exec clean_schema.trigs
exec clean_schema.procs
exec clean_schema.tables

-- Don't use quotes around the value like this

DECLARE
   v_boolean BOOLEAN;
BEGIN
   v_boolean := 'TRUE';
END;
/


-- Instead, do this

DECLARE
   v_boolean BOOLEAN;
BEGIN
   v_boolean := TRUE;
END;
/