/*
 * CopyFast.sql
 * Chapter 8, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, and Scott Urman
 *
 * This package illustrates the possible speed benefits of NOCOPY.
 */
 
CREATE OR REPLACE PACKAGE CopyFast AS
  -- Associative array of books.
  TYPE BookArray IS
    TABLE OF books%ROWTYPE;

  -- Three procedures which take a parameter of BookArray, in
  -- different ways.  They each do nothing.
  PROCEDURE PassBooks1(p_Parameter IN BookArray);
  PROCEDURE PassBooks2(p_Parameter IN OUT BookArray);
  PROCEDURE PassBooks3(p_Parameter IN OUT NOCOPY BookArray);

  -- Test procedure.
  PROCEDURE Go;
END CopyFast;
/

CREATE OR REPLACE PACKAGE BODY CopyFast AS
  PROCEDURE PassBooks1(p_Parameter IN BookArray) IS
  BEGIN
    NULL;
  END PassBooks1;

  PROCEDURE PassBooks2(p_Parameter IN OUT BookArray) IS
  BEGIN
    NULL;
  END PassBooks2;

  PROCEDURE PassBooks3(p_Parameter IN OUT NOCOPY BookArray) IS
  BEGIN
    NULL;
  END PassBooks3;

  PROCEDURE Go IS
    v_BookArray BookArray := BookArray(NULL);
    v_Time1 NUMBER;
    v_Time2 NUMBER;
    v_Time3 NUMBER;
    v_Time4 NUMBER;
  BEGIN
    -- Fill up the array with 50,001 copies of a record.
    SELECT *
      INTO v_BookArray(1)
      FROM books
      WHERE ISBN = '72230665';
    v_BookArray.EXTEND(50000, 1);

    -- Call each version of PassBooks, and time them.
    -- DBMS_UTILITY.GET_TIME will return the current time, in
    -- hundredths of a second.
    v_Time1 := DBMS_UTILITY.GET_TIME;
    PassBooks1(v_BookArray);
    v_Time2 := DBMS_UTILITY.GET_TIME;
    PassBooks2(v_BookArray);
    v_Time3 := DBMS_UTILITY.GET_TIME;
    PassBooks3(v_BookArray);
    v_Time4 := DBMS_UTILITY.GET_TIME;

    -- Output the results.
    DBMS_OUTPUT.PUT_LINE('Time to pass IN: ' ||
                         TO_CHAR((v_Time2 - v_Time1) / 100));
    DBMS_OUTPUT.PUT_LINE('Time to pass IN OUT: ' ||
                         TO_CHAR((v_Time3 -   v_Time2) / 100));
    DBMS_OUTPUT.PUT_LINE('Time to pass IN OUT NOCOPY: ' ||
                         TO_CHAR((v_Time4 - v_Time3) / 100));
  END Go;
END CopyFast;
/

BEGIN
  CopyFast.Go();
END;
/
