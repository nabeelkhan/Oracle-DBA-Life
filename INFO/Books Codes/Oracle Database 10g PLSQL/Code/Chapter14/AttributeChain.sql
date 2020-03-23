/*
 * AttributeChain.sql
 * Chapter 14, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates attribute chaining.
 */

exec clean_schema.synonyms
exec clean_schema.tables
exec clean_schema.objects

CREATE OR REPLACE TYPE address_obj AS OBJECT (
   address1   VARCHAR2 (30 CHAR),
   address2   VARCHAR2 (30 CHAR),
   city       VARCHAR2 (30 CHAR),
   state      CHAR (2 CHAR)
)
INSTANTIABLE FINAL;
/

CREATE OR REPLACE TYPE person_obj AS OBJECT (
   first_name   VARCHAR2 (20),
   last_name    VARCHAR2 (20)
)
INSTANTIABLE FINAL;
/

CREATE OR REPLACE TYPE contact_obj AS OBJECT (
   NAME      person_obj,
   address   address_obj,
   phone     NUMBER (10)
)
INSTANTIABLE FINAL;
/

CREATE OR REPLACE TYPE publisher_obj AS OBJECT (
   pub_name       VARCHAR2 (30),
   contact_info   contact_obj,
   MEMBER PROCEDURE show_contact
)
INSTANTIABLE FINAL;
/

CREATE OR REPLACE TYPE BODY publisher_obj
AS
   MEMBER PROCEDURE show_contact
   IS
   BEGIN
      DBMS_OUTPUT.put_line ('CONTACT INFORMATION');
      DBMS_OUTPUT.put_line ('===================');
      DBMS_OUTPUT.put_line (SELF.pub_name);
      DBMS_OUTPUT.put_line (   SELF.contact_info.NAME.first_name
                            || ' '
                            || SELF.contact_info.NAME.last_name
                           );
      DBMS_OUTPUT.put_line (SELF.contact_info.address.address1);
      DBMS_OUTPUT.put_line (SELF.contact_info.address.city);
      DBMS_OUTPUT.put_line (SELF.contact_info.address.state);
      DBMS_OUTPUT.put_line (SELF.contact_info.phone);
      RETURN;
   END show_contact;
END;
/

-- To test
/******************************************
* SET SERVEROUTPUT ON SIZE 1000000
* DECLARE
*    v_person      person_obj    := person_obj ('Ron', 'Hardman');
*    v_address     address_obj
*                        := address_obj ('123 Ora Way', NULL, 'Colorado Springs', 'CO');
*    v_contact     contact_obj := contact_obj (v_person, v_address, 5555555555);
*    v_publisher   publisher_obj := publisher_obj ('Oracle Press', v_contact);
* BEGIN
*   v_publisher.show_contact;
* END;
* /
* 
*******************************************/
