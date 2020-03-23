REM lstseq.sql checked out on 12/22/97 17:05:21 version 1.1 created on 8/27/97 13:08:38
set termout on
REM ---- Enter the Owner of the sequence or wildcard to match:%
define owner = '&1'

REM ---- Enter the sequence name or wildcard to Match:%
define seq_name = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Var '&4' not used

REM ---- Var '&5' not used

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Var '&7' not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Adam Levine
rem Copyright 1997 by the DataBase Group, Inc.
rem

start &tool_home/pformat
start &tool_home/rptvars

ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Defined Sequences for Sequence Owners like &owner and Sequence Names like &seq_name' skip 1 -
center '(C -> cycle flag; O -> order flag)' skip 2 

btitle center 'Report: lstseq'

set termout on
prompt
prompt ******** Running DBA List Sequences Report
prompt for sequence owner   like: &owner
prompt and sequence name    like: &seq_name
prompt
set termout off

set feedback off
set verify off

column seq_own  heading 'Sequence Owner' format a15
column seq_name heading 'Sequence Name'  format a30
column min_value heading 'Min Value'     
column max_value heading 'Max Value'
column inc_by    heading 'Increment By' 
column cycle     heading 'Cycle Flag'
column order_flag heading 'Order Flag'
column cache_size heading 'Cache Size'
column last_num heading 'Last Num'

break on seq_own on seq_name skip 2

spool &output_file

select sequence_owner seq_own, sequence_name seq_name, min_value, max_value,
       increment_by inc_by, cycle_flag cycle, order_flag,
       cache_size, last_number last_num 
from 
       all_sequences allseq 
where 
       allseq.sequence_owner like upper('&owner') 
   and allseq.sequence_name  like upper('&seq_name') 
order by
       allseq.sequence_owner, allseq.sequence_name;

spool off
start &tool_home/ppcmd
#exit
