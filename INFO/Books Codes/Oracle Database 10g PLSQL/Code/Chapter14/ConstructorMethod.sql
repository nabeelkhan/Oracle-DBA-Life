/*
 * ConstructorMethod.sql
 * Chapter 14, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates the user-defined constructor method.
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

/******************************************
* Run the following to test: 
*      constructorMethod.sql
*
* SET SERVEROUTPUT ON SIZE 1000000
* DECLARE
*    v_price   discount_price_obj := discount_price_obj (75);
* BEGIN
*    DBMS_OUTPUT.put_line (v_price.price);
* END;
* /
* 
*******************************************/
