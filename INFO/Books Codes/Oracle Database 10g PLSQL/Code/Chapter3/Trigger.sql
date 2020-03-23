/*
 * Trigger.sql
 * Chapter 3, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates the use of a trigger
 */

exec clean_schema.trigs
exec clean_schema.procs
exec clean_schema.tables

set feedback on
set pages 9999 serveroutput on size 1000000

CREATE TABLE authors (
  id         NUMBER PRIMARY KEY,
  first_name VARCHAR2(50),
  last_name  VARCHAR2(50)
);

INSERT INTO authors (id, first_name, last_name)
  VALUES (1, 'Marlene', 'Theriault');

INSERT INTO authors (id, first_name, last_name)
  VALUES (2, 'Rachel', 'Carmichael');

INSERT INTO authors (id, first_name, last_name)
  VALUES (3, 'James', 'Viscusi');

INSERT INTO authors (id, first_name, last_name)
  VALUES (4, 'Michael', 'Abbey');

INSERT INTO authors (id, first_name, last_name)
  VALUES (5, 'Michael', 'Corey');

INSERT INTO authors (id, first_name, last_name)
  VALUES (6, 'Scott', 'Urman');

INSERT INTO authors (id, first_name, last_name)
  VALUES (7, 'Ron', 'Hardman');

INSERT INTO authors (id, first_name, last_name)
  VALUES (8, 'Mike', 'McLaughlin');

COMMIT;

PROMPT
PROMPT ** This was the original record
PROMPT

SELECT id, first_name, last_name
FROM authors
WHERE last_name = 'HARDMAN';

PROMPT
PROMPT ** Create an AFTER UPDATE trigger on the AUTHORS table
PROMPT

CREATE OR REPLACE TRIGGER author_trig
   AFTER UPDATE OF first_name
   ON authors
   FOR EACH ROW
WHEN (OLD.first_name != NEW.first_name)
BEGIN
   DBMS_OUTPUT.PUT_LINE('First Name '
                        ||:OLD.first_name
                        ||' has change to '
                        ||:NEW.first_name);
END;
/

PROMPT
PROMPT ** Update the first_name column
PROMPT

UPDATE authors
SET first_name = 'Ronald'
WHERE first_name = 'Ron';
