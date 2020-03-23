-- ***************************************************************************
-- File: 9_2b.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 9_2b.lis

CREATE OR REPLACE PACKAGE BODY dependency_tree AS
------------------------------------------------------------
PROCEDURE find_dep 
   (p_direction_txt  IN VARCHAR2, 
   p_object_name_txt IN VARCHAR2,
   p_owner_txt       IN VARCHAR2 :=USER) AS
   CURSOR cur_objects IS
      SELECT owner, object_name, object_type
      FROM   dba_objects
      WHERE  object_name = UPPER(p_object_name_txt)
      AND    owner       = UPPER(p_owner_txt);
   lv_count_num      PLS_INTEGER := 0;
   lv_string_txt     VARCHAR2(60);
   lv_direction_txt  VARCHAR2(1);
   lv_direction_msg  VARCHAR2(10);
   lv_direction_msg2 VARCHAR2(25);
BEGIN
   lv_direction_txt := UPPER(p_direction_txt);
   IF lv_direction_txt = 'B' THEN
      lv_direction_msg  := 'BOTTOM-UP';
      lv_direction_msg2 := 'Referenced by Object ';
   ELSE
      lv_direction_msg  := 'TOP-DOWN';
      lv_direction_msg2 := 'References Object ';
      lv_direction_txt  := 'T';
   END IF;      
   lv_string_txt := repeat_char(55, '-');
   DBMS_OUTPUT.PUT_LINE(lv_string_txt);
   DBMS_OUTPUT.PUT_LINE('START OF DEPENDENCY TREE LISTING (' ||
      lv_direction_msg || ')');
   FOR cur_objects_rec IN cur_objects LOOP
      lv_count_num := lv_count_num + 1;
      DBMS_OUTPUT.PUT_LINE(lv_string_txt);
      DBMS_OUTPUT.PUT_LINE('Dependencies for ' ||
         cur_objects_rec.object_type || ' ' ||
         cur_objects_rec.owner || '.' ||
         cur_objects_rec.object_name);
      DBMS_OUTPUT.PUT_LINE(lv_string_txt);
      get_dep(lv_direction_txt, lv_direction_msg2,
         cur_objects_rec.owner,
         cur_objects_rec.object_name,
         cur_objects_rec.object_type, 0);
   END LOOP;
   IF lv_count_num = 0 THEN
      DBMS_OUTPUT.PUT_LINE(lv_string_txt);
      DBMS_OUTPUT.PUT_LINE('Object ' || p_owner_txt ||
         '.' || p_object_name_txt || ' does not exist.');
   END IF;
   DBMS_OUTPUT.PUT_LINE('');
   DBMS_OUTPUT.PUT_LINE(lv_string_txt);
   DBMS_OUTPUT.PUT_LINE('END OF DEPENDENCY TREE LISTING (' ||
      lv_direction_msg || ')');
   DBMS_OUTPUT.PUT_LINE(lv_string_txt);
END find_dep;
------------------------------------------------------------
PROCEDURE get_dep 
   (p_direction_txt   IN VARCHAR2,
   p_direction_msg2   IN VARCHAR2,
   p_object_owner_txt IN VARCHAR2, 
   p_object_name_txt  IN VARCHAR2, 
   p_object_type_txt  IN VARCHAR2, 
   p_index_num        IN PLS_INTEGER) AS
   CURSOR cur_dep_objects_down IS
      SELECT referenced_owner owner, referenced_name name, 
             referenced_type type
      FROM   dba_dependencies
      WHERE  owner            = p_object_owner_txt
      AND    name             = p_object_name_txt
      AND    type             = p_object_type_txt
      AND    referenced_type  != 'NON-EXISTENT'
