/*
 * Reserved.sql
 * Chapter 3, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script prints a list of reserved words
 */

exec clean_schema.trigs
exec clean_schema.procs
exec clean_schema.tables

SET PAGES 9999

PROMPT
PROMPT ** Reserved words **
PROMPT

COL keyword FORMAT A30

SELECT keyword, length
FROM v_$reserved_words
WHERE (length > 1
OR keyword = 'A')
AND keyword != '<<'
ORDER BY keyword;

PROMPT
PROMPT
PROMPT ** Special Characters **
PROMPT

SELECT keyword
FROM v_$reserved_words
WHERE length = 1
AND keyword != 'A'
OR keyword = '<<';
