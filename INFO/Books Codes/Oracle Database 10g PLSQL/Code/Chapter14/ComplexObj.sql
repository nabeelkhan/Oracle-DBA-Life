/*
 * ComplexObj.sql
 * Chapter 14, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates complex objects
 */


exec clean_schema.synonyms
exec clean_schema.tables
exec clean_schema.objects

CREATE OR REPLACE TYPE discount_price_obj AS OBJECT (
   discount_rate  NUMBER(10,4),
   price          NUMBER(10,2),

   MEMBER FUNCTION discount_price RETURN NUMBER)
INSTANTIABLE
FINAL;
/


CREATE OR REPLACE TYPE inventory_obj AS OBJECT (
   item_id        NUMBER(10),
   num_in_stock   NUMBER(10), 
   reorder_status VARCHAR2(20),
   price       REF   discount_price_obj);
/
