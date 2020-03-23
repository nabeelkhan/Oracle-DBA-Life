-- ***************************************************************************
-- File: 4_25.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_25.lis

CREATE OR REPLACE PACKAGE process_products IS
   -- Creates the PL/SQL table structure based on the s_product table
   TYPE type_prod_table IS TABLE OF s_product%ROWTYPE
      INDEX BY BINARY_INTEGER;
   pvg_prod_table type_prod_table;
   -- This procedure populates the product PL/SQL table with the 
   -- entire contents of the s_product table.
   PROCEDURE populate_prod_table;
-- This procedure scans the product PL/SQL table by the product id
   PROCEDURE check_product_id (p_prod_id_num s_product.
      product_id%TYPE);
-- This procedure scans the product PL/SQL table by the product name
   PROCEDURE check_product_name (p_prod_name_txt s_product.
      product_name%TYPE);
END process_products;
/

SPOOL OFF
