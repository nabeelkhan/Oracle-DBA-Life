-- ***************************************************************************
-- File: plsqlsyn.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

-- Program:     plsqlsyn.sql
-- Creation:    01/01/99
-- Created By:  TUSC
-- Description: Creates the synonyms for the example tables 
-- for the PL/SQL Tips and Techniques Book.

SET ECHO OFF
SET FEEDBACK 1
SET TERMOUT ON

SPOOL plsqlsyn.log

-- *********************************************************************
-- Creates public synonyms for use in example database.
--
--	Public Synonym		Table
--	------------------------------------------
-- 	s_customer		s_customer
--	s_department		s_department
--	s_employee		s_employee
--	s_image			s_image
--	s_inventory		s_inventory
--	s_item			s_item
--	s_longtext		s_longtext
--	s_order			s_order
--	s_product		s_product
--	s_region		s_region
--	s_title			s_title
--	s_warehouse		s_warehouse
-- *********************************************************************
CREATE PUBLIC SYNONYM s_customer   FOR s_customer;
CREATE PUBLIC SYNONYM s_department FOR s_department;
CREATE PUBLIC SYNONYM s_employee   FOR s_employee;
CREATE PUBLIC SYNONYM s_image      FOR s_image;
CREATE PUBLIC SYNONYM s_inventory  FOR s_inventory;
CREATE PUBLIC SYNONYM s_item       FOR s_item;
CREATE PUBLIC SYNONYM s_longtext   FOR s_longtext;
CREATE PUBLIC SYNONYM s_order      FOR s_order;
CREATE PUBLIC SYNONYM s_product    FOR s_product;
CREATE PUBLIC SYNONYM s_region     FOR s_region;
CREATE PUBLIC SYNONYM s_title      FOR s_title;
CREATE PUBLIC SYNONYM s_warehouse  FOR s_warehouse;
SPOOL OFF