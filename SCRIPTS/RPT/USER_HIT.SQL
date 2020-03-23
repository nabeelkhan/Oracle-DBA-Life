REM user_hit.sql checked out on 8/15/97 17:05:18 version 1.11
set termout off
REM ---- Enter the operating system user name or wildcard:%
define os_user='&1'

REM ---- Enter the ORACLE user name or wildcard:%
define oracle_user='&2'

REM ---- Enter the Title for the top of the report:?
define app_name='&3'

REM ---- Enter the order by preference (1=> disk reads, 2=> hit ratio, 3=> username, 4=> Active, disk reads):1
define order_by_pref='&4'

REM ---- Var '&5' not used

REM ---- Enter Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Var '&7' not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1996 For his personal use
rem
start &tool_home/pformat
start &tool_home/rptvars
column ord_txt new_value ord_prompt
column ord_by_txt new_value ord_by

select
decode(&order_by_pref,
       '1', 'Disk Reads Descending',
       '2','hit ratio Ascending',
       '3', 'ORACLE Username',
       '4', 'Active, Disk Reads Decending',
       'Disk Reads Descending') ord_txt,
decode(&order_by_pref,
        '1', 'physical_reads desc',
        '2','ratio asc',
        '3', 'username, osuser',
	'4', 'status, physical_reads desc',
        'physical_reads desc') ord_by_txt
from dual;

ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Performance Statistics (Hit Ratio) for operating system user: &os_user and ORACLE login &oracle_user' skip 1 -
center 'and ordered by &ord_prompt' skip 2
btitle center 'Report: user_hit'

set feedback off
set verify off
set heading on
set embedded off

column ratio format 990.9 headin 'Hit|Ratio'
column osuser heading 'Operating|System|User' format a12
column process heading 'Oper.|System|Process' format a7
column username heading 'ORACLE|Login' format a12
column sid heading 'SID' format 99999
column block_gets heading 'Block|Gets' format 99,999,990
column consistent_gets heading 'Consistent|Gets' format 999,999,990
column physical_reads heading 'Physical|Reads' format 999,999,990
column block_changes heading 'Block|Changes' format 999,999,990
column consistent_changes heading 'Consistent|Changes' format 999,999,990
Column status heading 'Active|Inactive' format a5
column status_txt heading 'Status' format a8
column stat_count heading 'Count' format 999,990

compute sum of stat_count on report
break on report

set termout on
prompt
prompt ******** Running DBA List User Hit Ratio and IO Statistics
prompt with operating system user like '&os_user'
prompt  and ORACLE username like '&oracle_user'
prompt  and ordered by &ord_prompt
prompt 
set termout off


spool &output_file
select osuser, username, vs.sid, process, 
decode(consistent_gets+block_gets, 0, 0, (1-(physical_reads/(consistent_gets + block_gets)))*100)
ratio, block_gets, consistent_gets, physical_reads, block_changes, consistent_changes, substr(initcap(status),1,5) status
from v$session vs,
     sys.v_$sess_io sio
where vs.sid = sio.sid
  and osuser like '&os_user'
  and username like upper('&oracle_user')
order by &ord_by
;
ttitle center '&app_name' -
center 'Summary of Active/Innactive users' skip 2
select initcap(status) status_txt, count(*) stat_count
from v$session
group by initcap(status);

spool off
start &tool_home/ppcmd
exit
