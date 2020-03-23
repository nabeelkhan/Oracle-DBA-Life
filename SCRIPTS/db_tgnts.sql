REM FILE NAME:  db_tgnts.sql
REM LOCATION:   Security Administration\Reports
REM FUNCTION:   Produce report of table grants showing GRANTOR, GRANTEE 
REM             and specific GRANTS
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_tab_privs
REM
REM INPUTS: 	Owner name
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN GRANTEE          FORMAT A18      heading "Grantee" 
COLUMN OWNER            FORMAT A18      heading "Owner" 
COLUMN TABLE_NAME       FORMAT A30      heading "Table" 
COLUMN GRANTOR          FORMAT A18      heading "Grantor" 
COLUMN PRIVILEGE        FORMAT A10      heading "Privilege" 
COLUMN GRANTABLE        FORMAT A19      heading "With Grant Option?" 

BREAK ON OWNER SKIP 4 ON TABLE_NAME SKIP 1 on grantee on grantor ON REPORT 

SET LINESIZE 130 PAGES 56 VERIFY OFF FEEDBACK OFF echo off
START title132 "TABLE GRANTS BY OWNER AND TABLE" 
SPOOL rep_out\db_tgnts  
SELECT   owner, table_name, grantee, grantor, PRIVILEGE, grantable
    FROM dba_tab_privs
   WHERE owner NOT IN ('SYS', 'SYSTEM')
ORDER BY owner, table_name, grantor, grantee;

SPOOL OFF
