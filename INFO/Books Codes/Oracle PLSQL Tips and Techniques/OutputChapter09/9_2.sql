-- ***************************************************************************
-- File: 9_2.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 9_2.lis

CREATE OR REPLACE PACKAGE dependency_tree AS
   -- This package will traverse top-down (p_direction_txt = T) or 
   -- bottom-up (p_direction_txt = B)
   PROCEDURE find_dep
      (p_direction_txt  IN VARCHAR2,
      p_object_name_txt IN VARCHAR2,
      p_owner_txt       IN VARCHAR2 :=USER);
   PROCEDURE get_dep
      (p_direction_txt   IN VARCHAR2,
      p_direction_msg2   IN VARCHAR2,
      p_object_owner_txt IN VARCHAR2,
      p_object_name_txt  IN VARCHAR2,
      p_object_type_txt  IN VARCHAR2,
      p_index_num        IN PLS_INTEGER);
   FUNCTION repeat_char
      (p_repeat_num IN PLS_INTEGER,
      p_repeat_txt  IN VARCHAR2 := '-') RETURN VARCHAR2;
END dependency_tree;
/

SPOOL OFF
