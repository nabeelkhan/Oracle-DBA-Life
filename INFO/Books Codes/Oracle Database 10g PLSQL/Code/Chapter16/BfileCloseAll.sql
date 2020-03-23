/*
 * BfileCloseAll.sql
 * Chapter 16, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script tests the DBMS_LOB.FILECLOSEALL procedure
 */

exec CLEAN_SCHEMA.TABLES
exec CLEAN_SCHEMA.OBJECTS
exec CLEAN_SCHEMA.PROCS

PROMPT
PROMPT ** Create table book_samples
PROMPT

CREATE TABLE book_samples (
   book_sample_id     NUMBER (10) PRIMARY KEY,
   isbn               CHAR(10 CHAR),
   description        CLOB,
   nls_description    NCLOB,
   misc               BLOB,
   chapter_title      VARCHAR2(30 CHAR),
   bfile_description  BFILE
)  
   LOB (misc) 
      STORE AS blob_seg ( TABLESPACE blob_ts
                 CHUNK 8192
                 PCTVERSION 0
                 NOCACHE
                 NOLOGGING
                 DISABLE STORAGE IN ROW)
   LOB (description, nls_description) 
   STORE AS ( TABLESPACE clob_ts
                 CHUNK 8192
                 PCTVERSION 10
                 NOCACHE
                 LOGGING
                 ENABLE STORAGE IN ROW);

PROMPT
PROMPT ** Insert two records into book_samples table
PROMPT

INSERT INTO book_samples (
   book_sample_id,
   isbn,
   description,
   nls_description,
   misc,
   bfile_description)
 VALUES (
   1,
   '72230665', 
   EMPTY_CLOB(),
   EMPTY_CLOB(),
   EMPTY_BLOB(),
   BFILENAME('BOOK_SAMPLES_LOC', 'bfile_example.pdf'));

INSERT INTO book_samples (
   book_sample_id,
   isbn,
   description,
   nls_description,
   misc,
   bfile_description)
 VALUES (
   2,
   '72230665', 
   EMPTY_CLOB(),
   EMPTY_CLOB(),
   EMPTY_BLOB(),
   BFILENAME('BOOK_SAMPLES_LOC', 'bfile_example2.pdf'));

COMMIT;

PROMPT
PROMPT ** Create procedure CLOSE_FILE
PROMPT

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE CLOSE_ALL_FILES
AS
   v_isopen PLS_INTEGER := 0;
   v_counter PLS_INTEGER := 0;
   v_bfile BFILE;

   CURSOR cur_bfile IS
   SELECT bfile_description
   FROM book_samples;
BEGIN

   DBMS_OUTPUT.PUT_LINE('Open all BFILEs in the table');
   DBMS_OUTPUT.PUT_LINE('============================');

   OPEN cur_bfile;

   LOOP
   FETCH cur_bfile INTO v_bfile;
   EXIT WHEN cur_bfile%NOTFOUND;
      BEGIN
         v_counter := v_counter + 1;

         DBMS_LOB.OPEN(v_bfile);
         v_isopen := DBMS_LOB.ISOPEN(v_bfile);

         IF v_isopen = 0
         THEN
            DBMS_OUTPUT.PUT_LINE ('File number '||v_counter||' is closed');
         ELSE
            DBMS_OUTPUT.PUT_LINE ('File number '||v_counter||' is open');
   END IF;

      END;
   END LOOP;

   CLOSE cur_bfile;

   DBMS_OUTPUT.PUT_LINE('	');
   DBMS_OUTPUT.PUT_LINE('Close all open BFILEs');
   DBMS_OUTPUT.PUT_LINE('=====================');
   DBMS_LOB.FILECLOSEALL();
   DBMS_OUTPUT.PUT_LINE('         DONE        ');
   DBMS_OUTPUT.PUT_LINE('	');

   DBMS_OUTPUT.PUT_LINE('Test to verify all BFILEs were closed');
   DBMS_OUTPUT.PUT_LINE('======================================');

   OPEN cur_bfile;
   v_counter := 0;

   LOOP
   FETCH cur_bfile INTO v_bfile;
   EXIT WHEN cur_bfile%NOTFOUND;
      BEGIN
         v_counter := v_counter + 1;

         v_isopen := DBMS_LOB.ISOPEN(v_bfile);

         IF v_isopen = 0
         THEN
            DBMS_OUTPUT.PUT_LINE ('File number '||v_counter||' is closed');
         ELSE
            DBMS_OUTPUT.PUT_LINE ('File number '||v_counter||' is open');
   END IF;

      END;
   END LOOP;

   CLOSE cur_bfile;

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM);
END;
/

PROMPT
PROMPT ** Check to see whether the files are closed
PROMPT


EXEC close_all_files()
