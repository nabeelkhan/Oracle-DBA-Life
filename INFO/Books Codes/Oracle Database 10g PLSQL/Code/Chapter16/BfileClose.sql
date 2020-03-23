/*
 * BfileClose.sql
 * Chapter 16, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script tests the DBMS_LOB.CLOSE procedure
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

CREATE OR REPLACE PROCEDURE CLOSE_FILE (
   v_bfile IN OUT BFILE)
AS
   v_isopen PLS_INTEGER := 0;
BEGIN

   DBMS_OUTPUT.PUT_LINE('Test to see if the file is open');
   DBMS_OUTPUT.PUT_LINE('===============================');
   DBMS_LOB.OPEN(v_bfile);
   v_isopen := DBMS_LOB.ISOPEN(v_bfile);

   IF v_isopen = 0
   THEN
      DBMS_OUTPUT.PUT_LINE ('The file is closed.');
   ELSE
      DBMS_OUTPUT.PUT_LINE ('The file is open.');
   END IF;

   DBMS_OUTPUT.PUT_LINE ('	');
   DBMS_OUTPUT.PUT_LINE ('Test to see if the file is closed');
   DBMS_OUTPUT.PUT_LINE('==================================');

   DBMS_LOB.CLOSE(v_bfile);

   v_isopen := DBMS_LOB.ISOPEN(v_bfile);

   IF v_isopen = 0
   THEN
      DBMS_OUTPUT.PUT_LINE ('The file is closed.');
   ELSE
      DBMS_OUTPUT.PUT_LINE ('The file is open.');
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM);
END;
/

PROMPT
PROMPT ** Check to see whether the file is open
PROMPT


DECLARE
   v_bfile BFILE;
BEGIN
   SELECT bfile_description
   INTO v_bfile
   FROM book_samples
   WHERE book_sample_id = 1;

   CLOSE_FILE(v_bfile);
END;
/
