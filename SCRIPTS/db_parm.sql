REM FILE NAME:  db_parm.sql
REM LOCATION:   Backup Recovery\Reports
REM FUNCTION:   Generate list of DB parameters
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$parameter
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


SET NEWPAGE 0 VERIFY OFF
SET PAGES 10000 lines 131
COLUMN name  format a37
COLUMN value format a30 
COLUMN description format a40 word_wrapped
START title132 "INIT.ORA PARAMETER LISTING"
SPOOL rep_out\db_parm
SELECT   NAME, VALUE, description
    FROM v$parameter
ORDER BY NAME;
SPOOL OFF
CLEAR COLUMNS
SET VERIFY ON termout on PAGES 22 lines 80
UNDEF output
