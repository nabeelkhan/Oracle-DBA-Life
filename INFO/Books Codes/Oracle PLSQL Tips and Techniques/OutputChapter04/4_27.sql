-- ***************************************************************************
-- File: 4_27.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_27.lis

CREATE OR REPLACE PACKAGE name_pkg IS
-- This package uses constrained cursor variables to
-- return the name for a given id of a specified table.  
   -- Declare user-defined record type
   TYPE type_name_rec IS RECORD (name VARCHAR2(100));
   -- Declare constrained cursor variable
   TYPE type_name_refcur IS REF CURSOR
      RETURN type_name_rec;
   -- Opens the cursor based on the name, and uses the p_id_num in
   -- the predicate clause to only return one value.
   FUNCTION open_name (p_table_txt IN VARCHAR2, p_id_num IN NUMBER)
      RETURN type_name_refcur;
   -- Calls the open_name function to open the cursor and return the
   -- the name of the p_id_num passed. If no match is found, the 
   -- NO_DATA_FOUND exception is raised.
   FUNCTION get_name (p_table_txt IN VARCHAR2, p_id_num IN NUMBER)
      RETURN VARCHAR2;
END name_pkg;
/

SPOOL OFF
