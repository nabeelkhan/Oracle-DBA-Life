-- ***************************************************************************
-- File: plsqlobj.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

-- Program:     plsqlobj.sql
-- Creation:    09/01/97
-- Created By:  TUSC
-- Description: Creates the sequences, tables, constraints, and inserts 
--              the example data for the PL/SQL Tips and Techniques Book.

SET ECHO OFF
SET FEEDBACK 1
SET TERMOUT ON

SPOOL plsqlobj.log

-- *********************************************************************
-- Creates sequence numbers for use in example database.
--
--	Sequence Number		Table
--	------------------------------------------
-- 	s_customer_id		s_customer
--	s_department_id		s_department
--	s_employee_id		s_employee
--	s_image_id		s_image
--	s_longtext_id		s_longtext
--	s_order_id		s_order
--	s_product_id		s_product
--	s_region_id		s_region
--	s_warehouse_id		s_warehouse
-- *********************************************************************

CREATE SEQUENCE s_customer_id
  MINVALUE 1
  MAXVALUE 9999999
  INCREMENT BY 1
  START WITH 216
  NOCACHE
  NOORDER
  NOCYCLE;

CREATE SEQUENCE s_department_id
  MINVALUE 1
  MAXVALUE 9999999
  INCREMENT BY 1
  START WITH 51
  NOCACHE
  NOORDER
  NOCYCLE;

CREATE SEQUENCE s_employee_id
  MINVALUE 1
  MAXVALUE 9999999
  INCREMENT BY 1
  START WITH 26
  NOCACHE
  NOORDER
  NOCYCLE;

CREATE SEQUENCE s_image_id
  MINVALUE 1
  MAXVALUE 9999999
  INCREMENT BY 1
  START WITH 1981
  NOCACHE
  NOORDER
  NOCYCLE;

CREATE SEQUENCE s_longtext_id
  MINVALUE 1
  MAXVALUE 9999999
  INCREMENT BY 1
  START WITH 1369
  NOCACHE
  NOORDER
  NOCYCLE;

CREATE SEQUENCE s_order_id
  MINVALUE 1
  MAXVALUE 9999999
  INCREMENT BY 1
  START WITH 113
  NOCACHE
  NOORDER
  NOCYCLE;

CREATE SEQUENCE s_product_id
  MINVALUE 1
  MAXVALUE 9999999
  INCREMENT BY 1
  START WITH 50537
  NOCACHE
  NOORDER
  NOCYCLE;

CREATE SEQUENCE s_region_id
  MINVALUE 1
  MAXVALUE 9999999
  INCREMENT BY 1
  START WITH 6
  NOCACHE
  NOORDER
  NOCYCLE;

CREATE SEQUENCE s_warehouse_id
  MINVALUE 1
  MAXVALUE 9999999
  INCREMENT BY 1
  START WITH 10502
  NOCACHE
  NOORDER
  NOCYCLE;
-- *********************************************************************

-- *********************************************************************
-- Creates tables and constraints for use in example database.
--
--	Table			
--	------------------
-- 	s_customer		
--	s_department	
--	s_employee		
--	s_image		
--	s_inventory		
--	s_item		
--	s_longtext		
--	s_order		
--	s_product		
--	s_region		
--	s_title			
--	s_warehouse		
-- *********************************************************************

CREATE TABLE s_customer
(customer_id        NUMBER(7)    CONSTRAINT s_customer_id_nn NOT NULL,
 customer_name      VARCHAR2(50) CONSTRAINT s_customer_name_nn NOT NULL,
 phone              VARCHAR2(15),
 address            VARCHAR2(400),
 city               VARCHAR2(35),
 state              VARCHAR2(30),
 country            VARCHAR2(30),
 zip_code           VARCHAR2(10),
 credit_rating      VARCHAR2(9),
 sales_rep_id       NUMBER(7),
 region_id          NUMBER(7),
 comments           VARCHAR2(255),
 preferred_customer VARCHAR2(1) DEFAULT 'N' NOT NULL,
 shipping_method    VARCHAR2(1) DEFAULT 'M' NOT NULL,
 CONSTRAINT s_customer_pref_cust CHECK (preferred_customer IN ('Y', 'N')),
 CONSTRAINT s_customer_ship_method CHECK (shipping_method IN ('M', 'F', 'U')),
 CONSTRAINT s_customer_id_pk PRIMARY KEY (customer_id),
 CONSTRAINT s_customer_credit_rating_ck CHECK (credit_rating IN ('EXCELLENT', 'GOOD', 'POOR'))
);

CREATE TABLE s_department
(department_id   NUMBER(7)     CONSTRAINT s_department_id_nn NOT NULL,
 department_name VARCHAR2(50)  CONSTRAINT s_department_name_nn NOT NULL,
 region_id       NUMBER(7),
 CONSTRAINT s_department_id_pk PRIMARY KEY (department_id),
 CONSTRAINT s_department_name_region_id_uk UNIQUE (department_name, region_id)
);

CREATE TABLE s_employee
(employee_id         NUMBER(7)     CONSTRAINT s_employee_id_nn NOT NULL,
 employee_last_name  VARCHAR2(25)  CONSTRAINT s_employee_last_name_nn NOT NULL,
 employee_first_name VARCHAR2(25),
 userid              VARCHAR2(8),
 start_date          DATE,
 comments            VARCHAR2(255),
 manager_id          NUMBER(7),
 title               VARCHAR2(25),
 department_id       NUMBER(7),
 salary              NUMBER(11, 2),
 commission_pct      NUMBER(4, 2),
 CONSTRAINT s_employee_id_pk PRIMARY KEY (employee_id),
 CONSTRAINT s_employee_userid_uk UNIQUE (userid),
 CONSTRAINT s_employee_commission_pct_ck CHECK (commission_pct IN (10, 12.5, 15, 17.5, 20))
);

CREATE TABLE s_image
(image_id       NUMBER(7)   CONSTRAINT s_image_id_nn NOT NULL,
 format         VARCHAR2(25),
 use_filename   VARCHAR2(1),
 filename       VARCHAR2(255),
 image          LONG RAW,
 CONSTRAINT s_image_id_pk PRIMARY KEY (image_id),
 CONSTRAINT s_image_format_ck CHECK (format IN ('JFIFF', 'JTIFF')),
 CONSTRAINT s_image_use_filename_ck CHECK (use_filename IN ('Y', 'N'))
);

CREATE TABLE s_inventory
(product_id               NUMBER(7) CONSTRAINT s_inventory_product_id_nn NOT NULL,
 warehouse_id             NUMBER(7) CONSTRAINT s_inventory_warehouse_id_nn NOT NULL,
 amount_in_stock          NUMBER(9),
 reorder_point            NUMBER(9),
 max_in_stock             NUMBER(9),
 out_of_stock_explanation VARCHAR2(255),
 restock_date             DATE,
 CONSTRAINT s_inventory_prod_id_whse_id_pk PRIMARY KEY (product_id, warehouse_id)
);

CREATE TABLE s_item
(order_id          NUMBER(7)    CONSTRAINT s_item_order_id_nn NOT NULL,
 item_id           NUMBER(7)    CONSTRAINT s_item_id_nn NOT NULL,
 product_id        NUMBER(7)    CONSTRAINT s_item_product_id_nn NOT NULL,
 price             NUMBER(11, 2),
 quantity          NUMBER(9),
 quantity_shipped  NUMBER(9),
 CONSTRAINT s_item_order_id_item_id_pk PRIMARY KEY (order_id, item_id),
 CONSTRAINT s_item_order_id_product_id_uk UNIQUE (order_id, product_id)
);

