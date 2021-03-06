/*
 * testNonMutating.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script tests non-mutating properties.
 */

-- Test non-mutating properties.
UPDATE students
SET major = 'History'
WHERE id IN (1,2,3);
