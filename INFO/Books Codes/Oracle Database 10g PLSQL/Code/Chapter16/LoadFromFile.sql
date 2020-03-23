/*
 * LoadFromFile.sql
 * Chapter 16, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script tests the DBMS_LOB.LOADFROMFILE procedure
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

set serveroutput on

DECLARE
   v_dest_blob BLOB;
   v_dest_clob CLOB;
   v_source_locator1 BFILE := BFILENAME('BOOK_SAMPLES_LOC', 'bfile_example.pdf');
   v_source_locator2 BFILE := BFILENAME('BOOK_SAMPLES_LOC', 'bfile_example.txt');

BEGIN

   -- Empty the description and misc columns
   UPDATE book_samples
   SET description = EMPTY_CLOB(),
       misc = EMPTY_BLOB()
   WHERE book_sample_id = 1;
   
   -- Retrieve the locators for the two destination columns
   SELECT description, misc
   INTO v_dest_clob, v_dest_blob
   FROM book_samples
   WHERE book_sample_id = 1
   FOR UPDATE;

   -- Open the BFILEs and destination LOBs
   DBMS_LOB.OPEN(v_source_locator1, DBMS_LOB.LOB_READONLY);
   DBMS_LOB.OPEN(v_source_locator2, DBMS_LOB.LOB_READONLY);
   DBMS_LOB.OPEN(v_dest_blob, DBMS_LOB.LOB_READWRITE);
   DBMS_LOB.OPEN(v_dest_clob, DBMS_LOB.LOB_READWRITE);

   DBMS_OUTPUT.PUT_LINE('Length of the BLOB file is: '||DBMS_LOB.GETLENGTH(v_source_locator1));
   DBMS_OUTPUT.PUT_LINE('Length of the CLOB file is: '||DBMS_LOB.GETLENGTH(v_source_locator2));
   DBMS_OUTPUT.PUT_LINE('Size of BLOB pre-load: '||DBMS_LOB.GETLENGTH(v_dest_blob));
   DBMS_OUTPUT.PUT_LINE('Size of CLOB pre-load: '||DBMS_LOB.GETLENGTH(v_dest_clob));

   -- Load the destination columns from the source
   DBMS_LOB.LOADFROMFILE(v_dest_blob, v_source_locator1, DBMS_LOB.LOBMAXSIZE, 1, 1);
   DBMS_LOB.LOADFROMFILE(v_dest_clob, v_source_locator2, DBMS_LOB.LOBMAXSIZE, 1, 1);

   DBMS_OUTPUT.PUT_LINE('Size of BLOB post-load: '||DBMS_LOB.GETLENGTH(v_dest_blob));
   DBMS_OUTPUT.PUT_LINE('Size of CLOB post-load: '||DBMS_LOB.GETLENGTH(v_dest_clob));

   -- Close the LOBs that we opened
   DBMS_LOB.CLOSE(v_source_locator1);
   DBMS_LOB.CLOSE(v_source_locator2);
   DBMS_LOB.CLOSE(v_dest_blob);
   DBMS_LOB.CLOSE(v_dest_clob);

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);

      DBMS_LOB.CLOSE(v_source_locator1);
      DBMS_LOB.CLOSE(v_source_locator2);
      DBMS_LOB.CLOSE(v_dest_blob);
      DBMS_LOB.CLOSE(v_dest_clob);

END;
/

PROMPT
PROMPT ** SELECT of the description column
PROMPT

SET LONG 64000
SELECT description
FROM book_samples
WHERE book_sample_id = 1;
