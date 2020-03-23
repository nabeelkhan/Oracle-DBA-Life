/*
 * DefaultPragma.sql
 * Chapter 9, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates default PRAGMA instructions.
 */

-- Available online as DefaultPragma.sql
CREATE OR REPLACE PACKAGE DefaultPragma AS
  FUNCTION F1 RETURN NUMBER;
  PRAGMA RESTRICT_REFERENCES(F1, RNDS, RNPS);

  PRAGMA RESTRICT_REFERENCES(DEFAULT, WNDS, WNPS, RNDS, RNPS);
  FUNCTION F2 RETURN NUMBER;

  FUNCTION F3 RETURN NUMBER;
END DefaultPragma;
/

show errors

CREATE OR REPLACE PACKAGE BODY DefaultPragma AS
  FUNCTION F1 RETURN NUMBER IS
  BEGIN
    INSERT INTO temp_table (num_col, char_col)
      VALUES (1, 'F1!');
    RETURN 1;
  END F1;

  FUNCTION F2 RETURN NUMBER IS
  BEGIN
    RETURN 2;
  END F2;

  -- This function violates the default pragma.
  FUNCTION F3 RETURN NUMBER IS
  BEGIN
    INSERT INTO temp_table (num_col, char_col)
      VALUES (1, 'F3!');
    RETURN 3;
  END F3;
END DefaultPragma;
/

show errors
