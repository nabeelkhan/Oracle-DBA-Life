/*
 * insertAcademicRecords.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script inserts values into STUDENTS and CLASSES tables.
 */

INSERT
INTO students
VALUES
(1,3,'Political Science','Boxer','Barbara','');

INSERT
INTO students
VALUES
(2,3,'History','MacDermott','Donal','');

INSERT
INTO students
VALUES
(3,3,'Science','Einstein','Albert','');

INSERT
INTO classes
VALUES
('PoS',101,30,3,'Introduction to Political Science');

INSERT
INTO classes
VALUES
('His',101,30,3,'Introduction to History');

INSERT
INTO classes
VALUES
('Sci',101,30,3,'Introduction to Science');
