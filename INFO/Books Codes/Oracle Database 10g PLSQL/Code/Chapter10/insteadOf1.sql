/*
 * insteadOf1.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates user defined triggers.
 */

SET ECHO ON

BEGIN
  FOR i IN (SELECT   null
            FROM     user_triggers
            WHERE    trigger_name = 'INSERTBOOKSAUTHORS') LOOP
    EXECUTE IMMEDIATE 'DROP TRIGGER InsertBooksAuthors';
  END LOOP;
END;
/

BEGIN
  FOR i IN (SELECT   null
            FROM     user_views
            WHERE    view_name = 'BOOKS_AUTHORS') LOOP
    EXECUTE IMMEDIATE 'DROP VIEW books_authors';
  END LOOP;
END;
/

CREATE OR REPLACE VIEW books_authors AS
  SELECT b.isbn, b.title, a.first_name, a.last_name
    FROM books b, authors a
    WHERE b.author1 = a.id
       OR b.author2 = a.id
       OR b.author3 = a.id;

-- This will fail because the view is non-updatable
INSERT INTO books_authors (isbn, title, first_name, last_name)
  VALUES ('72230665', 'Oracle Database 10g PL/SQL Programming',
          'Joe', 'Blow');
