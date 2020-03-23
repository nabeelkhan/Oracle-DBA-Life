/*
 * query_record1.sql
 * Chapter 5, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script verifies the success of the following programs.
 *  - create_record1.sql
 *  - create_record2.sql
 *  - create_record3.sql
 */

COL individual_id   FORMAT 9,999
COL first_name      FORMAT A14
COL middle_initial  FORMAT A1
COL last_name       FORMAT A14

SELECT   individual_id
,        first_name
,        middle_initial
,        last_name
FROM     individuals
ORDER BY 1;

COL address_id      FORMAT 9,999
COL individual_id   FORMAT 9,999
COL street_address1 FORMAT A16
COL city            FORMAT A14
COL state           FORMAT A2
COL country_code    FORMAT A3

SELECT   address_id
,        individual_id
,        street_address1
,        city
,        state
,        country_code
FROM     addresses
ORDER BY 1;
