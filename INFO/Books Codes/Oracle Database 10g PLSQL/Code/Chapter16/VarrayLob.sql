/*
 * VarrayLob.sql
 * Chapter 16, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates user-defined LOBs
 */

exec CLEAN_SCHEMA.TABLES
exec CLEAN_SCHEMA.OBJECTS
exec CLEAN_SCHEMA.PROCS

CREATE or REPLACE TYPE varray_table_obj 
   AS VARRAY(3964) OF VARCHAR2(10);
/
CREATE OR REPLACE TYPE varray_lob_obj 
   AS VARRAY(4001) OF VARCHAR2(10);
/
CREATE OR REPLACE TYPE varray_lob2_obj 
   AS VARRAY(3964) OF VARCHAR2(10);
/
CREATE TABLE varray_lob (
   column1   varray_table_obj,
   column2   varray_lob_obj,
   column3   varray_lob2_obj)
   VARRAY column3 STORE AS LOB column3_seg;
