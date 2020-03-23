/*
 * LongToLob.sql
 * Chapter 16, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates the conversion of Longs
 *  to LOBs
 */

exec CLEAN_SCHEMA.TABLES
exec CLEAN_SCHEMA.OBJECTS
exec CLEAN_SCHEMA.PROCS

CREATE TABLE long_to_lob (
   id NUMBER,
   text LONG);

INSERT INTO long_to_lob (id, text)
VALUES (1, 'Change the column from LONG to CLOB');

COMMIT;

ALTER TABLE long_to_lob
MODIFY text CLOB;

DESC long_to_lob
