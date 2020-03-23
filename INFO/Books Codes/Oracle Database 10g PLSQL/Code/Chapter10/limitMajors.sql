/*
 * limitMajors.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates user defined non-mutating trigger.
 */

SET ECHO ON

CREATE OR REPLACE TRIGGER LimitMajors
  /* Limits the number of students in each major to 5.
     If this limit is exceeded, an error is raised through
     raise_application_error. */
  BEFORE INSERT OR UPDATE OF major ON students
  FOR EACH ROW
DECLARE
  v_MaxStudents CONSTANT NUMBER := 5;
  v_CurrentStudents NUMBER;
BEGIN
  -- Determine the current number of students in this
  -- major.
  SELECT COUNT(*)
    INTO v_CurrentStudents
    FROM students
    WHERE major = :new.major;

  -- If there isn't room, raise an error.
  IF v_CurrentStudents + 1 > v_MaxStudents THEN
    RAISE_APPLICATION_ERROR(-20000, 
      'Too many students in major ' || :new.major);
  END IF;
END LimitMajors;
/

UPDATE students
SET major = 'History'
WHERE id = 1;
