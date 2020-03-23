/*
 * SQLFunctions.sql
 * Chapter 9, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates how stored functions can be called from SQL.
 */

-- This function meets the restrictions.
CREATE OR REPLACE FUNCTION FullName (
  p_AuthorID  authors.ID%TYPE)
  RETURN VARCHAR2 IS

  v_Result  VARCHAR2(100);
BEGIN
  SELECT first_name || ' ' || last_name
    INTO v_Result
    FROM authors
    WHERE ID = p_AuthorID;

  RETURN v_Result;
END FullName;
/

DELETE temp_table;

-- Because FullName meets all the restrictions, we can use it
-- in queries:
SELECT FullName(ID) full_name         
  FROM authors
  WHERE ID < 10
  ORDER BY full_name;
  
-- We can also use it in DML statements:
DECLARE
  CURSOR c_IDs IS
    SELECT ID FROM authors WHERE ID BETWEEN 10 AND 20;
BEGIN
  FOR v_Rec IN c_IDs LOOP
    INSERT INTO temp_table (num_col, char_col)
      VALUES (v_Rec.ID, FullName(v_Rec.ID));
  END LOOP;
END;
/

COLUMN char_col format a60
SELECT *
  FROM temp_table
  ORDER BY num_col;

-- Modify FullName to insert into temp_table
CREATE OR REPLACE FUNCTION FullName (
  p_AuthorID  authors.ID%TYPE)
  RETURN VARCHAR2 IS

  v_Result  VARCHAR2(100);
BEGIN
  SELECT first_name || ' ' || last_name
    INTO v_Result
    FROM authors
    WHERE ID = p_AuthorID;

  INSERT INTO temp_table (num_col, char_col)
    VALUES (p_AuthorID, 'called by FullName!');

  RETURN v_Result;
END FullName;
/

-- The same query will now raise an error.
SELECT FullName(ID) full_name         
  FROM authors
  WHERE ID < 10
  ORDER BY full_name;
