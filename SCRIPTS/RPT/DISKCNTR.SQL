REM diskcntr.sql checked out on 6/12/97 17:05:14 version 1.7
set termout off
REM ---- Var '&1' not used

REM ---- Var '&2' not used 

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Var '&4' not used

REM ---- Var '&5' not used

REM ---- Enter Output file name for the report:$report_name.lst
define output_file = '&6'

REM ---- Var '&7' not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1990 For his personal use
rem
start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Conntrollers, Mount Points and Tablespaces' skip 2

btitle center 'Report: diskcntr'

column controller heading 'Hardware|Controller' format a12
column mount_point heading 'Mounted|On or At' format a30
column file_name heading 'File Name' format a50
column tablespace_name heading 'Tablespace Name' format a30

break on report on controller on mount_point on tablespace_name skip 1

set feedback off
set verify off
set heading off
set termout on
prompt
prompt Generating correlation of all tables to disk controller
prompt *************************
prompt ***** C A U T I O N *****
prompt *************************
prompt
prompt ====> Requires a table:
prompt ====>  disk_controller(controller varchar(12) not null ,
prompt ====>                  mount_point varchar(30) not null ,
prompt ====>		      constraint disk_controller_uk unique(controller,mount_point));
prompt
prompt to load this table use the distributed control file 'diskcntr.ctl'
prompt and edit it to read your /etc/vfstab file for mount points on the system
prompt the column mount_point is critical. the column controller can be anything you wish
prompt   use $ sqlload control=diskcntr skip=13 data=vfstab
prompt
set termout off

set headin on
set feedback off

spool &output_file
select
  controller,
  mount_point,
  dbaf.tablespace_name,
  dbaf.file_name
from disk_controller,
     dba_data_files dbaf
where mount_point = substr(dbaf.file_name,1,((instr(file_name,'/',4) -1)))
   or mount_point = file_name
union
select 
  controller,
  mount_point,
  '**** None ****',
  '**** Non Database Related  ****'
from disk_controller
where mount_point not in (select substr(dbaf.file_name,1,((instr(file_name,'/',4) -1))) from dba_data_files dbaf union
			  select substr(member,1,((instr(member,'/',4) -1))) from v$logfile union
			  select substr(replace(value,' ',''),1, instr(replace(value,' ',''),'/',4) -1) 
			  from v$parameter where name = 'control_files' 				union
			  select substr(replace(value,' ',''), instr(replace(value,' ',''),',',1) +1, 
                                         instr(replace(value,' ',''),'/', instr(replace(value,' ',''),',',1)+2) - 
									   instr(replace(value,' ',''),',',1) -1 )
			  from v$parameter where name = 'control_files'				 union
			  select substr(replace(value,' ',''), instr(replace(value,' ',''),',',2) +1, 
					 instr(replace(value,' ',''),'/', instr(replace(value,' ',''),',',2)+2)
                                                                                          - instr(replace(value,' ',''),',',2) -1)
			  from v$parameter where name = 'control_files'
			 )
  and mount_point not in (select file_name from dba_data_files)
union
select
  controller,
  mount_point,
  'REDO LOG',
  'Group('||group#||'):'||member
from v$logfile,
     disk_controller
where mount_point = substr(member,1,((instr(member,'/',4) -1))) 
   or mount_point = member
union
select
  '??????',
  'No entry in disk_controller table',
  'REDO LOG',
  'Group('||group#||'):'||member
from v$logfile
where substr(member,1,((instr(member,'/',4) -1))) not in (select mount_point from disk_controller)
  and member not in (select mount_point from disk_controller)
union
select
'??????',
'No entry in disk_controller table',
dbaf.tablespace_name,
dbaf.file_name
from dba_data_files dbaf
where substr(dbaf.file_name,1,((instr(file_name,'/',4) -1))) not in (select mount_point from disk_controller)
  and file_name not in (select mount_point from disk_controller)
union
select
  controller,
  mount_point,
  'Contol file',
  'Control(1):'||substr(replace(value,' ',''),1,((instr(replace(value,' ',''),',',1,1) -1)))
from v$parameter,
     disk_controller
where mount_point = substr(replace(value,' ',''),1,((instr(replace(value,' ',''),'/',4) -1)))
   or mount_point = replace(value,' ','')
  and name = 'control_files'
union
select
  controller,
  mount_point,
  'Contol file',
  'Control(2):'||substr(replace(value,' ',''), instr(replace(value,' ',''),',',1,1) +1,
		 least(length(value) - instr(replace(value,' ',''),',',1,2) -1, length(value)))
from v$parameter,
     disk_controller
where mount_point = substr(replace(value,' ',''), instr(replace(value,' ',''),',',1,1) +1, 
			    instr(replace(value,' ',''),'/', instr(replace(value,' ',''), ',',1,2)+2) - instr(replace(value,' ',''),',',1,2) -1
                          )
   or mount_point = replace(value,' ','')
  and name = 'control_files'
  and instr(replace(value,' ',''),',',1,1) != 0
union
select
  controller,
  mount_point,
  'Contol file',
  'Control(3):'||substr(replace(value,' ',''), instr(replace(value,' ',''),',',1,2) +1,
		 least(length(value) - instr(replace(value,' ',''),',',1,3) -1, length(value)))
from v$parameter,
     disk_controller
where (mount_point = substr(replace(value,' ',''), instr(replace(value,' ',''),',',1,2) +1, 
			     instr(replace(value,' ',''),'/', instr(replace(value,' ',''),',',1,3)+2) - instr(replace(value,' ',''),',',1,3) -1
                          )
   or mount_point = replace(value,' ',''))
  and name = 'control_files'
  and instr(replace(value,' ',''),',',1,2) != 0
order by 1,2,3,4;
spool off
start &tool_home/ppcmd
exit
