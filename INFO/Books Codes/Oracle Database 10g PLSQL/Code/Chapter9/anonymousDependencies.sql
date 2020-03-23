/*
 * anonymousDependencies.sql
 * Chapter 9, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates anonymous dependencies in packages.
 */

CREATE OR REPLACE PACKAGE SimplePkg AS
  v_GlobalVar NUMBER;
  PROCEDURE UpdateVar;
END SimplePkg;
/

CREATE OR REPLACE PACKAGE BODY SimplePkg AS
  PROCEDURE UpdateVar IS
  BEGIN
    v_GlobalVar := 7;
  END UpdateVar;
END SimplePkg;
/
