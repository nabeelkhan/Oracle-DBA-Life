/*
 * create_types.sql
 * Chapter 13, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * Purpose:
 *   This is build types to test the Native Dynamic SQL package.
 */

-- Create a Varray of a one character string.
CREATE OR REPLACE TYPE varchar2_table1 IS
VARRAY(100) OF VARCHAR2(1);
/

-- Create a Varray of number.
CREATE OR REPLACE TYPE card_number_varray IS
VARRAY(100) OF NUMBER;
/

-- Create a Varray of twenty character string.
CREATE OR REPLACE TYPE card_name_varray IS
VARRAY(100) OF VARCHAR2(2000);
/

-- Create a Varray of thirty character string.
CREATE OR REPLACE TYPE card_suit_varray IS
VARRAY(100) OF VARCHAR2(2000);
/


