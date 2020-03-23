REM lstparms.sql version 1.13 checked out on 12/14/97 09:53:25 17:05:18
set termout off
REM ---- Enter the parameter or wildcard to match (% for all):%
define parm = '&1'

REM ---- Var '&2' not used

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
rem Created by Marc E. Marchioli in 1996
rem Copyright 1996, 1997 by The DataBase Group, Inc.
rem
start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Hidden init.ora parameters and values' skip 2

btitle center 'Report: lstparms'

set feedback off
set verify off
set heading on

set termout on
prompt
prompt ******** Running DBA List all init.ora Parameters
prompt
prompt WARNING! Must be RUN by SYS to view X$ tables
prompt 
set termout off

REM
REM Check version so that the right columns will be use in the select
REM
column ver_check new_value ver_txt noprint

select
decode(substr(version,1,3), '7.3',
'decode(KSPPITY, 1, ''True/False'', 2, ''Character'', 3, ''Number'') KSPPITY, KSPPDESC, KSPPSTVL, KSPPSTDF' ,
  'KSPPIVL, initcap(KSPPIDF) KSPPIDF') ver_check,
  decode(substr(version,1,3), '7.3', 'x$ksppi xi, x$ksppcv xc', 'x$ksppi') ver_from,
  decode(substr(version,1,3), '7.3', 'and xi.indx = xc.indx', ' ') ver_where
from product_component_version
where product like 'O%';

PPINM heading Paremeter format a40
column KSPPDESC heading Description format a40 word_wrapped
column KSPPIVL heading Value format a20
column KSPPSTVL heading Value format a20
column KSPPIDF heading 'Is|Default'
column KSPPSTDF heading 'Is|Default'
column KSPPITY heading Type
column KSPPIFLG heading KSPPIFLG


spool &output_file
select KSPPINM, &ver_txt
from &ver_from
where KSPPINM like '&parm' &ver_where
order by ksppinm;
spool off
start &tool_home/ppcmd
exit
