/*
 * CreateLOBTables.sql
 * Chapter 16, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates storage options available for LOBs
 */

EXEC CLEAN_SCHEMA.tables

PROMPT 
PROMPT Creating Tables
PROMPT

-- In the book_samples table, the first LOB clause includes 
--  a named lob segment.  The second LOB clause does not - in 
--  fact it would error if we did try to name it as the column
--  list includes more than one column.  In this case, the 
--  lob segment is named by the system.

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
   'La referencia esencial para PL/SQL ha estado revisada y ampliado, ofrecer todos los nuevos ejemplos basados en todas partes en la nueva base de datos 10g, más el código de todo el libro y asuntos ampliados del oráculo es incluido en el Web site para la transferencia directa.',
   empty_blob(),
   bfilename('image_dir', '72230665.jpg'));

commit;
