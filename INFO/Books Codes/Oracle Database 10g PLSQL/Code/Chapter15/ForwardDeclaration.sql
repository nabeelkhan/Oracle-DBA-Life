/*
 * ForwardDeclaration.sql
 * Chapter 15, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates forward type declarations.
 */

SET SERVEROUTPUT ON SIZE 1000000 ECHO OFF

exec clean_schema.synonyms
exec clean_schema.tables
exec clean_schema.objects

PROMPT
PROMPT Creation of inventory_obj results in the following exception:
PROMPT ==============================================================

CREATE OR REPLACE TYPE inventory_obj AS OBJECT (
   item_id        NUMBER(10),
   num_in_stock   NUMBER(10), 
   reorder_status VARCHAR2(20),
   price       REF   discount_price_obj);
/

SHOW ERRORS

PROMPT
PROMPT To avoid this problem, use a forward declaration of discount_price_obj
PROMPT ======================================================================

CREATE TYPE discount_price_obj;
/

PROMPT
PROMPT Now we can create inventory_obj successfully
PROMPT ============================================

CREATE OR REPLACE TYPE inventory_obj AS OBJECT (
   item_id        NUMBER(10),
   num_in_stock   NUMBER(10), 
   reorder_status VARCHAR2(20),
   price       REF   discount_price_obj);
/