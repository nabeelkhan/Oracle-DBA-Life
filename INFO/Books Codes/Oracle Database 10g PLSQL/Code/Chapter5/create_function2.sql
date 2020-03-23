/*
 * create_function2.sql
 * Chapter 5, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates using an object type as a function return value.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

@create_record1.sql

-- An anonymous block program to ensure the primary key is not violated; and
-- an existing record structure is dropped from the database user's schema.
BEGIN
  -- Loop if a row is found and delete it.
  FOR i IN (SELECT   null
            FROM     user_types
            WHERE    type_name = 'INDIVIDUAL_ADDRESS_RECORD') LOOP

    EXECUTE IMMEDIATE 'DROP TYPE individual_address_record';
    COMMIT;

  END LOOP;

  -- Loop if a row is found and delete it.
  FOR i IN (SELECT   null
            FROM     user_types
            WHERE    type_name = 'INDIVIDUAL_RECORD') LOOP

    EXECUTE IMMEDIATE 'DROP TYPE individual_record';
    COMMIT;

  END LOOP;

END;
/

-- Create a database object type.
CREATE OR REPLACE TYPE individual_record AS OBJECT
  (individual_id  INTEGER
  ,first_name     VARCHAR2(30 CHAR)
  ,middle_initial VARCHAR2(1 CHAR)
  ,last_name      VARCHAR2(30 CHAR)
  ,CONSTRUCTOR FUNCTION individual_record
  (individual_id  INTEGER
  ,first_name     VARCHAR2
  ,middle_initial VARCHAR2
  ,last_name      VARCHAR2)
  RETURN SELF AS RESULT)
  INSTANTIABLE NOT FINAL;
/

show errors

-- Create a database object body.
CREATE OR REPLACE TYPE BODY individual_record AS
  CONSTRUCTOR FUNCTION individual_record
  (individual_id  INTEGER
  ,first_name     VARCHAR2
  ,middle_initial VARCHAR2
  ,last_name      VARCHAR2)
  RETURN SELF AS RESULT IS
  BEGIN
    self.individual_id := individual_id;
    self.first_name := first_name;
    self.middle_initial := middle_initial;
    self.last_name := last_name;
    RETURN;
  END;
END;
/

show errors


-- An anonymous block program to write the record to a row.
DECLARE

  -- Define a variable of the record type.
  individual INDIVIDUAL_RECORD;

  -- Define a local function to return a record type.
  FUNCTION get_row 
    (individual_id_in INTEGER)
  RETURN INDIVIDUAL_RECORD IS

    -- Define a cursor to return a row of individuals.
    CURSOR c
      (individual_id_cursor INTEGER) IS
      SELECT   *
      FROM     individuals
      WHERE    individual_id = individual_id_cursor;

  BEGIN

    -- Loop through the cursor for a single row.
    FOR i IN c(individual_id_in) LOOP

      -- Return a constructed object from the %ROWTYPE.
      RETURN   individual_record(i.individual_id
                                ,i.first_name
                                ,i.middle_initial
                                ,i.last_name);
    END LOOP;

  END get_row;

BEGIN

  -- Demonstrate function return variable assignment.
  individual := get_row(1);
  
  -- Display results.
  dbms_output.put_line(CHR(10));
  dbms_output.put_line('INDIVIDUAL_ID  : '||individual.individual_id);
  dbms_output.put_line('FIRST_NAME     : '||individual.first_name);
  dbms_output.put_line('MIDDLE_INITIAL : '||individual.middle_initial);
  dbms_output.put_line('LAST_NAME      : '||individual.last_name);

END;
/    
