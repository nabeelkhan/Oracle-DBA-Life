/*
 * LockSession2.sql
 * Chapter 4, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates how transactions use locks, commits, and rollbacks
 *  This script is for the second session as noted in the book.
 */


PROMPT
PROMPT
PROMPT ** Query the AUTHORS table to see if the change from session 1 can be seen
PROMPT

SELECT first_name
FROM authors
WHERE id = 44;

PROMPT
PROMPT
PROMPT ** Try updating the same record from this session - IT SHOULD HANG
PROMPT

UPDATE authors
SET first_name = 'Ronald'
WHERE id = 44;
