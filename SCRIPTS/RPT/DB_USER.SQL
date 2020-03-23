REM db_user.sql checked out on 12/22/97 17:05:21 version 1.1 created on 12/19/97 15:18:04
set termout off
REM ---- Enter the User Name or wildcard to match:%
define user_name = '&1'
 
REM ---- Enter the Default Tablespace Name or wildcard to match:%
define def_name = '&2'
 
REM ---- Enter Title for the top of the report:?
define app_name = '&3'
 
REM ---- Enter the Temporary Tablespace Name or wildcard to match:%
define temp_name = '&4'
 
REM ---- Enter the Profile Name or wildcard to match:%
define prof_name = '&5'
 
REM ---- Enter the Output file name for the report:$report_name.sql
define output_file='&6'
 
REM ---- Enter order by preference (1=> username; 2=> Default tablespace, username; 3=> temporary tablespace, username; 4=> profile, username):1
define ord_pref = '&7'
 
REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem Copyright 1997 The DataBase Group, Inc.
rem
start &tool_home/pformat
start &tool_home/rptvars

column ord_pref_prompt new_value ord_pref_prompt
column ord_pref_txt new_value ord_pref_txt
column brk_txt new_value brk_txt
column sel_txt new_value sel_txt
select 
			 decode(&ord_pref, 1, 'username', 
												 2, 'default_tablespace, username', 
												 3, 'temporary_tablespace, username', 
												 4, 'profile, username', 
												 'username') ord_pref_txt,
			 decode(&ord_pref, 1, 'username', 
												 2, 'default tablespace, username', 
												 3, 'temporary tablespace, username', 
												 4, 'profile, username', 
												 'username') ord_pref_prompt,
			 decode(&ord_pref, 1, 'default_tablespace skip 1 on temporary_tablespace on profile', 
												 2, 'default_tablespace skip 1 on temporary_tablespace on profile', 
												 3, 'temporary_tablespace skip 1 on default_tablespace on profile', 
												 4, 'profile skip 1 on default_tablespace on temporary_tablespace', 
												 'default_tablespace skip 1 on temporary_tablespace on profile') brk_txt,
			 decode(&ord_pref, 1, 'username, user_id, default_tablespace, temporary_tablespace, profile, to_char(created, ''DD-MON-YYYY HH24:MI'') created', 
												 2, 'default_tablespace, username, user_id, temporary_tablespace, profile, to_char(created, ''DD-MON-YYYY HH24:MI'') created',
												 3, 'temporary_tablespace, default_tablespace, username, user_id, profile, to_char(created, ''DD-MON-YYYY HH24:MI'') created', 
												 4, 'profile, username,  user_id, default_tablespace,  temporary_tablespace, to_char(created, ''DD-MON-YYYY HH24:MI'') created', 
												 'username, user_id, default_tablespace, temporary_tablespace, profile, to_char(created, ''DD-MON-YYYY HH24:MI'') created') sel_txt
from dual;

set termout on
prompt
prompt ******** Reporting DB Users 
prompt      for &app_name 
prompt      for User Name like                  &user_name
prompt      and Default Tablespace Name like    &def_name
prompt      and Temporary Tablespace Name like  &temp_name
prompt      and Profile Name like               &prof_name
prompt      ordered by &ord_pref_prompt
prompt

set termout off
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'List of Users where Username like &user_name, Default Tablespace name like &def_name,' skip 1 -
center 'Temporary Tablespace name like &temp_name, and profile name like &prof_name' skip 1 -
center 'ordered by &ord_pref_prompt' skip 1

btitle center 'Report: db_user'

set feedback off
set verify off
set heading on


column username heading 'User Name' format a20
column user_id heading 'User|Id' format 990
column default_tablespace heading 'Default|Tablespace Name' format a28
column temporary_tablespace heading 'Temporary|Tablespace Name' format a28
column profile  heading 'Profile Name' format a20
column created heading 'Created' format a18


break on &brk_txt

spool &output_file
select &sel_txt
from
     dba_users 
where profile like upper('&prof_name')
	and username like upper('&user_name')
	and default_tablespace like upper('&def_name')
	and temporary_tablespace like upper('&temp_name')
order by &ord_pref_txt
/
spool off
start &tool_home/ppcmd
exit
