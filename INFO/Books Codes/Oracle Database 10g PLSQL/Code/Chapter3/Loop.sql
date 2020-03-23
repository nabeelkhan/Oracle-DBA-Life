/*
 * Loop.sql
 * Chapter 3, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates LOOPs
 */


PROMPT
PROMPT ** Simple Loop
PROMPT

SET SERVEROUTPUT ON
DECLARE
   v_count PLS_INTEGER := 1;
BEGIN
   LOOP
      DBMS_OUTPUT.PUT_LINE('Ah -- Much better');
      v_count := v_count + 1;
      EXIT WHEN v_count = 20;
   END LOOP;
END;
/

PROMPT
PROMPT ** Numeric FOR Loop
PROMPT

BEGIN
   FOR v_count IN 1 .. 20
   LOOP
      DBMS_OUTPUT.PUT_LINE('Iteration: '||v_count);
   END LOOP;
END;
/

PROMPT
PROMPT ** WHILE Loop
PROMPT

DECLARE
   v_count PLS_INTEGER := 1;
BEGIN
   WHILE v_count <= 20
   LOOP
      DBMS_OUTPUT.PUT_LINE('While loop iteration: '||v_count);
      v_count := v_count + 1;
   END LOOP;
END;
/

PROMPT
PROMPT ** Loop with a Label
PROMPT

BEGIN
   <<l_For_Loop>>
   FOR v_count IN 1 .. 20
   LOOP
      DBMS_OUTPUT.PUT_LINE('Iteration: '||v_count);
   END LOOP l_For_Loop;
END;
/
