/*
 * Number.sql
 * Chapter 3, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates the NUMBER datatype
 */

exec clean_schema.trigs
exec clean_schema.procs
exec clean_schema.tables

CREATE TABLE precision (
   value NUMBER(38,5),
   scale NUMBER(10));

INSERT INTO precision (value, scale)
   VALUES (12345, 0);
INSERT INTO precision (value, scale)
   VALUES (123456, 0);
INSERT INTO precision (value, scale)
   VALUES (123.45, 0);
INSERT INTO precision (value, scale)
   VALUES (12345, 2);
INSERT INTO precision (value, scale)
   VALUES (123.45, 2);
INSERT INTO precision (value, scale)
   VALUES (12.345, 2);
INSERT INTO precision (value, scale)
   VALUES (1234.5, 2);

commit;

SET SERVEROUTPUT ON

DECLARE
   v_integer NUMBER(5);
   v_scale_2 NUMBER(5,2);
   v_real NUMBER;

   CURSOR scale_0_cur
   IS
      SELECT value
      FROM precision
      WHERE scale = 0;

   CURSOR scale_2_cur
   IS
      SELECT value
      FROM precision
      WHERE scale = 2;
BEGIN

   DBMS_OUTPUT.PUT_LINE('====== PRECISION 5 SCALE 0 =====');

   OPEN scale_0_cur;

   -- Loop thorugh all records that have a scale of zero
   LOOP
   FETCH scale_0_cur INTO v_real;
   EXIT WHEN scale_0_cur%NOTFOUND;

   -- Assign different values to the v_integer variable 
   --  to see how it handles it
   BEGIN
      DBMS_OUTPUT.PUT_LINE('	');
      DBMS_OUTPUT.PUT_LINE('Assigned: '||v_real);
      
      v_integer := v_real;

      DBMS_OUTPUT.PUT_LINE('Stored: '||v_integer);
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.PUT_LINE('Exception: '||sqlerrm);
   END;
   END LOOP;

   CLOSE scale_0_cur;

   DBMS_OUTPUT.PUT_LINE('	');
   DBMS_OUTPUT.PUT_LINE('====== PRECISION 5 SCALE 2 =====');

   OPEN scale_2_cur;

   -- Loop through all records that have a scale of 2
   LOOP
   FETCH scale_2_cur INTO v_real;
   EXIT WHEN scale_2_cur%NOTFOUND;

   -- Assign different values to the v_scale_2 variable 
   --  to see how it handles it
   BEGIN
      DBMS_OUTPUT.PUT_LINE('	');
      DBMS_OUTPUT.PUT_LINE('Assigned: '||v_real);
      
      v_scale_2 := v_real;

      DBMS_OUTPUT.PUT_LINE('Stored: '||v_scale_2);
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.PUT_LINE('Exception: '||sqlerrm);
   END;
   END LOOP;

   CLOSE scale_2_cur;

END;
/

