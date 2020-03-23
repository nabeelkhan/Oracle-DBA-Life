REM FILE NAME:  col_type.sql
REM LOCATION:   Object Management\Collection Reports
REM FUNCTION:   Document the collection types in the database
REM TESTED ON:  8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_coll_types
REM
REM This is a part of the Knowledge Xpert for Oracle Administration library. 
REM Copyright (C) 2001 Quest Software 
REM All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN owner           FORMAT a10 HEADING 'Collec.|Owner'
COLUMN type_name       FORMAT a16 HEADING 'Type|Name'
COLUMN coll_type       FORMAT a15 HEADING 'Collec.|Type'
COLUMN upper_bound                HEADING 'VARRAY|Limit'
COLUMN elem_type_owner FORMAT a10 HEADING 'Elementary|Type|Owner'
COLUMN elem_type_name  FORMAT a11 HEADING 'Elementary|Type|Name'
SET PAGES 58 LINES 78 VERIFY OFF FEEDBACK OFF
START title80 'Collection Type Report'
SPOOL rep_out\col_type
SELECT owner, type_name, coll_type, upper_bound, elem_type_owner,
       elem_type_name
  FROM dba_coll_types
 WHERE owner LIKE    '%'
                  || UPPER ('&owner')
                  || '%'
/

SPOOL OFF
