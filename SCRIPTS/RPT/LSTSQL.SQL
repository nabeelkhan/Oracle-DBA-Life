REM lstsql.sql checked out on 6/12/97 17:05:15 version 1.14
set termout off
REM ---- Enter the ORACLE user name or wildcard to match:%
define user_name = '&1'

REM ---- Enter the Operating System Parent process to match:%
define process = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Enter the minimum disk reads for the SQL statement:50000
define min_disk_reads='&4'

REM ---- Enter the minimum buffer gets for the SQL statement:50000
define min_buffer_gets='&5'

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Var '&7' not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1995 For his personal use
rem
start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'SQL Text for User Names like &user_name and process like &process and disk reads/buffer gets > &min_disk_reads/&min_buffer_gets'  skip 2

btitle center 'Report: lstsql'

set feedback off
set verify off
set heading on

set termout on
prompt
prompt ******** Running DBA List SQL Text
prompt for user like '&user_name' 
prompt and OS Process like '&process'
prompt and disk reads > &min_disk_reads
prompt and buffer gets > &min_buffer_gets
prompt
prompt WARNING! Requires access to V$ tables owned by 'SYS'
prompt 
set termout off

column username heading User format a12
column sid heading 'Oracle|SID' format 99999
column process heading 'Operating|System|Proc/Shadow' format a12
column disk_buff heading 'Disk Reads/Buffer gets|in db blocks|(reads/execs)' format a14 word_wrapped
column sql_text heading 'SQL Text' format a64 word_wrapped
column executions heading 'Executions' format 9,999,990
break on sid on username on process skip 1 on disk_buff on executions

spool &output_file
select sid, s.username ,process||'/'||spid process, 
disk_reads||' / '||buffer_gets||' ('||to_char(disk_reads/sa.executions,'999,999,999')||')' disk_buff,
sa.executions, st.sql_text
from 
     v$sqltext st,
     v$sqlarea sa,
     v$process vp,
     v$session s
where s.username like upper('&user_name')
 and s.process like '&process'
 and sa.disk_reads > &min_disk_reads
 and sa.buffer_gets > &min_buffer_gets
 and s.sql_address = sa.address
 and s.sql_hash_value = sa.hash_value
 and sa.hash_value = st.hash_value
 and s.paddr = vp.addr
order by sid, s.username, piece, sa.sql_text;
spool off
start &tool_home/ppcmd
exit