CREATE TABLE s_longtext
(longtext_id   NUMBER(7) CONSTRAINT s_longtext_id_nn NOT NULL,
 use_filename  VARCHAR2(1),
 filename      VARCHAR2(255),
 text          VARCHAR2(2000),
 CONSTRAINT s_longtext_id_pk PRIMARY KEY (longtext_id),
 CONSTRAINT s_longtext_use_filename_ck CHECK (use_filename in ('Y', 'N'))
);

CREATE TABLE s_order
(order_id      NUMBER(7)    CONSTRAINT s_order_id_nn NOT NULL,
 customer_id   NUMBER(7)    CONSTRAINT s_order_customer_id_nn NOT NULL,
 date_ordered  DATE,
 date_shipped  DATE,
 sales_rep_id  NUMBER(7),
 total         NUMBER(11, 2),
 payment_type  VARCHAR2(6),
 order_filled  VARCHAR2(1),
 CONSTRAINT s_order_id_pk PRIMARY KEY (order_id),
 CONSTRAINT s_order_payment_type_ck CHECK (payment_type IN ('CASH', 'CREDIT')),
 CONSTRAINT s_order_order_filled_ck CHECK (order_filled IN ('Y', 'N'))
);

CREATE TABLE s_product
(product_id                NUMBER(7)       CONSTRAINT s_product_id_nn NOT NULL,
 product_name              VARCHAR2(50)    CONSTRAINT s_product_name_nn NOT NULL,
 short_desc                VARCHAR2(255),
 longtext_id               NUMBER(7),
 image_id                  NUMBER(7),
 suggested_wholesale_price NUMBER(11, 2),
 wholesale_units           VARCHAR2(25),
 CONSTRAINT s_product_id_pk PRIMARY KEY (product_id),
 CONSTRAINT s_product_name_uk UNIQUE (product_name)
);

CREATE TABLE s_region
(region_id    NUMBER(7)    CONSTRAINT s_region_id_nn NOT NULL,
 region_name  VARCHAR2(50) CONSTRAINT s_region_name_nn NOT NULL,
 CONSTRAINT s_region_id_pk PRIMARY KEY (region_id),
 CONSTRAINT s_region_name_uk UNIQUE (region_name)
);

CREATE TABLE s_title
(title VARCHAR2(25)
 CONSTRAINT s_title_nn NOT NULL,
 CONSTRAINT s_title_pk PRIMARY KEY (title)
);

CREATE TABLE s_warehouse
(warehouse_id NUMBER(7)    CONSTRAINT s_warehouse_id_nn NOT NULL,
 region_id    NUMBER(7)    CONSTRAINT s_warehouse_region_id_nn NOT NULL,
 phone        VARCHAR2(15),
 address      VARCHAR2(400),
 city         VARCHAR2(35),
 state        VARCHAR2(30),
 country      VARCHAR2(30),
 zip_code     VARCHAR2(10),
 manager_id   NUMBER(7),
 CONSTRAINT s_warehouse_id_pk PRIMARY KEY (warehouse_id)
);
-- *********************************************************************

-- *********************************************************************
-- Inserts data into each table for use in example database.
--
--	Table			Record Count
--	------------------------------------------
-- 	s_customer		15
--	s_department		12
--	s_employee		25
--	s_image			19
--	s_inventory		114
--	s_item			62	
--	s_longtext		34
--	s_order			16
--	s_product		33
--	s_region		5
--	s_title			8	
--	s_warehouse		5
-- *********************************************************************
-- Customer Table
INSERT INTO s_customer VALUES 
	(201, 'UNISPORTS', '55-2066101', '72 VIA BAHIA',
	 'SAO PAOLO', NULL, 'BRAZIL', NULL, 'EXCELLENT',
	 12, 2, 'Customer usually orders large amounts ' ||
	 'and has a high order total.  This is okay as long ' ||
         'as the credit rating remains excellent.', 'N', 'M');

INSERT INTO s_customer VALUES 
	(202, 'SIMMS ATHELETICS', '81-20101', '6741 TAKASHI BLVD.',
	 'OSAKA', NULL, 'JAPAN', NULL, 'POOR', 14, 4, 
	 'Customer should always pay by cash until his credit ' ||
         'rating improves.', 'N', 'M');

INSERT INTO s_customer VALUES 
	(203, 'DELHI SPORTS', '91-10351', '11368 CHANAKYA',
	 'NEW DELHI', NULL, 'INDIA', NULL, 'GOOD', 14, 4,
	 'Customer specializes in baseball equipment and is ' ||
         'the largest retailer in India.', 'N', 'M');

INSERT INTO s_customer VALUES 
	(204, 'WOMANSPORT', '1-206-104-0103', '281 KING STREET',
	 'SEATTLE', 'WASHINGTON', 'USA', '98101', 'EXCELLENT',
	 11, 1, NULL, 'N', 'M');

INSERT INTO s_customer VALUES 
	(205, 'KAM''S SPORTING GOODS', '852-3692888',
	 '15 HENESSEY ROAD', 'HONG KONG', NULL, NULL,
         NULL, 'EXCELLENT', 15, 4, NULL, 'N', 'M');

INSERT INTO s_customer VALUES 
	(206, 'SPORTIQUE', '33-2257201', '172 RUE DE RIVOLI',
         'CANNES', NULL, 'FRANCE', NULL, 'EXCELLENT', 15, 5,
	 'Customer specializes in Soccer.  Likes to order ' ||
	 'accessories in bright colors.', 'N', 'M');

INSERT INTO s_customer VALUES 
	(207, 'SWEET ROCK SPORTS', '234-6036201', '6 SAINT ANTOINE',
	 'LAGOS', NULL, 'NIGERIA', NULL, 'GOOD', NULL, 3, NULL,
	 'N', 'M');

INSERT INTO s_customer VALUES 
	(208, 'MUENCH SPORTS', '49-527454', '435 GRUENESTRASSE', 
	 'STUTTGART', NULL, 'GERMANY', NULL, 'GOOD', 15, 5,
	 'Customer usually pays small orders by cash and large ' ||
	 'orders on credit.', 'N', 'M');

INSERT INTO s_customer VALUES 
	(209, 'BEISBOL SI!', '809-352689', '792 PLAYA DEL MAR',
	 'SAN PEDRO DE MACON''S', NULL, 'DOMINICAN REPUBLIC',
	 NULL, 'EXCELLENT', 11, 1, NULL, 'N', 'M');

INSERT INTO s_customer VALUES 
	(210, 'FUTBOL SONORA', '52-404562', '3 VIA SAGUARO',
	 'NOGALES', NULL, 'MEXICO', NULL, 'EXCELLENT', 12, 2,
	 'Customer is difficult to reach by phone.  Try mail.',
	 'N', 'M');

INSERT INTO s_customer VALUES 
	(211, 'KUHN''S SPORTS', '42-111292', '7 MODRANY', 'PRAGUE',
	 NULL, 'CZECHOSLOVAKIA', NULL, 'EXCELLENT', 15, 5, NULL,
	 'N', 'M');

INSERT INTO s_customer VALUES 
	(212, 'HAMADA SPORT', '20-1209211', '57A CORNICHE',
	 'ALEXANDRIA', NULL, 'EGYPT', NULL, 'EXCELLENT', 13, 3,
	 'Customer orders sea and water equipment.', 'N', 'M');

INSERT INTO s_customer VALUES 
	(213, 'BIG JOHN''S SPORTS EMPORIUM', '1-415-555-6281',
	 '4783 18TH STREET', 'SAN FRANCISCO', 'CA', 'USA', '94117',
	 'EXCELLENT', 11, 1, 'Customer has a dependable credit ' ||
	 'record.', 'N', 'M');

