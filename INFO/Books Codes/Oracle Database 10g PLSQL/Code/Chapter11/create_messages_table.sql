/*
 * create_messages_table.sql
 * Chapter 11, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script builds table an object for DBMS_ALERT triggers.
 */

BEGIN
  FOR i IN (SELECT null
            FROM user_tables
            WHERE table_name = 'MESSAGES') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE messages CASCADE CONSTRAINTS';
  END LOOP;
END;
/

BEGIN
  FOR i IN (SELECT null
            FROM user_tables
            WHERE table_name = 'MESSAGES_ALERTS') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE messages_alerts CASCADE CONSTRAINTS';
  END LOOP;
END;
/

CREATE TABLE messages
(message_id               INTEGER             NOT NULL
,message_source           VARCHAR2(30 CHAR)   NOT NULL
,message_destination      VARCHAR2(30 CHAR)   NOT NULL
,message                  VARCHAR2(30 CHAR)   NOT NULL
,CONSTRAINT message_pk    PRIMARY KEY (message_id));

INSERT
INTO     messages
VALUES (1,'PLSQL','USERA','Keep your powder dry!');

INSERT
INTO     messages
VALUES (2,'PLSQL','USERA','Meet yourself in St. Louis');

INSERT
INTO     messages
VALUES (3,'PLSQL','USERA','Cry in your coffee.');

CREATE TABLE messages_alerts
(message                  VARCHAR2(30 CHAR)   NOT NULL);
