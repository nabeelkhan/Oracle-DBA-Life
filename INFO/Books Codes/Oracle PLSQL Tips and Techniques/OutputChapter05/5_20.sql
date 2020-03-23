-- ***************************************************************************
-- File: 5_20.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_20.lis

CREATE OR REPLACE PROCEDURE recompile_all_objects IS
-- Compiles all objects under the current schema by executing this
-- procedure once.
-- The schema creating this procedure must be granted SELECT privilege
-- directly to the USER_OBJECTS view (not through a role).
   -- Fetches INVALID stored PL/SQL program units
   CURSOR cur_objects_invalid IS 
      SELECT object_id, object_name, object_type
      FROM   user_objects
      WHERE  status      = 'INVALID'
      AND    object_type IN ('PACKAGE', 'PACKAGE BODY',
                             'FUNCTION', 'PROCEDURE', 'TRIGGER')
      ORDER BY object_type, object_name;
   -- Queries PL/SQL program unit compiled to ensure it was successful
   CURSOR cur_objects_valid (p_object_id_num NUMBER) IS
      SELECT 'FOUND'
      FROM   user_objects
      WHERE  STATUS      = 'VALID'
      AND    object_id   = p_object_id_num;
   -- Stores PL/SQL program units that failed compiled
   TYPE lv_invalid_tab IS TABLE OF cur_objects_invalid%ROWTYPE
      INDEX BY BINARY_INTEGER;
   lv_invalid_tab_rec     lv_invalid_tab;
   lv_count_compiled_num  PLS_INTEGER; -- compiled counter
   lv_column_valid_txt    VARCHAR2(5);
   lv_exec_cursor_num     PLS_INTEGER := DBMS_SQL.OPEN_CURSOR;
   lv_sql_statement_txt   VARCHAR2(200);
   lv_object_count_num    PLS_INTEGER := 0; -- VALID counter
BEGIN
   DBMS_OUTPUT.PUT_LINE('Starting Re-Compilation of Objects');
   DBMS_OUTPUT.PUT_LINE('------------------------------------------');
   LOOP
      -- set to 0 to determine if any program units compiled this loop
      lv_count_compiled_num := 0; 
      FOR cur_objects_invalid_rec IN cur_objects_invalid LOOP
          -- Make sure PL/SQL program unit was not already 
          -- unsuccessfully compiled. If it is in the PL/SQL table, 
          -- the program unit previously failed and is skipped.
         IF NOT lv_invalid_tab_rec.
            EXISTS(cur_objects_invalid_rec.object_id) THEN
            -- Builds COMPILE DDL statements
            IF cur_objects_invalid_rec.object_type =
               'PACKAGE BODY' THEN
               lv_sql_statement_txt := 'ALTER PACKAGE ' ||
                  cur_objects_invalid_rec.object_name ||
                  ' COMPILE BODY';
            ELSE
               lv_sql_statement_txt := 'ALTER ' ||
                  cur_objects_invalid_rec.object_type ||
                  ' ' || cur_objects_invalid_rec.object_name ||
                  ' COMPILE';
            END IF;
            -- The DBMS_SQL.PARSE executes a DDL statement, therefore
            -- DBMS_SQL.EXECUTE is not required. Prior to Oracle8, if
            -- the DBMS_SQL.PARSE command resulted in an Oracle error,
            -- no error was returned to the PL/SQL calling code. After
            -- Oracle8, an error is passed back, therefore, this call
            -- is in a nested PL/SQL block to bypass the error, the
            -- query to USER_OBJECTS for the object being VALID tells
            -- this program if the compiled succeeded or failed.
            BEGIN
               lv_object_count_num := lv_object_count_num + 1;
               DBMS_SQL.PARSE(lv_exec_cursor_num, 
                  lv_sql_statement_txt, DBMS_SQL.NATIVE);
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
            -- If object VALID, compile successful, otherwise failed.
            OPEN cur_objects_valid(cur_objects_invalid_rec.object_id);
            FETCH cur_objects_valid INTO lv_column_valid_txt;
            IF CUR_OBJECTS_VALID%ROWCOUNT > 0 THEN
               -- Display Success and exit loop
               DBMS_OUTPUT.PUT_LINE('Object Compilation: ' ||
                  cur_objects_invalid_rec.object_type ||
                  ' - ' || cur_objects_invalid_rec.object_name ||
                  ' SUCCEEDED');
               lv_count_compiled_num := lv_count_compiled_num + 1;
               CLOSE cur_objects_valid;
               EXIT;
            ELSE
               -- Display failure and add to PL/SQL table 
               DBMS_OUTPUT.PUT_LINE('Object Compilation: ' ||
                  cur_objects_invalid_rec.object_type ||
                  ' - ' || cur_objects_invalid_rec.object_name ||
                  ' FAILED');
               lv_invalid_tab_rec(cur_objects_invalid_rec.object_id).
                  object_name := cur_objects_invalid_rec.object_name;
               lv_invalid_tab_rec(cur_objects_invalid_rec.object_id).
                  object_type := cur_objects_invalid_rec.object_type;
               CLOSE cur_objects_valid;
            END IF;
         END IF;
      END LOOP;
      -- When no more INVALID PL/SQL program units exist that have not
      -- been attempted to be compiled in this program unit, exit.
      IF lv_count_compiled_num = 0 THEN
         EXIT;
      END IF;
   END LOOP;
   -- Displays the fact that no INVALID PL/SQL program units found
   IF lv_object_count_num = 0 THEN
      DBMS_OUTPUT.PUT_LINE('No Objects to Re-Compile - All VALID.');
   END IF;
   DBMS_OUTPUT.PUT_LINE('------------------------------------------');
   DBMS_OUTPUT.PUT_LINE('Re-Compilation of Objects Complete');
   DBMS_SQL.CLOSE_CURSOR(lv_exec_cursor_num);
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('---------------------------------------');
      DBMS_OUTPUT.PUT_LINE('Re-Compilation Aborted.');
      DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 100));
      -- Closes any cursor left open upon an error
      IF DBMS_SQL.IS_OPEN(lv_exec_cursor_num) THEN
         DBMS_SQL.CLOSE_CURSOR(lv_exec_cursor_num);
      END IF;
      IF cur_objects_valid%ISOPEN THEN
         CLOSE cur_objects_valid;
      END IF;
END recompile_all_objects;
/

SPOOL OFF
