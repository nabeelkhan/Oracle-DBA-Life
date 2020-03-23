REM lstdblnk.sql checked out on 12/22/97 17:05:21 version 1.1 created on 8/27/97 13:08:38
set termout on
REM ---- Enter the Owner of the Database Link or wildcard to match:%
define owner = '&1'

REM ---- Enter the link name or wildcard to Match:%
define lnk_name = '&2'

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
center 'Defined Database Links for Owners like &owner and Link Names like &lnk_name' skip 2

btitle center 'Report: lstdblnk'

set termout on
prompt
prompt ******** Running DBA List Database Links Report
prompt for link owner   like: &owner
prompt and link name    like: &lnk_name
prompt
set termout off

set feedback off
set verify off

break on usern skip 2

column usern heading 'Link Owner' format a30
column name  heading 'Link Name'  format a45 word_wrapped
column text  heading 'Link Specifics' format a45 word_wrapped

spool &output_file

select 
       decode(u.name, 'PUBLIC','SYSTEM',u.name) usern,
       l.name name,
       l.name||decode(l.userid,NULL,NULL,' CONNECT TO '||l.userid||' IDENTIFIED BY '||l.password)||' USING '''||l.host||'''' text
from 
     sys.user$ u,
     sys.link$ l
where
     u.name like upper('&owner') 
 and u.user# = l.owner#
 and l.name like upper('&lnk_name')
order by u.name, l.name;


spool off
start &tool_home/ppcmd
#exit
