-- ***************************************************************************
-- File: 10_2.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 10_2.lis

REVOKE CREATE TABLE, CREATE CLUSTER, CREATE SYNONYM, CREATE VIEW, 
   CREATE SEQUENCE, CREATE DATABASE LINK FROM CONNECT;

SPOOL OFF
