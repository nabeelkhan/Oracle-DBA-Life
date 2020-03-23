/*
 * TypeAttribute.sql
 * Chapter 14, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates the use of %TYPE.
 */

exec clean_schema.synonyms
exec clean_schema.tables
exec clean_schema.objects

CREATE OR REPLACE TYPE discount_price_obj AS OBJECT (
   discount_rate   NUMBER (10, 4),
   price           NUMBER (10, 2),
   CONSTRUCTOR FUNCTION discount_price_obj (price NUMBER)
      RETURN SELF AS RESULT
)
INSTANTIABLE FINAL;
/

CREATE OR REPLACE TYPE BODY discount_price_obj
AS
   CONSTRUCTOR FUNCTION discount_price_obj (price NUMBER)
      RETURN SELF AS RESULT
   AS
   BEGIN
      SELF.price := price * .9;
      RETURN;
   END discount_price_obj;
END;
/

prompt
prompt This example works fine.  %TYPE is applied 
prompt   to the variable, not the object type.
prompt

DECLARE
   v_discount_price   discount_price_obj;
   v_price           v_discount_price.price%TYPE;
BEGIN
   NULL;
END;
/

prompt
prompt This example throws an exception.  %TYPE is applied
prompt   directly to the object type.
prompt

DECLARE
   v_price           discount_price_obj.price%TYPE;
BEGIN
   NULL;
END;
/
