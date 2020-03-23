REM FILE NAME:  defrag.sql
REM LOCATION:   Object Management\Tablespaces and DataFiles\Utilities
REM FUNCTION:   Coalesce tablespaces, 7.3 or above
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   free_space, alter tablespace privilege
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM
REM******************** Knowledge Xpert for Oracle Administration ********************
REM
REM Uses the "alter tablespace" command to manually coalesce
REM any tablespace with greater than 1 fragment. You
REM may wish to alter to exclude the temporary tablespace.
REM The procedure uses the FREE_SPACE view which is a 
REM summarized version of the DBA_FREE_SPACE view.
REM This procedure must be run from SYS user id.
REM
REM***********************************************************************************
REM

@free_sp2
CLEAR columns
CLEAR computes
TTITLE off
SET heading off feedback off echo off termout off
SPOOL def.sql
SELECT    'alter tablespace '
       || tablespace_name
       || ' coalesce;'
  FROM dba_tablespaces d, free_space f
 WHERE f.TABLESPACE = d.tablespace_name AND f.pieces > 1;
SPOOL off
SET termout on
@def.sql
SET termout off
HOST del def.sql
SET heading on feedback on termout on
@free_sp2
