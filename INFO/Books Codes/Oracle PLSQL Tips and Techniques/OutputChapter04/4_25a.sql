-- ***************************************************************************
-- File: 4_25a.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_25a.lis

CREATE OR REPLACE PACKAGE BODY process_products IS
------------------------------------------------------------------
PROCEDURE populate_prod_table IS
   CURSOR cur_product IS
      SELECT * 
      FROM   s_product;
BEGIN
   -- First, empty current PL/SQL table
   pvg_prod_table.DELETE;
   -- Loop through all products, placing into PL/SQL table
   FOR lv_prod_rec IN cur_product LOOP
      -- The product_id is used as the array index, but also loaded
      -- for the searches that are on product_name and need to 
      -- return the product_id.
      pvg_prod_table(lv_prod_rec.product_id).product_id 
         := lv_prod_rec.product_id;
      pvg_prod_table(lv_prod_rec.product_id).product_name 
         := lv_prod_rec.product_name;
      pvg_prod_table(lv_prod_rec.product_id).short_desc   
         := lv_prod_rec.short_desc;
      pvg_prod_table(lv_prod_rec.product_id).suggested_wholesale_price
         := lv_prod_rec.suggested_wholesale_price;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,
         'Error in procedure POPULATE_PROD_TABLE.', FALSE);
END populate_prod_table;
------------------------------------------------------------------
PROCEDURE check_product_id
   (p_prod_id_num s_product.product_id%TYPE) IS
BEGIN
   -- One statement to see if the product exists, since the
   -- array index is the product_id.
   IF pvg_prod_table.EXISTS(p_prod_id_num) THEN
      DBMS_OUTPUT.PUT_LINE('PL/SQL Table Index: ' ||
         pvg_prod_table(p_prod_id_num));
      DBMS_OUTPUT.PUT_LINE('Product ID: ' ||
         pvg_prod_table(p_prod_id_num).product_id );
      DBMS_OUTPUT.PUT_LINE('Product Name: ' ||
         pvg_prod_table(p_prod_id_num).product_name );
      DBMS_OUTPUT.PUT_LINE('Description: ' ||
         pvg_prod_table(p_prod_id_num).short_desc );
      DBMS_OUTPUT.PUT_LINE('Wholesale Price: ' || 
         TO_CHAR(pvg_prod_table(p_prod_id_num).
         suggested_wholesale_price, '$9999.00'));
      DBMS_OUTPUT.PUT_LINE(CHR(10));
   ELSE
      DBMS_OUTPUT.PUT_LINE('Product: ' || TO_CHAR(p_prod_id_num) || 
         ' is invalid.');
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20102,
         'Error in procedure CHECK_PRODUCT_ID.', FALSE);
END check_product_id;
------------------------------------------------------------------
PROCEDURE check_product_name 
   (p_prod_name_txt s_product.product_name%TYPE) IS
   lv_index_num     NUMBER;
   lv_match_bln     BOOLEAN := FALSE;
BEGIN
   -- First check if table has any records
   IF pvg_prod_table.COUNT <> 0 THEN
      -- Attain starting table index for loop
      lv_index_num := pvg_prod_table.FIRST;
      -- Loop through all products looking for a match on product_name
      LOOP
         -- Check existence of the product name (not exact match 
         -- check, only a check to see if the input name is contained
         -- in a product name in the table).
         IF (INSTR(UPPER(pvg_prod_table(lv_index_num).product_name),
             UPPER(p_prod_name_txt)) > 0) THEN
            -- Assign TRUE to search boolean
            lv_match_bln := TRUE;
            -- Output record data from PL/SQL table
            DBMS_OUTPUT.PUT_LINE('PL/SQL Table Index: ' ||
               pvg_prod_table(lv_index_num));
            DBMS_OUTPUT.PUT_LINE('Product ID: ' ||
               pvg_prod_table(lv_index_num).product_id );
            DBMS_OUTPUT.PUT_LINE('Product Name: ' ||
               pvg_prod_table(lv_index_num).product_name );
            DBMS_OUTPUT.PUT_LINE('Description: ' ||
               pvg_prod_table(lv_index_num).short_desc );
            DBMS_OUTPUT.PUT_LINE('Wholesale Price: ' || 
               TO_CHAR(pvg_prod_table(lv_index_num).
               suggested_wholesale_price, '$9999.00'));
            DBMS_OUTPUT.PUT_LINE(CHR(10));
         END IF;
         EXIT WHEN (lv_index_num = pvg_prod_table.LAST) OR
            lv_match_bln;
         lv_index_num := pvg_prod_table.NEXT(lv_index_num);
      END LOOP;
      IF NOT lv_match_bln THEN
         -- Output record data from PL/SQL table
         DBMS_OUTPUT.PUT_LINE('Product: ' || p_prod_name_txt || 
            ' is invalid.');
      END IF;
   ELSE
      -- Output record data from PL/SQL table
      DBMS_OUTPUT.PUT_LINE('There are no products in the table.');
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20102,
         'Error in procedure CHECK_PRODUCT_NAME.', FALSE);
END check_product_name;
------------------------------------------------------------------
-- Package Initialization Section
BEGIN 
   -- Call procedure to populate product PL/SQL table
   populate_prod_table;
END process_products;
/

SPOOL OFF