INSERT INTO s_customer VALUES 
	(214, 'OJIBWAY RETAIL', '1-716-555-7171', '415 MAIN STREET',
	 'BUFFALO', 'NY', 'USA', '14202', 'POOR', 11, 1,
	 NULL, 'N', 'M');

INSERT INTO s_customer VALUES 
	(215, 'SPORTA RUSSIA', '7-3892456', '6000 YEKATAMINA',
	 'SAINT PETERSBURG', NULL, 'RUSSIA', NULL, 'POOR',
	 15, 5, 'This customer is very friendly, but has ' ||
	'difficulty paying bills.  Insist upon cash.', 'N', 'M');

-- Department Table
INSERT INTO s_department VALUES (10, 'FINANCE', 1);
INSERT INTO s_department VALUES (31, 'SALES', 1);
INSERT INTO s_department VALUES (32, 'ACCOUNTING', 2);
INSERT INTO s_department VALUES (33, 'MARKETING', 3);
INSERT INTO s_department VALUES (34, 'SECURITY', 4);
INSERT INTO s_department VALUES (35, 'PAYROLL', 5);
INSERT INTO s_department VALUES (41, 'OPERATIONS', 1);
INSERT INTO s_department VALUES (42, 'HUMAN RESOURCES', 2);
INSERT INTO s_department VALUES (43, 'STRATEGIC PLANNING', 3);
INSERT INTO s_department VALUES (44, 'MAINTENANCE', 4);
INSERT INTO s_department VALUES (45, 'TECHNICAL WRITING', 5);
INSERT INTO s_department VALUES (50, 'ADMINISTRATION', 1);

-- Employee Table
INSERT INTO s_employee VALUES 
	(1, 'VELASQUEZ', 'CARMEN', 'cvelasqu', 
	 to_date('03-MAR-90 8:30', 'dd-mon-yy hh24:mi'),
	 NULL, NULL, 'PRESIDENT', 50, 2500, NULL);

INSERT INTO s_employee VALUES 
	(2, 'NGAO', 'LADORIS', 'lngao', '08-MAR-90', NULL,
	 1, 'VP, OPERATIONS', 41, 1450, NULL);

INSERT INTO s_employee VALUES 
	(3, 'NAGAYAMA', 'MIDORI', 'mnagayam', '17-JUN-91',
	 NULL, 1, 'VP, SALES', 31, 1400, NULL);

INSERT INTO s_employee VALUES 
	(4, 'QUICK-TO-SEE', 'MARK', 'mquickto', '07-APR-90',
	 NULL, 1, 'VP, FINANCE', 10, 1450, NULL);

INSERT INTO s_employee VALUES 
	(5, 'ROPEBURN', 'AUDRY', 'aropebur', '04-MAR-90',
	 NULL, 1, 'VP, ADMINISTRATION', 50, 1550, NULL);

INSERT INTO s_employee VALUES 
	(6, 'URGUHART', 'MOLLY', 'murguhar', '18-JAN-91',
	 NULL, 2, 'WAREHOUSE MANAGER', 41, 1200, NULL);

INSERT INTO s_employee VALUES 
	(7, 'MENCHU', 'ROBERTA', 'rmenchu', '14-MAY-90',
	 NULL, 2, 'WAREHOUSE MANAGER', 41, 1250, NULL);

INSERT INTO s_employee VALUES 
	(8, 'BIRI', 'BEN', 'bbiri', '07-APR-90', NULL, 2,
	 'WAREHOUSE MANAGER', 41, 1100, NULL); 

INSERT INTO s_employee VALUES 
	(9, 'CATCHPOLE', 'ANTOINETTE', 'acatchpo', '09-FEB-92',
	 NULL, 2, 'WAREHOUSE MANAGER', 41, 1300, NULL);

INSERT INTO s_employee VALUES 
	(10, 'HAVEL', 'MARTA', 'mhavel', '27-FEB-91', NULL, 2,
	 'WAREHOUSE MANAGER', 41, 1307, NULL);

INSERT INTO s_employee VALUES 
	(11, 'MAGEE', 'COLIN', 'cmagee', '14-MAY-90', NULL,
	 3, 'SALES REPRESENTATIVE', 31, 1400, 10);

INSERT INTO s_employee VALUES 
	(12, 'GILJUM', 'HENRY', 'hgiljum', '18-JAN-92', NULL,
	 3, 'SALES REPRESENTATIVE', 31, 1490, 12.5);

INSERT INTO s_employee VALUES 
	(13, 'SEDEGHI', 'YASMIN', 'ysedeghi', '18-FEB-91',
	 NULL, 3, 'SALES REPRESENTATIVE', 31, 1515, 10);

INSERT INTO s_employee VALUES 
	(14, 'NGUYEN', 'MAI', 'mnguyen', '22-JAN-92', NULL,
	 3, 'SALES REPRESENTATIVE', 31, 1525, 15);

INSERT INTO s_employee VALUES 
	(15, 'DUMAS', 'ANDRE', 'adumas', '09-OCT-91', NULL,
	 3, 'SALES REPRESENTATIVE', 31, 1450, 17.5);

INSERT INTO s_employee VALUES 
	(16, 'MADURO', 'ELENA', 'emaduro', '07-FEB-92', NULL,
	 6, 'STOCK CLERK', 41, 1400, NULL);

INSERT INTO s_employee VALUES 
	(17, 'SMITH', 'GEORGE', 'gsmith', '08-MAR-90',
	 NULL, 6, 'STOCK CLERK', 41, 940, NULL);

INSERT INTO s_employee VALUES 
	(18, 'NOZAKI', 'AKIRA', 'anozaki', '09-FEB-91', NULL,
	 7, 'STOCK CLERK', 41, 1200, NULL);

INSERT INTO s_employee VALUES 
	(19, 'PATEL', 'VIKRAM', 'vpatel', '06-AUG-91', NULL,
	 7, 'STOCK CLERK', 41, 795, NULL);

INSERT INTO s_employee VALUES 
	(20, 'NEWMAN', 'CHAD', 'cnewman', '21-JUL-91', NULL,
	 8, 'STOCK CLERK', 41, 750, NULL);

INSERT INTO s_employee VALUES 
	(21, 'MARKARIAN', 'ALEXANDER', 'amarkari', '26-MAY-91',
	 NULL, 8, 'STOCK CLERK', 41, 850, NULL);

INSERT INTO s_employee VALUES 
	(22, 'CHANG', 'EDDIE', 'echang', '30-NOV-90', NULL,
	 9, 'STOCK CLERK', 41, 800, NULL);

INSERT INTO s_employee VALUES 
	(23, 'PATEL', 'RADHA', 'rpatel', '17-OCT-90', NULL,
	 9, 'STOCK CLERK', 41, 795, NULL);

INSERT INTO s_employee VALUES 
	(24, 'DANCS', 'BELA', 'bdancs', '17-MAR-91', NULL,
	 10, 'STOCK CLERK', 41, 860, NULL);

INSERT INTO s_employee VALUES 
	(25, 'SCHWARTZ', 'SYLVIE', 'sschwart', '09-MAY-91',
	 NULL, 10, 'STOCK CLERK', 41, 1100, NULL);

