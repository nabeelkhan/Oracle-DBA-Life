/*
 * StaticMethod.sql
 * Chapter 14, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates the static method.
 */

SET SERVEROUTPUT ON SIZE 1000000

exec clean_schema.synonyms
exec clean_schema.tables
exec clean_schema.objects

CREATE OR REPLACE TYPE discount_price_obj AS OBJECT (
   discount_rate   NUMBER (10, 4),
   price           NUMBER (10, 2),
   STATIC FUNCTION new_price (
      p_price           IN   NUMBER,
      p_discount_rate   IN   NUMBER DEFAULT .1
   )
      RETURN NUMBER
)
INSTANTIABLE FINAL;
/

CREATE OR REPLACE TYPE BODY discount_price_obj
AS
   STATIC FUNCTION new_price (
      p_price           IN   NUMBER,
      p_discount_rate   IN   NUMBER DEFAULT .1
   )
      RETURN NUMBER
   IS
   BEGIN
      RETURN (p_price * (1 - p_discount_rate));
   END new_price;
END;
/

-- Output value using a static method
-- exec DBMS_OUTPUT.PUT_LINE(discount_price_obj.new_price(75));
