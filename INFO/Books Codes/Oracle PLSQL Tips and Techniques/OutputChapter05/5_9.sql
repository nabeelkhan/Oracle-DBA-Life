-- ***************************************************************************
-- File: 5_9.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_9.lis

CREATE OR REPLACE PACKAGE global_pkg IS
   -- Declare user-defined data types to be referenced globally
   TYPE pv_stats_rec IS RECORD 
      (pv_rep_last_name_txt   s_employee.employee_last_name%TYPE,
       pv_rep_first_name_txt  s_employee.employee_first_name%TYPE,
       pv_salary_num          s_employee.salary%TYPE,
       pv_commission_pct_num  s_employee.commission_pct%TYPE,
       pv_cust_count_num      NUMBER,
       pv_order_count_num     NUMBER,
       pv_orders_total_num    NUMBER,
       pv_last_order_date     DATE,
       pv_avg_order_tot_num   NUMBER );
   TYPE pv_prod_table_rec IS TABLE OF s_product%ROWTYPE
      INDEX BY BINARY_INTEGER;
   -- Declare global variable based on user-defined types
   pv_prod_tab pv_prod_table_rec;
   -- Declare global PL/SQL cursors
   CURSOR cur_employee (p_emp_id_num s_employee.employee_id%TYPE) IS
      SELECT *
      FROM   s_employee
      WHERE  employee_id = p_emp_id_num;
   CURSOR cur_customer (p_cust_id_num s_customer.customer_id%TYPE) IS
      SELECT *
      FROM   s_customer
      WHERE  customer_id = p_cust_id_num;
   CURSOR cur_warehouse (p_ware_id_num s_warehouse.warehouse_id%TYPE)
      IS
      SELECT *
      FROM   s_warehouse
      WHERE  warehouse_id = p_ware_id_num;
   CURSOR cur_order (p_ord_id_num s_order.order_id%TYPE) IS
      SELECT *
      FROM   s_order
      WHERE  order_id = p_ord_id_num;
   CURSOR cur_product (p_prod_id_num s_product.product_id%TYPE) IS
      SELECT *
      FROM   s_product
      WHERE  product_id = p_prod_id_num;
   -- Declare global, cursor-based record variables
   pv_cust_rec cur_customer%ROWTYPE;
   pv_emp_rec  cur_employee%ROWTYPE;
   pv_whs_rec  cur_warehouse%ROWTYPE;
   pv_ord_rec  cur_order%ROWTYPE;
   pv_prod_rec cur_product%ROWTYPE;
END global_pkg;
/

SPOOL OFF
