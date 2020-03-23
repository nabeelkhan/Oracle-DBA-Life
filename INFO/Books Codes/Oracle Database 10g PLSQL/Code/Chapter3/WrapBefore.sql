CREATE OR REPLACE PROCEDURE author_book_count
AS
   v_first_name authors.first_name%TYPE;
   v_last_name authors.last_name%TYPE;
   v_row_count PLS_INTEGER := 0;

   CURSOR auth_cur IS
      SELECT a.first_name, a.last_name, count(b.title)
      FROM authors a, books b
      WHERE a.id = b.author1
      OR a.id = b.author2
      OR a.id = b.author3
      GROUP BY a.first_name, a.last_name
      HAVING count(b.title) > 0
      ORDER BY a.last_name;

BEGIN

   DBMS_OUTPUT.ENABLE(1000000);

   OPEN auth_cur;
   LOOP
      FETCH auth_cur INTO v_first_name, v_last_name, v_row_count;
      EXIT WHEN auth_cur%NOTFOUND;

      DBMS_OUTPUT.PUT_LINE(v_last_name
                           ||', '
                           ||v_first_name
                           ||' wrote '
                           ||v_row_count
                           ||' book(s).');
   END LOOP;
   
   CLOSE auth_cur;

EXCEPTION
   WHEN OTHERS
      THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

