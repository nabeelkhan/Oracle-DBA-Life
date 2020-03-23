/*
 * logInventoryChanges1.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script builds INVENTORY_AUDIT table and trigger w/predicates.
 */

SET ECHO ON

BEGIN
  FOR i IN (SELECT   null
            FROM     user_tables
            WHERE    table_name = 'INVENTORY_AUDIT') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE inventory_audit';
  END LOOP;
END;
/

CREATE TABLE inventory_audit (
  change_type     CHAR(1) NOT NULL,
  changed_by      VARCHAR2(8) NOT NULL,
  timestamp       DATE NOT NULL,
  old_isbn        CHAR(10),
  new_isbn        CHAR(10),
  old_status      VARCHAR2(25),
  new_status      VARCHAR2(25),
  old_status_date DATE,
  new_status_date DATE,
  old_amount      NUMBER,
  new_amount      NUMBER
);

CREATE OR REPLACE TRIGGER LogInventoryChanges
  BEFORE INSERT OR DELETE OR UPDATE ON inventory
  FOR EACH ROW
DECLARE
  v_ChangeType CHAR(1);
BEGIN
  /* Use 'I' for an INSERT, 'D' for DELETE, and 'U' for UPDATE. */
  IF INSERTING THEN
    v_ChangeType := 'I';
  ELSIF UPDATING THEN
    v_ChangeType := 'U';
  ELSE
    v_ChangeType := 'D';
  END IF;

  /* Record all the changes made to inventory in
     inventory_audit. Use SYSDATE to generate the timestamp, and
     USER to return the userid of the current user. */
  INSERT INTO inventory_audit
    (change_type, changed_by, timestamp,
     old_isbn, old_status, old_status_date, old_amount,
     new_isbn, new_status, new_status_date, new_amount)
  VALUES
    (v_ChangeType, USER, SYSDATE,
     :old.isbn, :old.status, :old.status_date, :old.amount,
     :new.isbn, :new.status, :new.status_date, :new.amount);
END LogInventoryChanges;
/
show errors
