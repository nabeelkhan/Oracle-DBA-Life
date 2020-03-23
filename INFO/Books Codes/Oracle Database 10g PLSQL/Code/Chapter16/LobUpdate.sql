/*
 * LobUpdate.sql
 * Chapter 16, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates LOB updates
 */

exec CLEAN_SCHEMA.TABLES
exec CLEAN_SCHEMA.OBJECTS
exec CLEAN_SCHEMA.PROCS

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
   EMPTY_CLOB(),
   EMPTY_BLOB(),
   BFILENAME('BOOK_SAMPLES_LOC', '72230665.jpg'));

commit;

PROMPT
PROMPT ** Length of the description column that had a value inserted
PROMPT

SELECT LENGTH(description)
  FROM book_samples;

PROMPT
PROMPT ** Update the description column to be EMPTY
PROMPT

UPDATE book_samples
  SET description = EMPTY_CLOB()
  WHERE description IS NOT NULL;

COMMIT;

PROMPT
PROMPT ** Length of the description column after updating to empty
PROMPT

SELECT LENGTH(description)
  FROM book_samples;

