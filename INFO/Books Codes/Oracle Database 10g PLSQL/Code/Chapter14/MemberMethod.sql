/*
 * MemberMethod.sql
 * Chapter 14, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates the member method.
 */

exec clean_schema.synonyms
exec clean_schema.tables
exec clean_schema.objects

CREATE OR REPLACE TYPE discount_price_obj AS OBJECT (
   discount_rate   NUMBER (10, 4),
   price           NUMBER (10, 2),
   MEMBER FUNCTION discount_price
      RETURN NUMBER
)
INSTANTIABLE FINAL;
/

CREATE OR REPLACE TYPE BODY discount_price_obj
AS
   MEMBER FUNCTION discount_price
      RETURN NUMBER
   IS
   BEGIN
      RETURN (SELF.price * (1 - SELF.discount_rate));
   END discount_price;
END;
/

/*******************************************************
* 
* Run the following to test: 
*      memberMethod.sql
*
* SET SERVEROUTPUT ON SIZE 1000000
*
* DECLARE
*    v_price discount_price_obj := discount_price_obj(.1, 75.00);
* BEGIN
*    dbms_output.put_line(v_price.discount_price);
* END;
* /
* 
*******************************************************/