-- Image Table
INSERT INTO s_image VALUES (1001, 'JTIFF', 'Y', 'bunboot.tif', NULL);
INSERT INTO s_image VALUES (1002, 'JTIFF', 'Y', 'aceboot.tif', NULL);
INSERT INTO s_image VALUES (1003, 'JTIFF', 'Y', 'proboot.tif', NULL);
INSERT INTO s_image VALUES (1011, 'JTIFF', 'Y', 'bunpole.tif', NULL);
INSERT INTO s_image VALUES (1012, 'JTIFF', 'Y', 'acepole.tif', NULL);
INSERT INTO s_image VALUES (1013, 'JTIFF', 'Y', 'propole.tif', NULL);
INSERT INTO s_image VALUES (1291, 'JTIFF', 'Y', 'gpbike.tif', NULL);
INSERT INTO s_image VALUES (1296, 'JTIFF', 'Y', 'himbike.tif', NULL);
INSERT INTO s_image VALUES (1829, 'JTIFF', 'Y', 'safthelm.tif', NULL);
INSERT INTO s_image VALUES (1381, 'JTIFF', 'Y', 'probar.tif', NULL);
INSERT INTO s_image VALUES (1382, 'JTIFF', 'Y', 'curlbar.tif', NULL);
INSERT INTO s_image VALUES (1119, 'JTIFF', 'Y', 'baseball.tif', NULL);
INSERT INTO s_image VALUES (1223, 'JTIFF', 'Y', 'chaphelm.tif', NULL);
INSERT INTO s_image VALUES (1367, 'JTIFF', 'Y', 'grglove.tif', NULL);
INSERT INTO s_image VALUES (1368, 'JTIFF', 'Y', 'alglove.tif', NULL);
INSERT INTO s_image VALUES (1369, 'JTIFF', 'Y', 'stglove.tif', NULL);
INSERT INTO s_image VALUES (1480, 'JTIFF', 'Y', 'cabbat.tif', NULL);
INSERT INTO s_image VALUES (1482, 'JTIFF', 'Y', 'pucbat.tif', NULL);
INSERT INTO s_image VALUES (1486, 'JTIFF', 'Y', 'winbat.tif', NULL);

