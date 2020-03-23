/*
 * createTempTable.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script builds the TEMP_TABLE table.
 */

SET ECHO ON

BEGIN
  FOR i IN (SELECT   null
            FROM     user_tables
            WHERE    table_name = 'TEMP_TABLE') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE temp_table';
  END LOOP;
END;
/

CREATE TABLE temp_table (
  num_col    NUMBER,
  char_col   VARCHAR2(200)
  );

