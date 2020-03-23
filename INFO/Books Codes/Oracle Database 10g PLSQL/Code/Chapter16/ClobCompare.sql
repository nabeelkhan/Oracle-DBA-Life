/*
 * ClobCompare.sql
 * Chapter 16, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script tests the DBMS_LOB.COMPARE function
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
   book_cover       BLOB,
   chapter_title    VARCHAR2(30 CHAR),
   chapter          BFILE
)  
   LOB (book_cover) 
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
PROMPT ** Insert two records into book_samples
PROMPT

INSERT INTO book_samples (
   book_sample_id,
   isbn,
   description,
   nls_description,
   book_cover,
   chapter)
 VALUES (
   1,
   '72230665', 
   'The essential reference for PL/SQL has been revised and expanded, featuring all new examples throughout based on the new Oracle Database 10g, plus all the book’s code and expanded topics are included on the website for download.',
   EMPTY_CLOB(),
   EMPTY_BLOB(),
   BFILENAME('BOOK_SAMPLES_LOC', '72230665.jpg'));

INSERT INTO book_samples (
   book_sample_id,
   isbn,
   description,
   nls_description,
   book_cover,
   chapter)
 VALUES (
   2,
   '72230665', 
   'The essential reference for PL/SQL has been revised and expanded, featuring all new examples throughout based on the new Oracle Database 10g, plus all the book’s code and expanded topics are included for download.',
   EMPTY_CLOB(),
   EMPTY_BLOB(),
   BFILENAME('BOOK_SAMPLES_LOC', '72230665.jpg'));

INSERT INTO book_samples (
   book_sample_id,
   isbn,
   description,
   nls_description,
   book_cover,
   chapter)
 VALUES (
   3,
   '72230665', 
   'The essential reference for PL/SQL has been revised and expanded, featuring all new examples throughout based on the new Oracle Database 10g, plus all the book’s code and expanded topics are included on the website for download.',
   EMPTY_CLOB(),
   EMPTY_BLOB(),
   BFILENAME('book_samples_loc', '72230665.jpg'));

PROMPT
PROMPT ** Create procedure CLOB_COMPARE
PROMPT

CREATE OR REPLACE PROCEDURE CLOB_COMPARE (
   v_lob1 IN OUT CLOB,
   v_lob2 IN OUT CLOB)
AS
   v_compare PLS_INTEGER := 0;
BEGIN

   DBMS_LOB.OPEN(v_lob1, DBMS_LOB.LOB_READONLY);
   DBMS_LOB.OPEN(v_lob2, DBMS_LOB.LOB_READONLY);

   v_compare := DBMS_LOB.COMPARE(v_lob1,v_lob2, 32768, 1, 1);

   DBMS_OUTPUT.PUT_LINE('The value returned by COMPARE is: '||v_compare);

   IF v_compare = 0
   THEN
      DBMS_OUTPUT.PUT_LINE('	');
      DBMS_OUTPUT.PUT_LINE('The LOBs are the same');
      DBMS_OUTPUT.PUT_LINE('	');
   ELSE
      DBMS_OUTPUT.PUT_LINE('	');
      DBMS_OUTPUT.PUT_LINE('The LOBs are different');
      DBMS_OUTPUT.PUT_LINE('	');
   END IF;  

   DBMS_LOB.CLOSE(v_lob1);
   DBMS_LOB.CLOSE(v_lob2);
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

PROMPT
PROMPT ** Compare some CLOB columns
PROMPT

SET SERVEROUTPUT ON

DECLARE
   v_lob1 CLOB;
   v_lob2 CLOB;
   v_lob3 CLOB;
BEGIN
   SELECT description
   INTO v_lob1
   FROM book_samples
   WHERE book_sample_id = 1;

   SELECT description
   INTO v_lob2
   FROM book_samples
   WHERE book_sample_id = 2;

   SELECT description
   INTO v_lob3
   FROM book_samples
   WHERE book_sample_id = 3;

   DBMS_OUTPUT.PUT_LINE('Test comparison of different values');
   DBMS_OUTPUT.PUT_LINE('===================================');
   CLOB_COMPARE(v_lob1, v_lob2);

   DBMS_OUTPUT.PUT_LINE('Test comparison of identical values');
   DBMS_OUTPUT.PUT_LINE('===================================');
   CLOB_COMPARE(v_lob1, v_lob3);

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE('I''m Broken!');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/