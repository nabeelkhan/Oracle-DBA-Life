/*
 * dependencies.sql
 * Chapter 9, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates the behavior of dependent objects.
 */

COLUMN object_name FORMAT a20

-- First create a simple table.
CREATE TABLE simple_table (f1 NUMBER);

-- Now create a packaged procedure which references the table.
CREATE OR REPLACE PACKAGE Dependee AS
  PROCEDURE Example(p_Val IN NUMBER);
END Dependee;
/

CREATE OR REPLACE PACKAGE BODY Dependee AS
  PROCEDURE Example(p_Val IN NUMBER) IS
  BEGIN
     INSERT INTO simple_table VALUES (p_Val);
  END Example;
END Dependee;
/

-- Now create a procedure which references Dependee.
CREATE OR REPLACE PROCEDURE Depender(p_Val IN NUMBER) AS
BEGIN
  Dependee.Example(p_Val + 1);
END Depender;
/

-- Query user_objects to see that all objects are valid.
SELECT object_name, object_type, status
  FROM user_objects
  WHERE object_name IN ('DEPENDER', 'DEPENDEE',
                        'SIMPLE_TABLE');

-- Change the package body only.  Note that the header is
-- unchanged.
CREATE OR REPLACE PACKAGE BODY Dependee AS
  PROCEDURE Example(p_Val IN NUMBER) IS
  BEGIN
    INSERT INTO simple_table VALUES (p_Val - 1);
  END Example;
END Dependee;
/

-- Now user_objects shows that Depender is still valid.
SELECT object_name, object_type, status
  FROM user_objects
  WHERE object_name IN ('DEPENDER', 'DEPENDEE',
                        'SIMPLE_TABLE');

-- Even if we drop the table, it only invalidates the
-- package body.
DROP TABLE simple_table;

SELECT object_name, object_type, status
  FROM user_objects
  WHERE object_name IN ('DEPENDER', 'DEPENDEE',
                        'SIMPLE_TABLE');
