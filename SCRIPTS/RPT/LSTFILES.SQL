REM lstfiles.sql checked out on 6/12/97 17:05:15 version 1.3
set termout off
REM ---- Enter the type of file (Control, Data, Redo) or wildcard to match:%
define file_type = '&1'
 
REM ---- Var &2 not used
 
REM ---- Enter Title for the top of the report:?
define app_name = '&3'
 
REM ---- Var &4 not used
 
REM ---- Var &5 not used
 
REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'
 
REM ---- Var &7 not used
 
REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1996 For his personal use
rem Copyright 1996 The DataBase Group, Inc.
rem
start &tool_home/pformat
start &tool_home/rptvars
set termout on
prompt
prompt ******** Generating List all Files 
prompt      for &app_name 
prompt      for file type like &file_type
prompt
set termout off

ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'All Database Files for file type of &file_type' skip 2

btitle center 'Report: lstfiles'

set feedback off
set verify off
set heading on

column sort_order noprint
column file_type heading 'File Type' format a15
column type heading 'Raw Device|or File' format a15
column file_name heading 'File' format a70 word_wrapped
column bytes heading 'Size|(b)' format 999,999,999,999

compute sum of bytes on report
break on file_type skip 2 on type on report

spool &output_file
select          1 sort_order,
		'Control File' file_type,
                decode(substr(name,2,3),'dev','Raw Device','File') type,
                name file_name, 0 bytes
        from v$controlfile
	where 'Control' like '&file_type'
        union
        select  2 sort_order,
		'Redo File' file_type,
		decode(substr(member,2,3),'dev','Raw Redo Log','File') type,
                member file_name, bytes
        from v$logfile lf, v$log l
        where lf.group# = l.group#
	  and 'Redo' like '&file_type'
	union
        select  3 sort_order,
		'Data' file_type,
		decode(substr(file_name,2,3),'dev','Raw Device','File') type,
                file_name file_name, bytes
        from dba_data_files
	where 'Data' like '&file_type'
        order by 1, 3;
spool off
start &tool_home/ppcmd
exit
