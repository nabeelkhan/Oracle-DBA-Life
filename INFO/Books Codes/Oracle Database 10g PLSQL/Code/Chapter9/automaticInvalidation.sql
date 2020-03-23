/*
 * automaticInvalidation.sql
 * Chapter 9, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates the automatic invalidation of a subprogram.
 */

COLUMN object_name FORMAT a20

-- Both procedures should be valid when we start.
SELECT object_name, status
  FROM user_objects
  WHERE object_name IN ('THREEAUTHORS', 'RECORDTHREEAUTHORS');

-- Modify the books table with a DDL statement.
ALTER TABLE books MODIFY
  (title VARCHAR2(150)  -- Increase size of title column
);

-- Both procedures should now be invalid.
SELECT object_name, status
  FROM user_objects
  WHERE object_name IN ('THREEAUTHORS', 'RECORDTHREEAUTHORS');

-- But if we call RecordThreeAuthors, it should be automatically
-- recompiled.
BEGIN
  RecordThreeAuthors;
END;
/

-- Both procedures should now be valid.
SELECT object_name, status
  FROM user_objects
  WHERE object_name IN ('THREEAUTHORS', 'RECORDTHREEAUTHORS');
