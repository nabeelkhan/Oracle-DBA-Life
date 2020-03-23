/*
 * DatabaseSchema2.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates user defined trigger testing.
 */

connect UserA/UserA
connect UserB/UserB
connect example/example

COL num_col FORMAT 99
COL char_col FORMAT A50

SELECT * FROM temp_table;

connect UserA/UserA
ALTER TRIGGER LogUserAConnects DISABLE;

connect UserB/UserB
ALTER TRIGGER LogUserBConnects DISABLE;

connect example/example
ALTER TRIGGER LogAllConnects DISABLE;

DELETE temp_table;

COMMIT;