--    AND    referenced_owner <> 'SYS'   -- Eliminate SYS objects
      ORDER BY referenced_owner, referenced_type, referenced_name;
   CURSOR cur_dep_objects_up IS
      SELECT owner, name, type
      FROM   dba_dependencies
      WHERE  referenced_owner = p_object_owner_txt
      AND    referenced_name  = p_object_name_txt
      AND    referenced_type  = p_object_type_txt
--    AND    owner            <> 'SYS'  -- Eliminate SYS objects
      ORDER BY referenced_owner, referenced_type, referenced_name;
   lv_call_level_num    PLS_INTEGER := 0;
   lv_loop_index_num    PLS_INTEGER := 0;
   lv_object_owner_txt  VARCHAR2(30);
   lv_object_name_txt   VARCHAR2(100);
   lv_object_type_txt   VARCHAR2(20);
   lv_object_owner_txt2 VARCHAR2(30);
   lv_object_name_txt2  VARCHAR2(100);
   lv_object_type_txt2  VARCHAR2(20);
   lv_repeat_string_txt VARCHAR2(500) := '-';
BEGIN
   lv_call_level_num    := p_index_num + 1;
   lv_repeat_string_txt := repeat_char(lv_call_level_num, '-');
   lv_object_owner_txt  := p_object_owner_txt;
   lv_object_name_txt   := p_object_name_txt;
   lv_object_type_txt   := p_object_type_txt;
     IF p_direction_txt = 'T' THEN
        FOR cur_dep_objects_rec IN cur_dep_objects_down LOOP
           lv_loop_index_num    := lv_loop_index_num + 1;
           lv_object_owner_txt2 := cur_dep_objects_rec.owner;
           lv_object_name_txt2  := cur_dep_objects_rec.name;
           lv_object_type_txt2  := cur_dep_objects_rec.type;
           DBMS_OUTPUT.PUT_LINE(lv_repeat_string_txt || '> ' ||
              p_direction_msg2 || lv_object_owner_txt2 || '.' ||
           lv_object_name_txt2 || ' <' || lv_object_type_txt2 || '>');
           -- Recurse each branch for all relationships
           get_dep(p_direction_txt, p_direction_msg2, 
                   lv_object_owner_txt2, lv_object_name_txt2, 
                   lv_object_type_txt2, lv_call_level_num);
        END LOOP;
     ELSE
        FOR cur_dep_objects_rec IN cur_dep_objects_up LOOP
           lv_loop_index_num := lv_loop_index_num + 1;
           lv_object_owner_txt2 := cur_dep_objects_rec.owner;
           lv_object_name_txt2  := cur_dep_objects_rec.name;
           lv_object_type_txt2  := cur_dep_objects_rec.type;
           DBMS_OUTPUT.PUT_LINE(lv_repeat_string_txt || '> ' ||
              p_direction_msg2 || lv_object_owner_txt2 || '.' ||
              lv_object_name_txt2 || ' <' || 
              lv_object_type_txt2 || '>');
           -- Recurse each branch for all relationships
           get_dep(p_direction_txt, p_direction_msg2, 
                   lv_object_owner_txt2, lv_object_name_txt2, 
                   lv_object_type_txt2, lv_call_level_num);
        END LOOP;
     END IF;
   IF lv_loop_index_num = 0 AND lv_call_level_num = 1 THEN
      DBMS_OUTPUT.PUT_LINE('Object ' ||
         p_object_owner_txt || '.' ||
         lv_object_name_txt || ' has no dependencies.');
   END IF;
END get_dep;
------------------------------------------------------------
FUNCTION repeat_char
   (p_repeat_num IN PLS_INTEGER,
   p_repeat_txt  IN VARCHAR2 := '-')
   RETURN VARCHAR2 IS
   lv_string_txt VARCHAR2(500) := '-';
BEGIN
   FOR lv_num IN 0..p_repeat_num LOOP
      lv_string_txt := lv_string_txt || '-';
   END LOOP;
RETURN lv_string_txt;
END repeat_char;
------------------------------------------------------------
END dependency_tree;
/

SPOOL OFF