-- Inventory Table
INSERT INTO s_inventory VALUES (10011, 101, 650, 625, 1100, NULL, NULL);
INSERT INTO s_inventory VALUES (10012, 101, 600, 560, 1000, NULL, NULL);
INSERT INTO s_inventory VALUES (10013, 101, 400, 400, 700, NULL, NULL);
INSERT INTO s_inventory VALUES (10021, 101, 500, 425, 740, NULL, NULL);
INSERT INTO s_inventory VALUES (10022, 101, 300, 200, 350, NULL, NULL);
INSERT INTO s_inventory VALUES (10023, 101, 400, 300, 525, NULL, NULL);
INSERT INTO s_inventory VALUES (20106, 101, 993, 625, 1000, NULL, NULL);
INSERT INTO s_inventory VALUES (20108, 101, 700, 700, 1225, NULL, NULL);
INSERT INTO s_inventory VALUES (20201, 101, 802, 800, 1400, NULL, NULL);
INSERT INTO s_inventory VALUES (20510, 101, 1389, 850, 1400, NULL, NULL);
INSERT INTO s_inventory VALUES (20512, 101, 850, 850, 1450, NULL, NULL);
INSERT INTO s_inventory VALUES (30321, 101, 2000, 1500, 2500, NULL, NULL);
INSERT INTO s_inventory VALUES (30326, 101, 2100, 2000, 3500, NULL, NULL);
INSERT INTO s_inventory VALUES (30421, 101, 1822, 1800, 3150, NULL, NULL);
INSERT INTO s_inventory VALUES (30426, 101, 2250, 2000, 3500, NULL, NULL);
INSERT INTO s_inventory VALUES (30433, 101, 650, 600, 1050, NULL, NULL);
INSERT INTO s_inventory VALUES (32779, 101, 2120, 1250, 2200, NULL, NULL);
INSERT INTO s_inventory VALUES (32861, 101, 505, 500, 875, NULL, NULL);
INSERT INTO s_inventory VALUES (40421, 101, 578, 350, 600, NULL, NULL);
INSERT INTO s_inventory VALUES (40422, 101, 0, 350, 600, 'Phenomenal sales...', '08-FEB-93');
INSERT INTO s_inventory VALUES (41010, 101, 250, 250, 437, NULL, NULL);
INSERT INTO s_inventory VALUES (41020, 101, 471, 450, 750, NULL, NULL);
INSERT INTO s_inventory VALUES (41050, 101, 501, 450, 750, NULL, NULL);
INSERT INTO s_inventory VALUES (41080, 101, 400, 400, 700, NULL, NULL);
INSERT INTO s_inventory VALUES (41100, 101, 350, 350, 600, NULL, NULL);
INSERT INTO s_inventory VALUES (50169, 101, 2530, 1500, 2600, NULL, NULL);
INSERT INTO s_inventory VALUES (50273, 101, 233, 200, 350, NULL, NULL);
INSERT INTO s_inventory VALUES (50417, 101, 518, 500, 875, NULL, NULL);
INSERT INTO s_inventory VALUES (50418, 101, 244, 100, 275, NULL, NULL);
INSERT INTO s_inventory VALUES (50419, 101, 230, 120, 310, NULL, NULL);
INSERT INTO s_inventory VALUES (50530, 101, 669, 400, 700, NULL, NULL);
INSERT INTO s_inventory VALUES (50532, 101, 0, 100, 175, 'Wait for Spring.', '12-APR-93');
INSERT INTO s_inventory VALUES (50536, 101, 173, 100, 175, NULL, NULL);
INSERT INTO s_inventory VALUES (20106, 201, 220, 150, 260, NULL, NULL);
INSERT INTO s_inventory VALUES (20108, 201, 166, 150, 260, NULL, NULL);
INSERT INTO s_inventory VALUES (20201, 201, 320, 200, 350, NULL, NULL);
INSERT INTO s_inventory VALUES (20510, 201, 175, 100, 175, NULL, NULL);
INSERT INTO s_inventory VALUES (20512, 201, 162, 100, 175, NULL, NULL);
INSERT INTO s_inventory VALUES (30321, 201, 96, 80, 140, NULL, NULL);
INSERT INTO s_inventory VALUES (30326, 201, 147, 120, 210, NULL, NULL);
INSERT INTO s_inventory VALUES (30421, 201, 102, 80, 140, NULL, NULL);
INSERT INTO s_inventory VALUES (30426, 201, 200, 120, 210, NULL, NULL);
INSERT INTO s_inventory VALUES (30433, 201, 130, 130, 230, NULL, NULL);
INSERT INTO s_inventory VALUES (32779, 201, 180, 150, 260, NULL, NULL);
INSERT INTO s_inventory VALUES (32861, 201, 132, 80, 140, NULL, NULL);
INSERT INTO s_inventory VALUES (50169, 201, 225, 220, 385, NULL, NULL);
INSERT INTO s_inventory VALUES (50273, 201, 75, 60, 100, NULL, NULL);
INSERT INTO s_inventory VALUES (50417, 201, 82, 60, 100, NULL, NULL);
INSERT INTO s_inventory VALUES (50418, 201, 98, 60, 100, NULL, NULL);
INSERT INTO s_inventory VALUES (50419, 201, 77, 60, 100, NULL, NULL);
INSERT INTO s_inventory VALUES (50530, 201, 62, 60, 100, NULL, NULL);
INSERT INTO s_inventory VALUES (50532, 201, 67, 60, 100, NULL, NULL);
INSERT INTO s_inventory VALUES (50536, 201, 97, 60, 100, NULL, NULL);
INSERT INTO s_inventory VALUES (20510, 301, 69, 40, 100, NULL, NULL);
INSERT INTO s_inventory VALUES (20512, 301, 28, 20, 50, NULL, NULL);
INSERT INTO s_inventory VALUES (30321, 301, 85, 80, 140, NULL, NULL);
INSERT INTO s_inventory VALUES (30421, 301, 102, 80, 140, NULL, NULL);
INSERT INTO s_inventory VALUES (30433, 301, 35, 20, 35, NULL, NULL);
INSERT INTO s_inventory VALUES (32779, 301, 102, 95, 175, NULL, NULL);
INSERT INTO s_inventory VALUES (32861, 301, 57, 50, 100, NULL, NULL);
INSERT INTO s_inventory VALUES (40421, 301, 70, 40, 70, NULL, NULL);
INSERT INTO s_inventory VALUES (40422, 301, 65, 40, 70, NULL, NULL);
INSERT INTO s_inventory VALUES (41010, 301, 59, 40, 70, NULL, NULL);
INSERT INTO s_inventory VALUES (41020, 301, 61, 40, 70, NULL, NULL);
INSERT INTO s_inventory VALUES (41050, 301, 49, 40, 70, NULL, NULL);
INSERT INTO s_inventory VALUES (41080, 301, 50, 40, 70, NULL, NULL);
INSERT INTO s_inventory VALUES (41100, 301, 42, 40, 70, NULL, NULL);
INSERT INTO s_inventory VALUES (20510, 401, 88, 50, 100, NULL, NULL);
INSERT INTO s_inventory VALUES (20512, 401, 75, 75, 140, NULL, NULL);
INSERT INTO s_inventory VALUES (30321, 401, 102, 80, 140, NULL, NULL);
INSERT INTO s_inventory VALUES (30326, 401, 113, 80, 140, NULL, NULL);
INSERT INTO s_inventory VALUES (30421, 401, 85, 80, 140, NULL, NULL);
INSERT INTO s_inventory VALUES (30426, 401, 135, 80, 140, NULL, NULL);
INSERT INTO s_inventory VALUES (30433, 401, 0, 100, 175, 'A defective shipment was sent to Hong Kong and needed to be returned. The soonest ACME can turn this around is early February.', '07-SEP-92');
INSERT INTO s_inventory VALUES (32779, 401, 135, 100, 175, NULL, NULL);
INSERT INTO s_inventory VALUES (32861, 401, 250, 150, 250, NULL, NULL);
INSERT INTO s_inventory VALUES (40421, 401, 47, 40, 70, NULL, NULL);
INSERT INTO s_inventory VALUES (40422, 401, 50, 40, 70, NULL, NULL);
INSERT INTO s_inventory VALUES (41010, 401, 80, 70, 220, NULL, NULL);
INSERT INTO s_inventory VALUES (41020, 401, 91, 70, 220, NULL, NULL);
INSERT INTO s_inventory VALUES (41050, 401, 169, 70, 220, NULL, NULL);
INSERT INTO s_inventory VALUES (41080, 401, 100, 70, 220, NULL, NULL);
INSERT INTO s_inventory VALUES (41100, 401, 75, 70, 220, NULL, NULL);
INSERT INTO s_inventory VALUES (50169, 401, 240, 200, 350, NULL, NULL);
INSERT INTO s_inventory VALUES (50273, 401, 224, 150, 280, NULL, NULL);
INSERT INTO s_inventory VALUES (50417, 401, 130, 120, 210, NULL, NULL);
INSERT INTO s_inventory VALUES (50418, 401, 156, 100, 175, NULL, NULL);
INSERT INTO s_inventory VALUES (50419, 401, 151, 150, 280, NULL, NULL);
INSERT INTO s_inventory VALUES (50530, 401, 119, 100, 175, NULL, NULL);
INSERT INTO s_inventory VALUES (50532, 401, 233, 200, 350, NULL, NULL);
INSERT INTO s_inventory VALUES (50536, 401, 138, 100, 175, NULL, NULL);
INSERT INTO s_inventory VALUES (10012, 10501, 300, 300, 525, NULL, NULL);
INSERT INTO s_inventory VALUES (10013, 10501, 314, 300, 525, NULL, NULL);
INSERT INTO s_inventory VALUES (10022, 10501, 502, 300, 525, NULL, NULL);
INSERT INTO s_inventory VALUES (10023, 10501, 500, 300, 525, NULL, NULL);
INSERT INTO s_inventory VALUES (20106, 10501, 150, 100, 175, NULL, NULL);
INSERT INTO s_inventory VALUES (20108, 10501, 222, 200, 350, NULL, NULL);
INSERT INTO s_inventory VALUES (20201, 10501, 275, 200, 350, NULL, NULL);
INSERT INTO s_inventory VALUES (20510, 10501, 57, 50, 87, NULL, NULL);
INSERT INTO s_inventory VALUES (20512, 10501, 62, 50, 87, NULL, NULL);
INSERT INTO s_inventory VALUES (30321, 10501, 194, 150, 275, NULL, NULL);
INSERT INTO s_inventory VALUES (30326, 10501, 277, 250, 440, NULL, NULL);
INSERT INTO s_inventory VALUES (30421, 10501, 190, 150, 275, NULL, NULL);
INSERT INTO s_inventory VALUES (30426, 10501, 423, 250, 450, NULL, NULL);
INSERT INTO s_inventory VALUES (30433, 10501, 273, 200, 350, NULL, NULL);
INSERT INTO s_inventory VALUES (32779, 10501, 280, 200, 350, NULL, NULL);
INSERT INTO s_inventory VALUES (32861, 10501, 288, 200, 350, NULL, NULL);
INSERT INTO s_inventory VALUES (40421, 10501, 97, 80, 140, NULL, NULL);
INSERT INTO s_inventory VALUES (40422, 10501, 90, 80, 140, NULL, NULL);
INSERT INTO s_inventory VALUES (41010, 10501, 151, 140, 245, NULL, NULL);
INSERT INTO s_inventory VALUES (41020, 10501, 224, 140, 245, NULL, NULL);
INSERT INTO s_inventory VALUES (41050, 10501, 157, 140, 245, NULL, NULL);
INSERT INTO s_inventory VALUES (41080, 10501, 159, 140, 245, NULL, NULL);
INSERT INTO s_inventory VALUES (41100, 10501, 141, 140, 245, NULL, NULL);

