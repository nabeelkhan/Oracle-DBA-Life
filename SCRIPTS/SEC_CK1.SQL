rem ***************************************************************************
rem Script:    sec_ck.sql
rem Purpose:   Checks security statusof an Oracle 8 database instance
rem Author:    Nabeel Khan
rem Revised:   9/11/99
rem ***************************************************************************
rem Set up environment
set termout off
set pause off
set pages 5400
set feedback off
set time off
rem ***************************************************************************
rem send output to a file
spool C:\nabeel\lst\sec_ck1
rem ***************************************************************************
rem Print overall heading for report
set heading off
prompt ########################################################################
prompt #               Oracle Database Security Report                        #
prompt ########################################################################
prompt
prompt Instance Name:
select value from v$parameter where name='db_name'
/
prompt
prompt
prompt Date Of This Report:
Column today format a30
select to_char(sysdate,'dd Month YYYY  HH24:MI') today from sys.dual;
prompt
prompt
rem ***************************************************************************
rem Profiles section
set heading on
column profile format a15
column resource_name format a30
column limit format a20
prompt ########################################################################
prompt
prompt Profiles
prompt
select profile,resource_name,limit
	from sys.dba_profiles
	order by profile,resource_name
/
prompt
prompt
rem ***************************************************************************
rem System Privileges
column grantee format a40
column PRIVILEGE format a40
prompt ########################################################################
prompt
prompt System Privileges
prompt
select * from sys.dba_sys_privs
	order by grantee,privilege
/
prompt
prompt
rem ***************************************************************************
rem Users
column username format a15
column default_tablespace format a30
column temporary_tablespace format a30
prompt ########################################################################
prompt
prompt Users
prompt
select username,default_tablespace,temporary_tablespace
	from sys.dba_users
	order by username
/
prompt
prompt
rem ***************************************************************************
rem Roles
prompt ########################################################################
prompt
prompt Roles
prompt
select * from sys.dba_roles
	order by role
/
prompt
prompt
rem ***************************************************************************
rem Role Privileges
prompt ########################################################################
prompt
prompt Role Privileges
prompt
select * from sys.dba_role_privs
	order by grantee,granted_role
/
prompt
prompt
rem ***************************************************************************
rem Table Listing
COLUMN table_name FORMAT A35
prompt ########################################################################
prompt
prompt Table Listing
prompt
select owner,table_name from sys.dba_tables
	where owner not in ('SYS','SYSTEM','SCOTT')
	order by owner,table_name
/
prompt
prompt
rem ***************************************************************************
rem Table Privileges
column grantee format a23
column table_name format a30
column owner format a10
column privilege format a20
prompt ########################################################################
prompt
prompt Table Privileges
prompt
select grantee,table_name,owner,privilege from sys.dba_tab_privs
	where grantee not in ('SYS','SYSTEM','EXP_FULL_DATABASE')
	order by grantee,table_name
/
prompt
prompt
rem ***************************************************************************
rem Views Listing
prompt ########################################################################
prompt
prompt Views Listing
prompt
select owner,view_name
	from sys.dba_views
	where owner not in ('SYS','SYSTEM')
	order by owner,view_name
/
prompt
prompt
rem ***************************************************************************
rem Synonyms Listing
column owner noprint
column synonym_name format a30
column table_owner format a15
column table_name format a40
prompt ########################################################################
prompt
prompt Public Synonym Listing
prompt
select owner,synonym_name,table_owner,table_name
	from sys.dba_synonyms
	where owner='PUBLIC' and table_owner not in ('SYS','SYSTEM')
	order by synonym_name
/
prompt
prompt
column owner print
rem ***************************************************************************
rem Index Listing
column owner format a10
column index_name format a30
column table_name format a35
column table_owner format a10
prompt ########################################################################
prompt
prompt Index Listing
prompt
select owner,index_name,table_name,table_owner
	from sys.dba_indexes	
	where owner not in ('SYS','SYSTEM')
	order by index_name,table_name
/
prompt
prompt
rem ***************************************************************************
rem Package Listing
column object_name format a30
column object_type format a20
column status noprint
prompt ########################################################################
prompt
prompt Package Listing
prompt
select object_name,object_type,status
	from sys.dba_objects
	where object_type like 'PACKAGE%'
	order by object_name
/
prompt
prompt
rem ***************************************************************************
rem Close out SQL*Plus script
End Of Scrip File
spool off
rem ***************************************************************************
rem ***************************************************************************
/
