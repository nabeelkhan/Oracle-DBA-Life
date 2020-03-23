/*
 * invokeRTA.sql
 * Chapter 9, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates invocation of RecordThreeAuthors package.
 */

BEGIN
  UserA.RecordThreeAuthors;
  COMMIT;
END;
/