-- Item Table
INSERT INTO s_item VALUES (100, 1, 10011, 135, 500, 500);
INSERT INTO s_item VALUES (100, 2, 10013, 380, 400, 400);
INSERT INTO s_item VALUES (100, 3, 10021, 14, 500, 500);
INSERT INTO s_item VALUES (100, 5, 30326, 582, 600, 600);
INSERT INTO s_item VALUES (100, 7, 41010, 8, 250, 250);
INSERT INTO s_item VALUES (100, 6, 30433, 20, 450, 450);
INSERT INTO s_item VALUES (100, 4, 10023, 36, 400, 400);
INSERT INTO s_item VALUES (101, 1, 30421, 16, 15, 15);
INSERT INTO s_item VALUES (101, 3, 41010, 8, 20, 20);
INSERT INTO s_item VALUES (101, 5, 50169, 4.29, 40, 40);
INSERT INTO s_item VALUES (101, 6, 50417, 80, 27, 27);
INSERT INTO s_item VALUES (101, 7, 50530, 45, 50, 50);
INSERT INTO s_item VALUES (101, 4, 41100, 45, 35, 35);
INSERT INTO s_item VALUES (101, 2, 40422, 50, 30, 30);
INSERT INTO s_item VALUES (102, 1, 20108, 28, 100, 100);
INSERT INTO s_item VALUES (102, 2, 20201, 123, 45, 45);
INSERT INTO s_item VALUES (103, 1, 30433, 20, 15, 15);
INSERT INTO s_item VALUES (103, 2, 32779, 7, 11, 11);
INSERT INTO s_item VALUES (104, 1, 20510, 9, 7, 7);
INSERT INTO s_item VALUES (104, 4, 30421, 16, 35, 35);
INSERT INTO s_item VALUES (104, 2, 20512, 8, 12, 12);
INSERT INTO s_item VALUES (104, 3, 30321, 1669, 19, 19);
INSERT INTO s_item VALUES (105, 1, 50273, 22.89, 16, 16);
INSERT INTO s_item VALUES (105, 3, 50532, 47, 28, 28);
INSERT INTO s_item VALUES (105, 2, 50419, 80, 13, 13);
INSERT INTO s_item VALUES (106, 1, 20108, 28, 46, 46);
INSERT INTO s_item VALUES (106, 4, 50273, 22.89, 75, 75);
INSERT INTO s_item VALUES (106, 5, 50418, 75, 98, 98);
INSERT INTO s_item VALUES (106, 6, 50419, 80, 27, 27);
INSERT INTO s_item VALUES (106, 2, 20201, 123, 21, 21);
INSERT INTO s_item VALUES (106, 3, 50169, 4.29, 125, 125);
INSERT INTO s_item VALUES (107, 1, 20106, 11, 50, 50);
INSERT INTO s_item VALUES (107, 3, 20201, 115, 130, 130);
INSERT INTO s_item VALUES (107, 5, 30421, 16, 55, 55);
INSERT INTO s_item VALUES (107, 4, 30321, 1669, 75, 75);
INSERT INTO s_item VALUES (107, 2, 20108, 28, 22, 22);
INSERT INTO s_item VALUES (108, 1, 20510, 9, 9, 9);
INSERT INTO s_item VALUES (108, 6, 41080, 35, 50, 50);
INSERT INTO s_item VALUES (108, 7, 41100, 45, 42, 42);
INSERT INTO s_item VALUES (108, 5, 32861, 60, 57, 57);
INSERT INTO s_item VALUES (108, 2, 20512, 8, 18, 18);
INSERT INTO s_item VALUES (108, 4, 32779, 7, 60, 60);
INSERT INTO s_item VALUES (108, 3, 30321, 1669, 85, 85);
INSERT INTO s_item VALUES (109, 1, 10011, 140, 150, 150);
INSERT INTO s_item VALUES (109, 5, 30426, 18.25, 500, 500);
INSERT INTO s_item VALUES (109, 7, 50418, 75, 43, 43);
INSERT INTO s_item VALUES (109, 6, 32861, 60, 50, 50);
INSERT INTO s_item VALUES (109, 4, 30326, 582, 1500, 1500);
INSERT INTO s_item VALUES (109, 2, 10012, 175, 600, 600);
INSERT INTO s_item VALUES (109, 3, 10022, 21.95, 300, 300);
INSERT INTO s_item VALUES (110, 1, 50273, 22.89, 17, 17);
INSERT INTO s_item VALUES (110, 2, 50536, 50, 23, 23);
INSERT INTO s_item VALUES (111, 1, 40421, 65, 27, 27);
INSERT INTO s_item VALUES (111, 2, 41080, 35, 29, 29);
INSERT INTO s_item VALUES (97, 1, 20106, 9, 1000, 1000);
INSERT INTO s_item VALUES (97, 2, 30321, 1500, 50, 50);
INSERT INTO s_item VALUES (98, 1, 40421, 85, 7, 7);
INSERT INTO s_item VALUES (99, 1, 20510, 9, 18, 18);
INSERT INTO s_item VALUES (99, 2, 20512, 8, 25, 25);
INSERT INTO s_item VALUES (99, 3, 50417, 80, 53, 53);
INSERT INTO s_item VALUES (99, 4, 50530, 45, 69, 69);
INSERT INTO s_item VALUES (112, 1, 20106, 11, 50, 50);

-- Longtext Table
INSERT INTO s_longtext VALUES (1017, 'N', NULL,
   'Protective knee pads for any number of physical activities including ' ||
   'bicycling and skating (4-wheel, in-line, and ice).  Also provide ' ||
   'support for stress activities such as weight-lifting.  Velcro belts ' ||
   'allow easy adjustment for any size and snugness of fit.  Hardened ' ||
   'plastic shell comes in a variety of colors, so you can buy a pair to ' ||
   'match every outfit.  Can also be worn at the beach to cover ' ||
   'particularly ugly knees.');

INSERT INTO s_longtext VALUES (1019, 'N', NULL,
   'Protective elbow pads for any number of physical activities including ' ||
   'bicycling and skating (4-wheel, in-line, and ice).  Also provide ' ||
   'support for stress activities such as weight-lifting.  Velcro belts ' ||
   'allow easy adjustment for any size and snugness of fit.  Hardened ' ||
   'plastic shell comes in a variety of colors, so you can buy a pair to ' ||
   'match every outfit.');

INSERT INTO s_longtext VALUES (1037, NULL, NULL, NULL);

INSERT INTO s_longtext VALUES (1039, NULL, NULL, NULL);

INSERT INTO s_longtext VALUES (1043, NULL, NULL, NULL);

INSERT INTO s_longtext VALUES (1286, 'N', NULL,
   'Don''t slack off--try the Slaker Water Bottle.  With its 1 quart ' ||
   'capacity, this is the only water bottle you''ll need.  It''s ' ||
   'lightweight, durable, and guaranteed for life to be leak proof.  It ' ||
   'comes with a convenient velcro strap so it ' ||
   'can be conveniently attached to your bike or other sports equipment.');

INSERT INTO s_longtext VALUES (1368, NULL, NULL, NULL);

INSERT INTO s_longtext VALUES (517, NULL, NULL, NULL);

INSERT INTO s_longtext VALUES (518, 'N', NULL,
   'Perfect for the beginner.  Rear entry (easy to put on with only one ' ||
   'buckle), weight control adjustment on side of boot for easy access, ' ||
   'comes in a wide variety of colors to match every outfit.');

INSERT INTO s_longtext VALUES (519, 'N', NULL,
   'If you have mastered the basic techniques you are ready for the Ace Ski ' ||
   'Boot.  This intermediate boot comes as a package with self adjustable ' ||
   'bindings that will adapt to your skill and speed. The boot is designed ' ||
   'for extra grip on slopes and jumps.');

INSERT INTO s_longtext VALUES (520, 'N', NULL,
   'The Pro ski boot is an advanced boot that combines high tech and ' ||
   'comfort.  It''s made of fiber that will mold to your foot with body ' ||
   'heat.  If you''re after perfection, don''t look any further: this is it!');

INSERT INTO s_longtext VALUES (527, NULL, NULL, NULL);

INSERT INTO s_longtext VALUES (528, 'N', NULL,
   'Lightweight aluminum pole, comes in a variety of sizes and neon ' ||
   'colors.  Comfortable adjustable straps.');

