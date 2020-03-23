REM lstauopt.sql checked out on 7/30/97 17:05:20 version 1.3
set termout off
REM ---- Enter the Owner Name to list audit information for or wildcard to match:%
define owner_name = '&1'
 
REM ---- Enter the Object Type or wildcard to Match:%
define object_type = '&2'
	
REM ---- Enter the Title for the top of the report:?
define app_name = '&3'
	 
REM ---- Enter the Object Name or wildcard to Match:%
define object_name = '&4'
		
REM ---- Var '&5' not used
	 
REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'
	
REM ---- Var '&7' not used
 
REM ----- Home for the utils
define tool_home='/home/oracle/local/dba_rpt'
 
rem Created by Melanie J Burns, 1997 
rem Copyright 1997 by The Database Group, Inc.
rem
start &tool_home/pformat
start &tool_home/rptvars
 
set feedback off
set verify off
set heading off

set termout on
prompt
prompt ******** Running DBA List Audit Object Options Report
prompt for Owner like:         &owner_name
prompt and Object Type like:   &object_type
prompt and Object Name like:   &object_name
prompt

set termout off
set heading on
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Audit Object Options for Owner like &owner_name and Object Type like &object_type and Object Name like &object_name' skip 1 -
center 'First character audits for success, the second for failure in the -/- format.' skip 2

btitle center 'Report: lstauopt'

column owner heading 'Owner' format a10
column object_name heading 'Object|Name' format a40
column object_type heading 'Object|Type' format a8

break on owner on object_type skip 1;

spool &output_file

select owner, object_type, object_name,
			 alt, aud, com, del, gra, ind,
			 ins, loc, ren, sel, upd, ref,
			 exe
	from dba_obj_audit_opts
 where sel != '-/-'
   and owner like upper('&owner_name')
   and object_type like upper('&object_type')
   and object_name like upper('&object_name')
 order by owner, object_type, object_name
/

spool off
start &tool_home/ppcmd
exit
