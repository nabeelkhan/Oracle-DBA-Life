/*
 * NclobAppend.sql
 * Chapter 16, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates the DBMS_LOB.APPEND procedure
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
PROMPT ** Create table book_samples_nls
PROMPT

CREATE TABLE book_samples_nls (
   book_sample_nls_id   NUMBER (10) PRIMARY KEY,
   isbn                 CHAR(10 CHAR),
   NLS_DESCRIPTION      NCLOB);



PROMPT
PROMPT ** Insert a record into book_samples with an EMPTY_CLOB()
PROMPT **  specified for the NLS_DESCRIPTION column.
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

PROMPT
PROMPT ** Insert a record into book_samples_nls
PROMPT

INSERT INTO book_samples_nls (
   book_sample_nls_id,
   isbn,
   nls_description)
 VALUES (
   1,
   '72230665',
   'La referencia esencial para PL/SQL ha estado revisada y ampliado, ofrecer todos los nuevos ejemplos basados en todas partes en la nueva base de datos 10g, más el código de todo el libro y asuntos ampliados del oráculo es incluido en el Web site para la transferencia directa.');

commit;

PROMPT
PROMPT ** Create procedure LOBAPPEND
PROMPT

CREATE OR REPLACE PROCEDURE LOBAPPEND (
   io_lob_source IN OUT NCLOB,
   io_lob_destination IN OUT NCLOB)
AS
BEGIN

   DBMS_LOB.OPEN(io_lob_source, DBMS_LOB.LOB_READONLY);
   DBMS_LOB.OPEN(io_lob_destination, DBMS_LOB.LOB_READWRITE);

   DBMS_LOB.APPEND(io_lob_destination, io_lob_source);

   DBMS_LOB.CLOSE(io_lob_source);
   DBMS_LOB.CLOSE(io_lob_destination);

EXCEPTION
   WHEN OTHERS
     THEN
       DBMS_OUTPUT.PUT_LINE('Append failed!');
       DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

PROMPT
PROMPT ** Append source to destination
PROMPT

SET SERVEROUTPUT ON

DECLARE
   v_source_lob_loc NCLOB;
   v_destination_lob_loc NCLOB;
   v_combined_lob NCLOB;
BEGIN
   SELECT nls_description
   INTO v_source_lob_loc
   FROM book_samples_nls
   FOR UPDATE;

   SELECT nls_description
   INTO v_destination_lob_loc
   FROM book_samples
   FOR UPDATE;

   LOBAPPEND(v_source_lob_loc, v_destination_lob_loc);

   SELECT nls_description
   INTO v_combined_lob
   from book_samples;

   DBMS_OUTPUT.PUT_LINE(SUBSTR(v_combined_lob, 1, 150));
   DBMS_OUTPUT.PUT_LINE(SUBSTR(v_combined_lob, 151, 300));
EXCEPTION
WHEN OTHERS
   THEN
     DBMS_OUTPUT.PUT_LINE('OOPS!');
     DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