INSERT INTO s_longtext VALUES (529, NULL, NULL, NULL);
INSERT INTO s_longtext VALUES (530, NULL, NULL, NULL);
INSERT INTO s_longtext VALUES (557, NULL, NULL, NULL);
INSERT INTO s_longtext VALUES (587, NULL, NULL, NULL);
INSERT INTO s_longtext VALUES (607, NULL, NULL, NULL);
INSERT INTO s_longtext VALUES (613, NULL, NULL, NULL);
INSERT INTO s_longtext VALUES (615, NULL, NULL, NULL);
INSERT INTO s_longtext VALUES (676, NULL, NULL, NULL);
INSERT INTO s_longtext VALUES (708, NULL, NULL, NULL);
INSERT INTO s_longtext VALUES (780, NULL, NULL, NULL);
INSERT INTO s_longtext VALUES (828, NULL, NULL, NULL);
INSERT INTO s_longtext VALUES (833, NULL, NULL, NULL);
INSERT INTO s_longtext VALUES (924, NULL, NULL, NULL);
INSERT INTO s_longtext VALUES (925, NULL, NULL, NULL);
INSERT INTO s_longtext VALUES (926, NULL, NULL, NULL);
INSERT INTO s_longtext VALUES (927, NULL, NULL, NULL);
INSERT INTO s_longtext VALUES (928, NULL, NULL, NULL);
INSERT INTO s_longtext VALUES (929, NULL, NULL, NULL);

INSERT INTO s_longtext VALUES (933, 'N', NULL,
   'The widest, strongest, and knobbiest tires for mountain bike ' ||
   'enthusiasts.  Guaranteed to withstand pummelling that will reduce most ' ||
   'bicycles (except for the Himalayan) to scrap iron.  These tires can ' ||
   'carry you to places where nobody would want to bicycle.  Sizes to ' ||
   'fit all makes of mountain bike including wide and super wide rims.  ' ||
   'Steel-banded radial models are also available by direct factory order.');

INSERT INTO s_longtext VALUES (940, NULL, NULL, NULL);

-- Order Table
INSERT INTO s_order VALUES (100, 204, '31-AUG-92', '10-SEP-92', 11, 601100, 'CREDIT', 'Y');
INSERT INTO s_order VALUES (101, 205, '31-AUG-92', '15-SEP-92', 14, 8056.6, 'CREDIT', 'Y');
INSERT INTO s_order VALUES (102, 206, '01-SEP-92', '08-SEP-92', 15, 8335, 'CREDIT', 'Y');
INSERT INTO s_order VALUES (103, 208, '02-SEP-92', '22-SEP-92', 15, 377, 'CASH', 'Y');
INSERT INTO s_order VALUES (104, 208, '03-SEP-92', '23-SEP-92', 15, 32430, 'CREDIT', 'Y');
INSERT INTO s_order VALUES (105, 209, '04-SEP-92', '18-SEP-92', 11, 2722.24, 'CREDIT', 'Y');
INSERT INTO s_order VALUES (106, 210, '07-SEP-92', '15-SEP-92', 12, 15634, 'CREDIT', 'Y');
INSERT INTO s_order VALUES (107, 211, '07-SEP-92', '21-SEP-92', 15, 142171, 'CREDIT', 'Y');
INSERT INTO s_order VALUES (108, 212, '07-SEP-92', '10-SEP-92', 13, 149570, 'CREDIT', 'Y');
INSERT INTO s_order VALUES (109, 213, '08-SEP-92', '28-SEP-92', 11, 1020935, 'CREDIT', 'Y');
INSERT INTO s_order VALUES (110, 214, '09-SEP-92', '21-SEP-92', 11, 1539.13, 'CASH', 'Y');
INSERT INTO s_order VALUES (111, 204, '09-SEP-92', '21-SEP-92', 11, 2770, 'CASH', 'Y');
INSERT INTO s_order VALUES (97, 201, '28-AUG-92', '17-SEP-92', 12, 84000, 'CREDIT', 'Y');
INSERT INTO s_order VALUES (98, 202, '31-AUG-92', '10-SEP-92', 14, 595, 'CASH', 'Y');
INSERT INTO s_order VALUES (99, 203, '31-AUG-92', '18-SEP-92', 14, 7707, 'CREDIT', 'Y');
INSERT INTO s_order VALUES (112, 210, '31-AUG-92', '10-SEP-92', 12, 550, 'CREDIT', 'Y');

-- Product Table
INSERT INTO s_product VALUES (10011, 'BUNNY BOOT', 'BEGINNER''S SKI BOOT', 518, 1001, 150, NULL);
INSERT INTO s_product VALUES (10012, 'ACE SKI BOOT', 'INTERMEDIATE SKI BOOT', 519, 1002, 200, NULL);
INSERT INTO s_product VALUES (10013, 'PRO SKI BOOT', 'ADVANCED SKI BOOT', 520, 1003, 410, NULL);
INSERT INTO s_product VALUES (10021, 'BUNNY SKI POLE', 'BEGINNER''S SKI POLE', 528, 1011, 16.25, NULL);
INSERT INTO s_product VALUES (10022, 'ACE SKI POLE', 'INTERMEDIATE SKI POLE', 529, 1012, 21.95, NULL);
INSERT INTO s_product VALUES (10023, 'PRO SKI POLE', 'ADVANCED SKI POLE', 530, 1013, 40.95, NULL);
INSERT INTO s_product VALUES (20106, 'JUNIOR SOCCER BALL', 'JUNIOR SOCCER BALL', 613, NULL, 11, NULL);
INSERT INTO s_product VALUES (20108, 'WORLD CUP SOCCER BALL', 'WORLD CUP SOCCER BALL', 615, NULL, 28, NULL);
INSERT INTO s_product VALUES (20201, 'WORLD CUP NET', 'WORLD CUP NET', 708, NULL, 123, NULL);
INSERT INTO s_product VALUES (20510, 'BLACK HAWK KNEE PADS', 'KNEE PADS, PAIR', 1017, NULL, 9, NULL);
INSERT INTO s_product VALUES (20512, 'BLACK HAWK ELBOW PADS', 'ELBOW PADS, PAIR', 1019, NULL, 8, NULL);
INSERT INTO s_product VALUES (30321, 'GRAND PRIX BICYCLE', 'ROAD BICYCLE', 828, 1291, 1669, NULL);
INSERT INTO s_product VALUES (30326, 'HIMALAYA BICYCLE', 'MOUNTAIN BICYCLE', 833, 1296, 582, NULL);
INSERT INTO s_product VALUES (30421, 'GRAND PRIX BICYCLE TIRES', 'ROAD BICYCLE TIRES', 927, NULL, 16, NULL);
INSERT INTO s_product VALUES (30426, 'HIMALAYA TIRES', 'MOUNTAIN BICYCLE TIRES', 933, NULL, 18.25, NULL);
INSERT INTO s_product VALUES (30433, 'NEW AIR PUMP', 'TIRE PUMP', 940, NULL, 20, NULL);
INSERT INTO s_product VALUES (32779, 'SLAKER WATER BOTTLE', 'WATER BOTTLE', 1286, NULL, 7, NULL);
INSERT INTO s_product VALUES (32861, 'SAFE-T HELMET', 'BICYCLE HELMET', 1368, 1829, 60, NULL);
INSERT INTO s_product VALUES (40421, 'ALEXEYER PRO LIFTING BAR', 'STRAIGHT BAR', 928, 1381, 65, NULL);
INSERT INTO s_product VALUES (40422, 'PRO CURLING BAR', 'CURLING BAR', 929, 1382, 50, NULL);
INSERT INTO s_product VALUES (41010, 'PROSTAR 10 POUND WEIGHT', 'TEN POUND WEIGHT', 517, NULL, 8, NULL);
INSERT INTO s_product VALUES (41020, 'PROSTAR 20 POUND WEIGHT', 'TWENTY POUND WEIGHT', 527, NULL, 12, NULL);
INSERT INTO s_product VALUES (41050, 'PROSTAR 50 POUND WEIGHT', 'FIFTY POUND WEIGHT', 557, NULL, 25, NULL);
INSERT INTO s_product VALUES (41080, 'PROSTAR 80 POUND WEIGHT', 'EIGHTY POUND WEIGHT', 587, NULL, 35, NULL);
INSERT INTO s_product VALUES (41100, 'PROSTAR 100 POUND WEIGHT', 'ONE HUNDRED POUND WEIGHT', 607, NULL, 45, NULL);
INSERT INTO s_product VALUES (50169, 'MAJOR LEAGUE BASEBALL', 'BASEBALL', 676, 1119, 4.29, NULL);
INSERT INTO s_product VALUES (50273, 'CHAPMAN HELMET', 'BATTING HELMET', 780, 1223, 22.89, NULL);
INSERT INTO s_product VALUES (50417, 'GRIFFEY GLOVE', 'OUTFIELDER''S GLOVE', 924, 1367, 80, NULL);
INSERT INTO s_product VALUES (50418, 'ALOMAR GLOVE', 'INFIELDER''S GLOVE', 925, 1368, 75, NULL);
INSERT INTO s_product VALUES (50419, 'STEINBACH GLOVE', 'CATCHER''S GLOVE', 926, 1369, 80, NULL);
INSERT INTO s_product VALUES (50530, 'CABRERA BAT', 'THIRTY INCH BAT', 1037, 1480, 45, NULL);
INSERT INTO s_product VALUES (50532, 'PUCKETT BAT', 'THIRTY-TWO INCH BAT', 1039, 1482, 47, NULL);
INSERT INTO s_product VALUES (50536, 'WINFIELD BAT', 'THIRTY-SIX INCH BAT', 1043, 1486, 50, NULL);

