/*
 * create_assocarray5e.sql
 * Chapter 6, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates initialization and assignment with a numeric
 * index value to an associative array.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

DECLARE

  -- Define a varray of twelve variable length strings.
  TYPE months_varray IS VARRAY(12) OF STRING(9 CHAR);
   
  -- Define an associative array of variable length strings.
  TYPE calendar_table IS TABLE OF VARCHAR2(9 CHAR)
    INDEX BY VARCHAR2(9 CHAR);

  -- Declare and construct a varray.
  month MONTHS_VARRAY := 
    months_varray('January','February','March'
                 ,'April','May','June'
                 ,'July','August','September'
                 ,'October','November','December');

  -- Declare an associative array variable.
  calendar CALENDAR_TABLE;

BEGIN

  -- Check if calendar has no elements.
  IF calendar.COUNT = 0 THEN

    -- Print a title
    DBMS_OUTPUT.PUT_LINE('Assignment loop:');
    DBMS_OUTPUT.PUT_LINE('----------------');

    -- Loop through all the varray elements.
    FOR i IN month.FIRST..month.LAST LOOP

      -- Assign the numeric index valued varray element
      -- to an equal index valued associative array element.
      calendar(month(i)) := ''; --i;
 
      -- Print an indexed element from the associative array.
      DBMS_OUTPUT.PUT_LINE(
        'Index ['||month(i)||'] is ['||i||']');

    END LOOP;

    -- Print a title
    DBMS_OUTPUT.PUT(CHR(10));
    DBMS_OUTPUT.PUT_LINE('Post-assignment loop:');
    DBMS_OUTPUT.PUT_LINE('---------------------');

    -- Loop through all the associative array elements.
    FOR i IN calendar.FIRST..calendar.LAST LOOP

      -- Print an indexed element from the associative array.
      DBMS_OUTPUT.PUT_LINE(
        'Index ['||i||'] is ['||calendar(i)||']');

    END LOOP;

  END IF;

END;
/
