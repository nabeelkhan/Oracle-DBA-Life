/*
 * TextIndex.sql
 * Chapter 16, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates indexing using Oracle Text
 */

exec CLEAN_SCHEMA.TABLES
exec CLEAN_SCHEMA.OBJECTS
exec CLEAN_SCHEMA.PROCS
exec CLEAN_SCHEMA.IND

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
PROMPT ** Create the CONTEXT index on the description column
PROMPT

-- If you wish to use theme indexing in 10gR1, note that the knowledge
--  base is not included on the single install cd.  You must install
--  the companion cd as well.  Refer to Note 262701.1 on http://metalink.oracle.com

BEGIN
   ctx_ddl.create_preference ('lob_lexer', 'basic_lexer');
   ctx_ddl.set_attribute ('lob_lexer', 'index_text', 'true');
   ctx_ddl.set_attribute ('lob_lexer', 'index_themes', 'false');
END;
/

BEGIN
   ctx_ddl.create_preference ('lob_wordlist', 'basic_wordlist');
   ctx_ddl.set_attribute ('lob_wordlist', 'substring_index', 'true');
END;
/

-- Create an index with an empty stoplist
CREATE INDEX lob_indx ON book_samples(description)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ( 'lexer lob_lexer 
              wordlist lob_wordlist 
              stoplist ctxsys.empty_stoplist' );

set pages 9999
SELECT token_text
FROM DR$LOB_INDX$I;

DROP INDEX lob_indx force;

-- Create an index with the default stoplist
CREATE INDEX lob_indx ON book_samples(description)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ( 'lexer lob_lexer 
              wordlist lob_wordlist 
              stoplist ctxsys.default_stoplist' );

set pages 9999
SELECT token_text
FROM DR$LOB_INDX$I;

SELECT SCORE(1), book_sample_id
FROM book_samples
WHERE CONTAINS(description, 'website', 1) > 0;