-- Region Table
INSERT INTO S_REGION VALUES (1, 'NORTH AMERICA');
INSERT INTO S_REGION VALUES (2, 'SOUTH AMERICA');
INSERT INTO S_REGION VALUES (3, 'AFRICA / MIDDLE EAST');
INSERT INTO S_REGION VALUES (4, 'ASIA');
INSERT INTO S_REGION VALUES (5, 'EUROPE');

-- Title Table
INSERT INTO S_TITLE VALUES ('PRESIDENT');
INSERT INTO S_TITLE VALUES ('SALES REPRESENTATIVE');
INSERT INTO S_TITLE VALUES ('STOCK CLERK');
INSERT INTO S_TITLE VALUES ('VP, ADMINISTRATION');
INSERT INTO S_TITLE VALUES ('VP, FINANCE');
INSERT INTO S_TITLE VALUES ('VP, OPERATIONS');
INSERT INTO S_TITLE VALUES ('VP, SALES');
INSERT INTO S_TITLE VALUES ('WAREHOUSE MANAGER');

-- Warehouse Table
INSERT INTO s_warehouse VALUES (101, 1, '283 King Street', 'Seattle', 'WA', 'USA', NULL, NULL, 6);
INSERT INTO s_warehouse VALUES (10501, 5, '5 Modrany', 'Bratislava', NULL, 'Czechozlovakia', NULL, NULL, 10);
INSERT INTO s_warehouse VALUES (201, 2, '68 Via Centrale', 'Sao Paolo', NULL, 'Brazil', NULL, NULL, 7);
INSERT INTO s_warehouse VALUES (301, 3, '6921 King Way', 'Lagos', NULL, 'Nigeria', NULL, NULL, 8);
INSERT INTO s_warehouse VALUES (401, 4, '86 Chu Street', 'Hong Kong', NULL, NULL, NULL, NULL, 9);
-- *********************************************************************

-- *********************************************************************
-- Alters tables and adds foreign key constraints for use in example database.

-- Foreign Key Table/Column	Primary Key Table/Column Referenced
-- -------------------------------------------------------------
-- s_department/region_id	s_region/region_id
-- s_employee/manager_id	s_employee/employee_id
-- s_employee/department_id	s_department/department_id
-- s_employee/title		s_title/title
-- s_customer/sales_rep_id	s_employee/employee_id
-- s_customer/region_id	s_region/region_id
-- s_order/customer_id		s_customer/customer_id
-- s_order/sales_rep_id	s_employee/employee_id
-- s_product/image_id		s_image/image_id
-- s_product/longtext_id	s_longtext/longtext_id
-- s_item/order_id		s_order/order_id
-- s_item/product_id		s_product/product_id
-- s_warehouse/manager_id	s_employee/employee_id
-- s_warehouse/region_id	s_region/region_id
-- s_inventory/product_id	s_product/product_id
-- s_inventory/warehouse_id	s_warehouse/warehouse_id
-- *********************************************************************
-- Department Table
ALTER TABLE s_department
ADD   CONSTRAINT s_department_region_id_fk
FOREIGN KEY (region_id) REFERENCES s_region (region_id);

-- Employee Table
ALTER TABLE s_employee
ADD   CONSTRAINT s_employee_manager_id_fk
FOREIGN KEY (manager_id) REFERENCES s_employee (employee_id);

ALTER TABLE s_employee
ADD   CONSTRAINT s_employee_department_id_fk
FOREIGN KEY (department_id) REFERENCES s_department (department_id);

ALTER TABLE s_employee
ADD   CONSTRAINT s_employee_title_fk
FOREIGN KEY (title) REFERENCES s_title (title);

-- Customer Table
ALTER TABLE s_customer
ADD   CONSTRAINT s_customer_sales_rep_id_fk
FOREIGN KEY (sales_rep_id) REFERENCES s_employee (employee_id);

ALTER TABLE s_customer
ADD   CONSTRAINT s_customer_region_id_fk
FOREIGN KEY (region_id) REFERENCES s_region (region_id);

-- Order Table
ALTER TABLE s_order
ADD   CONSTRAINT s_order_customer_id_fk
FOREIGN KEY (customer_id) REFERENCES s_customer (customer_id);

ALTER TABLE s_order
ADD   CONSTRAINT s_order_sales_rep_id_fk
FOREIGN KEY (sales_rep_id) REFERENCES s_employee (employee_id);

-- Product Table
ALTER TABLE s_product
ADD   CONSTRAINT s_product_image_id_fk
FOREIGN KEY (image_id) REFERENCES s_image (image_id);

ALTER TABLE s_product
ADD   CONSTRAINT s_product_longtext_id_fk
FOREIGN KEY (longtext_id) REFERENCES s_longtext (longtext_id);

-- Item Table
ALTER TABLE s_item
ADD   CONSTRAINT s_item_order_id_fk
FOREIGN KEY (order_id) REFERENCES s_order (order_id);

ALTER TABLE s_item
ADD   CONSTRAINT s_item_product_id_fk
FOREIGN KEY (product_id) REFERENCES s_product (product_id);

-- Warehouse Table
ALTER TABLE s_warehouse
ADD   CONSTRAINT s_warehouse_manager_id_fk
FOREIGN KEY (manager_id) REFERENCES s_employee (employee_id);

ALTER TABLE s_warehouse
ADD   CONSTRAINT s_warehouse_region_id_fk
FOREIGN KEY (region_id) REFERENCES s_region (region_id);

-- Inventory Table
ALTER TABLE s_inventory
ADD   CONSTRAINT s_inventory_product_id_fk
FOREIGN KEY (product_id) REFERENCES s_product (product_id);

ALTER TABLE s_inventory
ADD   CONSTRAINT s_inventory_warehouse_id_fk
FOREIGN KEY (warehouse_id) REFERENCES s_warehouse (warehouse_id);
-- *********************************************************************

COMMIT;

SPOOL OFF