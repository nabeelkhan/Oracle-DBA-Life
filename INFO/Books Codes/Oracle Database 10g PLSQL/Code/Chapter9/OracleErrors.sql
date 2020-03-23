/*
 * OracleErrors.sql
 * Chapter 9, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates the use of a pipelined table function.
 */

DROP TYPE OracleErrors;

CREATE OR REPLACE TYPE OracleError AS OBJECT (
  ErrNumber INTEGER,
  Message VARCHAR2(4000));
/

CREATE OR REPLACE TYPE OracleErrors AS TABLE OF OracleError;
/

-- Now we can create the function.  Note that we can use
-- the DETERMINISITIC keyword because the function will always
-- return the same output given the same input.  (It has no input,
-- so this is trivially true.)
CREATE OR REPLACE FUNCTION OracleErrorTable
  RETURN OracleErrors DETERMINISTIC PIPELINED
AS
  v_Low PLS_INTEGER := -65535;
  v_High PLS_INTEGER := 100;
  v_Message VARCHAR2(4000);
BEGIN
  FOR i IN v_Low..v_High LOOP
    -- Get the message for the given error number
    v_Message := SQLERRM(i);
    
    -- If it is legal, then output it.
    IF v_Message != ' -' || TO_CHAR(i) || ': non-ORACLE exception '
    AND v_Message != 'ORA' || TO_CHAR(i, '00000') || ': Message ' ||
        TO_CHAR(-i) || ' not found;  product=RDBMS; facility=ORA'
    THEN
      PIPE ROW(OracleError(i, v_Message));
    END IF;
  END LOOP;
  RETURN;
END;
/

CREATE OR REPLACE VIEW all_oracle_errors
  AS SELECT * FROM TABLE(OracleErrorTable());

desc all_oracle_errors
SELECT MIN(errnumber), MAX(errnumber), COUNT(*)
  FROM all_oracle_errors;


COLUMN message FORMAT a60  

SELECT *
  FROM all_oracle_errors
  WHERE errnumber BETWEEN -115 AND 100;
  
