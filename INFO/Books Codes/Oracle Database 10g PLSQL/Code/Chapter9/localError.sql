/*
 * localError.sql
 * Chapter 9, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates local subprograms must be last in the
 * declaration section.
 */

set serveroutput on

DECLARE
  /* Declare FormatName first. This will generate a compile
     error, since all other declarations have to be before
     any local subprograms. */
  FUNCTION FormatName(p_FirstName IN VARCHAR2,
                      p_LastName IN VARCHAR2)
    RETURN VARCHAR2 IS
  BEGIN
    RETURN p_FirstName || ' ' || p_LastName;
  END FormatName;

  CURSOR c_SomeAuthors IS
    SELECT first_name, last_name
      FROM authors
      WHERE last_name > 'L'
      ORDER BY last_name;

  v_FormattedName VARCHAR2(50);

-- Begin main block.
BEGIN
  FOR v_AuthorRecord IN c_SomeAuthors LOOP
    v_FormattedName :=
      FormatName(v_AuthorRecord.first_name,
                 v_AuthorRecord.last_name);
    DBMS_OUTPUT.PUT_LINE(v_FormattedName);
  END LOOP;
END;
/
