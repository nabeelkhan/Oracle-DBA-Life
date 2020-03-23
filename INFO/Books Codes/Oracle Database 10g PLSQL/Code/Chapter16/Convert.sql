/*
 * Convert.sql
 * Chapter 16, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script tests the DBMS_LOB.CONVERTTOBLOB
 *  and DBMS_LOB.CONVERTTOCLOB procedures
 */

exec CLEAN_SCHEMA.TABLES
exec CLEAN_SCHEMA.OBJECTS
exec CLEAN_SCHEMA.PROCS

PROMPT
PROMPT ** Create table book_samples
PROMPT

CREATE TABLE book_samples (
   book_sample_id   NUMBER (10) PRIMARY KEY,
   isbn             CHAR(10 CHAR),
   description      CLOB,
   nls_description  NCLOB,
   misc             BLOB,
   chapter_title    VARCHAR2(30 CHAR),
   chapter          BFILE
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
   chapter)
 VALUES (
   1,
   '72230665', 
   'The essential reference for PL/SQL has been revised and expanded, featuring all new examples throughout based on the new Oracle Database 10g, plus all the book’s code and expanded topics are included on the website for download.',
   EMPTY_CLOB(),
   EMPTY_BLOB(),
   BFILENAME('BOOK_SAMPLES_LOC', '72230665.jpg'));

PROMPT
PROMPT ** Create a dummy record
PROMPT

INSERT INTO book_samples (
   book_sample_id,
   isbn,
   description,
   nls_description,
   misc,
   chapter)
 VALUES (
   2,
   '72230665', 
   EMPTY_CLOB(),
   EMPTY_CLOB(),
   EMPTY_BLOB(),
   BFILENAME('BOOK_SAMPLES_LOC', '72230665.jpg'));

PROMPT
PROMPT ** Create procedure CONVERT_ME
PROMPT

CREATE OR REPLACE PROCEDURE CONVERT_ME (
   v_blob_or_clob IN NUMBER,
   v_blob IN OUT BLOB,
   v_clob IN OUT CLOB,
   v_amount IN OUT NUMBER,
   v_blob_offset IN OUT NUMBER,
   v_clob_offset IN OUT NUMBER,
   v_lang_context IN OUT NUMBER,
   v_warning OUT NUMBER)
AS
BEGIN

   DBMS_LOB.OPEN(v_blob, DBMS_LOB.LOB_READWRITE);
   DBMS_LOB.OPEN(v_clob, DBMS_LOB.LOB_READWRITE);

   IF v_blob_or_clob = 0
   THEN
   DBMS_LOB.CONVERTTOBLOB(v_blob, 
                          v_clob, 
                          v_amount,
                          v_blob_offset, 
                          v_clob_offset, 
                          1, 
                          v_lang_context, 
                          v_warning);
   ELSE
   DBMS_LOB.CONVERTTOCLOB(v_clob,
                          v_blob,
                          v_amount,
                          v_clob_offset, 
                          v_blob_offset, 
                          1, 
                          v_lang_context, 
                          v_warning);
   END IF;

   DBMS_LOB.CLOSE(v_blob);
   DBMS_LOB.CLOSE(v_clob);

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE('The conver_me procedure is broken ...');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

PROMPT
PROMPT ** Converting a CLOB to a BLOB and writing it to the table
PROMPT

DECLARE
   v_clob_or_blob NUMBER;
   v_blob_locator BLOB;
   v_clob_locator CLOB;
   v_blob_offset NUMBER;
   v_clob_offset NUMBER;
   v_lang_context NUMBER := DBMS_LOB.DEFAULT_LANG_CTX;
   v_warning NUMBER;
   v_string_length NUMBER(10);
   v_source_locator BLOB;
   v_destination_locator BLOB;
   v_amount PLS_INTEGER;
   v_string CLOB;
BEGIN

   -- CONVERT CLOB TO BLOB
  
   SELECT description
   INTO v_clob_locator
   FROM book_samples
   WHERE book_sample_id = 1
   FOR UPDATE;

   SELECT misc
   INTO v_blob_locator
   FROM book_samples
   WHERE book_sample_id = 1
   FOR UPDATE;

   v_string_length := DBMS_LOB.GETLENGTH(v_blob_locator);
   v_amount := DBMS_LOB.GETLENGTH(v_clob_locator);

   DBMS_OUTPUT.PUT_LINE('The initial length of the BLOB is: '||v_string_length);

        v_clob_or_blob := 0; -- Convert clob to blob
        v_clob_offset := 1;
        v_blob_offset := 1;

        CONVERT_ME(v_clob_or_blob,
                v_blob_locator, 
                v_clob_locator, 
                v_amount,
                v_blob_offset, 
                v_clob_offset, 
                v_lang_context, 
                v_warning);

   v_string_length := DBMS_LOB.GETLENGTH(v_blob_locator);

   DBMS_OUTPUT.PUT_LINE('The length of the BLOB post-conversion is: '||v_string_length);

   -- COPY BLOB FOR ONE ROW TO BLOB IN ANOTHER
   v_source_locator := v_blob_locator;

   SELECT misc
   INTO v_destination_locator
   FROM book_samples
   WHERE book_sample_id = 2
   FOR UPDATE;

   DBMS_LOB.COPY(v_destination_locator, v_source_locator, 32768, 1, 1);

   v_string_length := DBMS_LOB.GETLENGTH(v_destination_locator);

   DBMS_OUTPUT.PUT_LINE('The length of the BLOB post-copy is: '||v_string_length);

   -- COPY BLOB FOR RECORD 2 BACK TO A CLOB
   
   SELECT description
   INTO v_clob_locator
   FROM book_samples
   WHERE book_sample_id = 2
   FOR UPDATE;

   SELECT misc
   INTO v_blob_locator
   FROM book_samples
   WHERE book_sample_id = 2
   FOR UPDATE;

   v_string_length := DBMS_LOB.GETLENGTH(v_clob_locator);
   v_amount := DBMS_LOB.GETLENGTH(v_blob_locator);

   DBMS_OUTPUT.PUT_LINE('The initial length of the CLOB (record 2) is: '||v_string_length);

        v_clob_or_blob := 1; -- Convert blob to clob
        v_clob_offset := 1;
        v_blob_offset := 1;

        CONVERT_ME(v_clob_or_blob,
                v_blob_locator, 
                v_clob_locator, 
                v_amount,
                v_clob_offset, 
                v_blob_offset, 
                v_lang_context, 
                v_warning);

   v_string_length := DBMS_LOB.GETLENGTH(v_clob_locator);

   SELECT description
   INTO v_string
   FROM book_samples
   WHERE book_sample_id = 2;

   DBMS_OUTPUT.PUT_LINE('The length of the CLOB post-conversion is: '||v_string_length);

   DBMS_OUTPUT.PUT_LINE('	');
   DBMS_OUTPUT.PUT_LINE('The converted CLOB');
   DBMS_OUTPUT.PUT_LINE('==================');
   DBMS_OUTPUT.PUT_LINE(SUBSTR(v_string,1,150));
   DBMS_OUTPUT.PUT_LINE(SUBSTR(v_string,151,300));
   

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE('I''M BROKEN ... FIX ME!');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);

END;
/
