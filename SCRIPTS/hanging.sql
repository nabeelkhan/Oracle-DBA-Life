REM FILE NAME:  hanging.sql
REM LOCATION:   Object Management\Functions,Procedures, and Packages\Reports
REM FUNCTION:   Report objects that need to be recompiled because they 
REM             may be hanging
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   obj$, dependency$
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM
REM NOTES: run from SYS only
REM
REM***********************************************************************************


@title80 "Objects that need Recompilation"
COLUMN obj#     heading Object|Number
COLUMN name     heading Object|Name
COLUMN owner#   heading Owner|Number
SPOOL rep_out\hanging
SELECT DISTINCT o2.obj#, o2.NAME, o2.owner#
           FROM sys.obj$ o, sys.dependency$ d, sys.obj$ o2
          WHERE o.obj# = d.p_obj#
            AND o.stime != d.p_timestamp
            AND d.d_obj# = o2.obj#
            AND o2.status != 5
       ORDER BY o2.obj#
/
SPOOL off
CLEAR columns
TTITLE off
