REM FILE NAME:  sys_grnt.sql
REM LOCATION:   Backup Recovery\Generate Recreation Scripts
REM FUNCTION:   SCRIPT FOR CAPTURING SYSTEM PRIVILEGES GRANTED TO USERS AND ROLES
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_sys_privs
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM
REM NOTES:       This script must be run by a user with the DBA role.
REM
REM              Running this script will create a script of all the 
REM              grants of roles to users and other roles.  This 
REM              created script, also named sys_grnt.sql, must be run by  
REM              a user with the DBA role.
REM 
REM              Since role grants are not dependant on the schema that 
REM              issued the grant, the grt_role.sql script will not 
REM              issue the grant of a role by the original grantor.  
REM              All grants will be issued by the user specified when 
REM              running this script.
REM 
REM              Grants made to 'SYS','CONNECT','RESOURCE','DBA',
REM              'EXP_FULL_DATABASE','IMP_FULL_DATABASE' are not 
REM              captured.
REM 
REM***********************************************************************************


SET verify off feedback off termout off echo off embedded on
SET pagesize 0 heading off
SET termout on
PROMPT Creating Role System Privileges script...
SET termout off
COLUMN dbname new_value db noprint
SELECT NAME dbname
  FROM v$database;
SPOOL rep_out\sys_grnt.sql
SELECT      'GRANT '
         || LOWER (PRIVILEGE)
         || ' TO '
         || LOWER (grantee)
         || DECODE (admin_option, 'YES', ' WITH ADMIN OPTION;', ';')
    FROM sys.dba_sys_privs
   WHERE grantee NOT IN ('SYS',
                         'CONNECT',
                         'RESOURCE',
                         'DBA',
                         'EXP_FULL_DATABASE',
                         'IMP_FULL_DATABASE'
                        )
ORDER BY grantee
/
SPOOL off
CLEAR columns
SET verify on feedback on termout on pagesize 22 embedded off
PROMPT Role System Privileges re-build script created.
