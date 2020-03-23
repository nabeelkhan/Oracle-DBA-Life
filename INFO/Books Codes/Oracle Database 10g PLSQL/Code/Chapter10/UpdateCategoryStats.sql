/*
 * UpdateCategoryStats.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates a user defined triggers.
 */
REM UpdateCategoryStats.sql
REM This is an example of a DML trigger.

CREATE OR REPLACE TRIGGER UpdateCategoryStats
  /* Keeps the category_stats table up-to-date with changes made
     to the books table. */
  AFTER INSERT OR DELETE OR UPDATE ON books
DECLARE
  CURSOR c_Statistics IS
    SELECT category,
           COUNT(*) total_books,
           AVG(price) average_price
      FROM books
      GROUP BY category;
BEGIN
  /* First delete from category_stats.  This will clear the
     statistics, and is necessary to account for the deletion
     of all books in a given category */
  DELETE FROM category_stats;

  /* Now loop through each category, and insert the appropriate row into
     category_stats. */
  FOR v_StatsRecord in c_Statistics LOOP
    INSERT INTO category_stats (category, total_books, average_price)
      VALUES (v_StatsRecord.category, v_StatsRecord.total_books,
              v_StatsRecord.average_price);
  END LOOP;
END UpdateCategoryStats;
/
show errors
