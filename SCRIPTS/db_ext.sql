REM FILE NAME:  db_ext.sql
REM LOCATION:   Object Management\Tablespaces and DataFiles\Reports
REM FUNCTION:   generate extents report
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_extents
REM             Extents threshold - ie, if you enter 5, only segments with
REM             5 or more extents will be displayed.
REM             Owner - schema that you wish to search
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


CLEAR COLUMNS
COLUMN segment_name     HEADING 'Segment'       FORMAT A15
COLUMN tablespace_name  HEADING 'Tablespace'    FORMAT A10
COLUMN owner            HEADING 'Owner'         FORMAT A10
COLUMN segment_type     HEADING 'Type'          FORMAT A10
COLUMN size             HEADING 'Size'          FORMAT 999,999,999
COLUMN extents          HEADING 'Current|Extents'
COLUMN max_extents      HEADING 'Max|Extents'
COLUMN bytes            HEADING 'Size|(Bytes)'
SET PAGESIZE 58 NEWPAGE 0 LINESIZE 130 FEEDBACK OFF 
SET ECHO OFF VERIFY OFF
ACCEPT extents PROMPT 'Enter extents threshold: '
BREAK ON tablespace_name SKIP PAGE ON owner
START TITLE132 "Extents Report"
SPOOL rep_out\db_ext
SELECT   tablespace_name, segment_name, extents, max_extents, bytes,
         owner "owner", segment_type
    FROM dba_segments
   WHERE extents >= &extents AND owner LIKE UPPER ('%&owner%')
ORDER BY tablespace_name, owner, segment_type, segment_name;
SPOOL OFF
CLEAR COLUMNS
CLEAR BREAKS
SET TERMOUT ON FEEDBACK ON VERIFY ON 
UNDEF extents
UNDEF owner
TTITLE OFF
UNDEF OUTPUT
