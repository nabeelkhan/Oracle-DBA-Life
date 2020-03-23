REM FILE NAME:  tsquota.sql
REM LOCATION:   Security Administration\Reports
REM FUNCTION:   Print the tablespace quotas of users.
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_ts_quotas
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


PROMPT 'Percent signs are wild cards '
ACCEPT username prompt 'Enter user name or wild card '
PROMPT Print the details of the Users Tablespace Quotas
START title80 "Database Users Space Quotas by Tablespace"
COL un          format a25              heading 'User Name'
COL ta          format a25              heading 'Tablespace' 
COL usd         format 9,999,999        heading 'K Used' 
COL maxb        format 9,999,999        heading 'Max K ' 
SET verify off feedback off newpage 0 heading on
SPOOL rep_out\tsquota
BREAK on ta skip 2
SELECT   tablespace_name ta, username un, bytes / 1024 usd,
         max_bytes / 1024 maxb
    FROM dba_ts_quotas
   WHERE username LIKE UPPER ('&username')
ORDER BY tablespace_name, username;
SPOOL off
UNDEF username
CLEAR breaks
CLEAR columns
CLEAR computes
SET verify on feedback on heading on
TTITLE off
