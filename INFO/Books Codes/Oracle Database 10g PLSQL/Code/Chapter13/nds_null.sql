/*
 * nds_null.sql
 * Chapter 13, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * Purpose:
 *   This is designed to demonstrate managing a null value.
 */

DECLARE

  -- Declare a variable and do not initialize it.
  null_value    VARCHAR2(1);

BEGIN

  -- Use NDS to select nothing into a bind variable.
  EXECUTE IMMEDIATE 'BEGIN SELECT null INTO :out FROM DUAL; END;'
  USING OUT null_value;

  -- Print the output message.
  dbms_output.put_line('Null is ['||null_value||']');

END;  
/  

