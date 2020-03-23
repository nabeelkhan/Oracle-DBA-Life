/*
 * testTooManyMajors.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates a mutating violation.
 */

UPDATE students
SET major = 'History'
WHERE id IN (1,2,3);
