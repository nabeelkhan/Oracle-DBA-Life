/*
 * LogCreations.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script builds DDL_CREATIONS table and SYSTEM trigger.
 */

SET ECHO ON

BEGIN
  FOR i IN (SELECT   null
            FROM     user_tables
            WHERE    table_name = 'DDL_CREATIONS') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ddl_creations';
  END LOOP;
END;
/

CREATE TABLE ddl_creations (
  user_id       VARCHAR2(30),
  object_type   VARCHAR2(20),
  object_name   VARCHAR2(30),
  object_owner  VARCHAR2(30),
  creation_date DATE);

CREATE OR REPLACE TRIGGER LogCreations
  AFTER CREATE ON SCHEMA
BEGIN
  INSERT INTO ddl_creations (user_id, object_type, object_name,
                             object_owner, creation_date)
    VALUES (USER, ORA_DICT_OBJ_TYPE, ORA_DICT_OBJ_NAME,
            ORA_DICT_OBJ_OWNER, SYSDATE);
END LogCreations;
/

show errors
