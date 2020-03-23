/*
 * logInventoryChanges2.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script tests the INVENTORY trigger.
 */

SET ECHO ON

UPDATE inventory
  SET amount = 2000
  WHERE isbn IN ('72223049', '72223855');

SELECT change_type, old_amount, new_amount FROM inventory_audit;
