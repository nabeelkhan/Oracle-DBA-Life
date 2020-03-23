REM FILE NAME:  grants7.sql
REM LOCATION:   Security Administration\Reports
REM FUNCTION:   Produce report of table grants showing GRANTOR, GRANTEE 
REM             and specific GRANTS
REM TESTED ON:  7.3.3.5
REM PLATFORM:   non-specific
REM REQUIRES:   DBA_TAB_PRIVS 
REM 
REM INPUTS:		Owner name
REM
REM OUTPUTS:	Report of table grants
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM 
REM  LIMITATIONS: User must have access to DBA_TAB_PRIVS
REM
REM  NOTES:       Will not report grants to SYS or SYSTEM
REM
REM***********************************************************************************


COLUMN GRANTEE          FORMAT A18      HEADING "Grantee" 
COLUMN OWNER            FORMAT A18      HEADING "Owner" 
COLUMN TABLE_NAME       FORMAT A30      HEADING "Table" 
COLUMN GRANTOR          FORMAT A18      HEADING "Grantor" 
COLUMN PRIVILEGE        FORMAT A10      HEADING "Privilege" 
COLUMN GRANTABLE        FORMAT A19      HEADING "With Grant Option?" 
REM
BREAK ON owner SKIP 4 ON table_name SKIP 1 ON grantee ON grantor ON REPORT 
REM 
SET LINESIZE 130 PAGES 56 VERIFY OFF FEEDBACK OFF 
START title132 "TABLE GRANTS BY OWNER AND TABLE" 
SPOOL rep_out\grants7
REM 
SELECT   owner, table_name, grantee, grantor, PRIVILEGE, grantable
    FROM dba_tab_privs
   WHERE owner NOT IN ('SYS', 'SYSTEM')
ORDER BY owner, table_name, grantor, grantee;
REM 
SPOOL OFF 
SET LINESIZE 80 PAGES 22 VERIFY ON FEEDBACK ON 
CLEAR breaks
CLEAR columns
TTITLE off
