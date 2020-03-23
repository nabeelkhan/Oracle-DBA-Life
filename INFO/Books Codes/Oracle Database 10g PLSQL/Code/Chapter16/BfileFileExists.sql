/*
 * BfileFileExists.sql
 * Chapter 16, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script tests the DBMS_LOB.FILEEXISTS procedure
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
PROMPT ** Insert a record into book_samples table
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

COMMIT;

PROMPT
PROMPT ** Create procedure CHECK_FILE
PROMPT

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE CHECK_FILE (
   v_bfile IN BFILE)
AS
   v_exists PLS_INTEGER := 0;
BEGIN

   v_exists := DBMS_LOB.FILEEXISTS(v_bfile);

   IF v_exists = 0
   THEN
      DBMS_OUTPUT.PUT_LINE ('The file does not exists in the directory specified');
      DBMS_OUTPUT.PUT_LINE ('  Check to be sure the directory exists, and the file');
      DBMS_OUTPUT.PUT_LINE ('  name is valid.');
   ELSE
      DBMS_OUTPUT.PUT_LINE ('The file exists and the directory valid!');
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

PROMPT
PROMPT ** Test to see if the bfile exists
PROMPT

DECLARE
   v_bfile BFILE;
BEGIN
   SELECT bfile_description
   INTO v_bfile
   FROM book_samples
   WHERE book_sample_id = 1;

   CHECK_FILE(v_bfile);
END;
/

PROMPT
PROMPT ** Insert a second record into book_samples table
PROMPT

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
   BFILENAME('book_samples_loc', 'bfile_example2.pdf'));

COMMIT;

PROMPT
PROMPT ** Test to see if the second bfile exists
PROMPT

DECLARE
   v_bfile BFILE;
BEGIN
   SELECT bfile_description
   INTO v_bfile
   FROM book_samples
   WHERE book_sample_id = 2;

   CHECK_FILE(v_bfile);
END;
/

