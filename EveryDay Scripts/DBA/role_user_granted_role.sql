set echo off
set feedback off
set linesize 512

prompt
prompt All User Roles Granted to Roles in Database
prompt

break on GRANTED_ROLE skip 1

SELECT GRANTED_ROLE, GRANTEE, ADMIN_OPTION, DEFAULT_ROLE
	FROM SYS.DBA_ROLE_PRIVS
	WHERE GRANTED_ROLE NOT In (
	'AQ_ADMINISTRATOR_ROLE',
	'AQ_USER_ROLE',
	'CONNECT',
	'CTXAPP',
	'DBA',
	'DELETE_CATALOG_ROLE',
	'EXECUTE_CATALOG_ROLE',
	'EXP_FULL_DATABASE',
	'GLOBAL_AQ_USER_ROLE',
	'HS_ADMIN_ROLE',
	'IMP_FULL_DATABASE',
	'JAVADEBUGPRIV',
	'JAVAIDPRIV',
	'JAVASYSPRIV',
	'JAVAUSERPRIV',
	'JAVA_ADMIN',
	'JAVA_DEPLOY',
	'OEM_MONITOR',
	'OLAP_DBA',
	'RECOVERY_CATALOG_OWNER',
	'RESOURCE',
	'SELECT_CATALOG_ROLE',
	'SNMPAGENT',
	'WKADMIN',
	'WKUSER'
	)
	  AND GRANTEE IN (SELECT ROLE FROM SYS.DBA_ROLES)
	ORDER BY GRANTED_ROLE, ADMIN_OPTION;