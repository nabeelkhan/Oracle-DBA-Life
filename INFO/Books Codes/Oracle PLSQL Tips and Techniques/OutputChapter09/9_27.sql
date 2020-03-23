-- ***************************************************************************
-- File: 9_27.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 9_27.lis

CREATE OR REPLACE PROCEDURE pin_objects
   (p_pin_flag_txt IN VARCHAR2 := 'P') IS
   -- The p_pin_flag_txt is either 'P' for pin
   -- or 'U' for unpin.
   CURSOR cur_pin_objects IS
      SELECT owner || '.' owner,
             object
      FROM   objects_to_pin
      ORDER BY owner, object;
BEGIN
    FOR cur_pin_objects_rec IN cur_pin_objects LOOP
      IF p_pin_flag_txt = 'U' THEN
         DBMS_SHARED_POOL.UNKEEP(cur_pin_objects_rec.owner ||
            cur_pin_objects_rec.object, 'P');
         DBMS_OUTPUT.PUT_LINE('Object Unpinned: ' ||
            cur_pin_objects_rec.owner ||
            cur_pin_objects_rec.object);
      ELSE
         DBMS_SHARED_POOL.KEEP(cur_pin_objects_rec.owner ||
            cur_pin_objects_rec.object, 'P');
         DBMS_OUTPUT.PUT_LINE('Object Pinned: ' ||
            cur_pin_objects_rec.owner ||
            cur_pin_objects_rec.object);
      END IF;
   END LOOP;
END pin_objects;
/

SPOOL OFF
