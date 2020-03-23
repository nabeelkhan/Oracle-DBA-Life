REM FILE NAME:  synonym.sql
REM LOCATION:   Object Management\Synonym Reports
REM FUNCTION:   GENERATE REPORT OF A USERS SYNONYMS
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_synonyms,dba_db_links
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


PROMPT Percent signs are Wild Cards
PROMPT
ACCEPT own prompt 'Enter the user who owns synonym: '
SET pages 56 lines 130 verify off feedback off term off
START title132 "Synonym Report"
SPOOL rep_out/synonym
COLUMN host     format a24 heading "Connect String"
COLUMN owner    format a15
COLUMN table    format a35
COLUMN db_link  format a6 heading Link 
COLUMN username format a15 
SELECT a.owner, synonym_name,    table_owner
                              || '.'
                              || table_name "Table",
       b.db_link, username, host
  FROM dba_synonyms a, dba_db_links b
 WHERE a.db_link = b.db_link(+) AND a.owner LIKE UPPER ('&own');
SPOOL off
TTITLE OFF
