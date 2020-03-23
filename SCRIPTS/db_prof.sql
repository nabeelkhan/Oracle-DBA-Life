REM FILE NAME:  db_prof.sql
REM LOCATION:   Security Administration\Reports
REM FUNCTION:   Generate user profiles report
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   sys.dba_profiles
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


SET flush off term off pagesize 58 linesize 78
COLUMN profile          format A20      heading Profile
COLUMN resource_name                    heading 'Resource:'
COLUMN limit            format A15      heading Limit
BREAK on profile
START title80 'ORACLE PROFILES REPORT'
DEFINE output = rep_out\db_prof
SPOOL &output
SELECT   PROFILE, resource_name, LIMIT
    FROM sys.dba_profiles
ORDER BY PROFILE;
SPOOL off
SET flush on term on pagesize 22 linesize 80
CLEAR columns
CLEAR breaks
