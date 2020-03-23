/*
 * TextIndex.sql
 * Chapter 4, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates indexing using Oracle Text
 */

exec clean_schema.trigs
exec clean_schema.procs
exec clean_schema.tables
exec clean_schema.ind

CREATE TABLE book_descriptions (
   book_description_id   NUMBER (10) PRIMARY KEY,
   isbn             VARCHAR2(10),
   description      VARCHAR2(500));

INSERT INTO book_descriptions (
   book_description_id,
   isbn,
   description)
 VALUES (
   1,
   '72230665', 
   'The essential reference for PL/SQL has been revised and expanded, featuring all new examples throughout based on the new Oracle Database 10g, plus all the book''s code and expanded topics are included on the website for download.');

commit;

PROMPT
PROMPT ** Create the CONTEXT index on the description column
PROMPT

-- If you wish to use theme indexing in 10gR1, note that the knowledge
--  base is not included on the single install cd.  You must install
--  the companion cd as well.  Refer to Note 262701.1 on http://metalink.oracle.com

BEGIN
   ctx_ddl.create_preference ('desc_lexer', 'basic_lexer');
   ctx_ddl.set_attribute ('desc_lexer', 'index_text', 'true');
   ctx_ddl.set_attribute ('desc_lexer', 'index_themes', 'false');
END;
/

BEGIN
   ctx_ddl.create_preference ('desc_wordlist', 'basic_wordlist');
   ctx_ddl.set_attribute ('desc_wordlist', 'substring_index', 'true');
END;
/


-- Create an index with the default stoplist
CREATE INDEX desc_indx ON book_descriptions(description)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ( 'lexer desc_lexer 
              wordlist desc_wordlist 
              stoplist ctxsys.default_stoplist' );

PROMPT
PROMPT ** Test the index with a simple query
PROMPT
SELECT score(1), isbn
FROM book_descriptions
WHERE CONTAINS(description, 'website', 1) > 0;

SET SERVEROUTPUT ON

PROMPT
PROMPT
PROMPT ** Test case-insensitivity with a simple mixed-case query
PROMPT

DECLARE
   v_isbn BOOK_DESCRIPTIONS.ISBN%TYPE;
   v_score NUMBER(10);
BEGIN
   
   SELECT score(1), isbn
   INTO v_score, v_isbn
   FROM book_descriptions
   WHERE CONTAINS (description, '10G or oracle', 1) > 0;

   DBMS_OUTPUT.PUT_LINE('Score: '||v_score||' and ISBN: '||v_isbn);

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE(sqlerrm);
END;
/



PROMPT
PROMPT 
PROMPT ** Test proximity searches
PROMPT

DECLARE
   v_isbn BOOK_DESCRIPTIONS.ISBN%TYPE;
   v_score NUMBER(10);
BEGIN
   
   SELECT score(1), isbn
   INTO v_score, v_isbn
   FROM book_descriptions
   WHERE CONTAINS (description, '10g near Oracle', 1) > 0;

   DBMS_OUTPUT.PUT_LINE('Score: '||v_score||' and ISBN: '||v_isbn);

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE(sqlerrm);
END;
/






SELECT isbn
FROM book_descriptions
WHERE CONTAINS(description, '10g near oracle') > 0;

SELECT isbn
FROM book_descriptions
WHERE CONTAINS(description, 'website') > 3;
