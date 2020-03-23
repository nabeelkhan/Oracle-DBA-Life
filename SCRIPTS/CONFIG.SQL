rem Set up environment
set termout off
set pause off
set pages 540
set feedback off
set time off
rem ***************************************************************************
rem send output to a file
spool C:\nabeel\lst\config
Prompt Script By Nabeel Khan
Prompt Please Use this script with my permission
rem ***************************************************************************
rem Print overall heading for report
set heading off
prompt ########################################################################
prompt #               Oracle Database Configuration Report                   #
prompt ########################################################################
prompt
prompt Instance Name:
select value from v$parameter where name='db_name'
/
prompt
prompt
prompt Date Of This Report:
Column today format a30
select to_char(sysdate,'dd Month YYYY  HH24:MI') today from sys.dual;
Set heading on
prompt
prompt
rem ***************************************************************************
rem  Print datafiles associated with this database
column tablespace_name heading "Tablespace" format a22
column file_id heading ID format 999
column bytes heading "Bytes" format 99,999,999,999
column file_name heading "File Name" format a35
prompt ########################################################################
prompt
prompt Data Files Associated With This Database
prompt
prompt
select file_id,file_name,tablespace_name,bytes
	from sys.dba_data_files
/
prompt
prompt
rem ***************************************************************************
rem  List Redo Log Files Report
column member format a45
prompt ########################################################################
prompt
prompt Redo Log Files
prompt
prompt
select * from v$logfile
/
prompt
prompt
rem ***************************************************************************
rem Tablespace Information Report
column init/next format a20
column min/max format a10
column pct format 999
column tablespace_name format a24 heading "Tablespace"
prompt ########################################################################
prompt
prompt Tablespace Information
prompt
select tablespace_name,initial_extent||'/'||next_extent "Init/Next",
	min_extents||'/'||max_extents "Min/Max",pct_increase pct,status
	from sys.dba_tablespaces
	where status != 'INVALID'
/
prompt
prompt
rem ***************************************************************************
rem  Non-data objects Listing
column owner noprint new_value owner_var
column segment_name format a30 heading "Object name"
column segment_type format a9 heading "Obj Type"
column sum(bytes) format 99,999,999,999 heading "Bytes Used"
column count(*) format 999 heading "#"
prompt ########################################################################
prompt
prompt Non-Data Objects Listing
prompt
select  owner , segment_name , segment_type ,
	sum(bytes) , sum(blocks) , count(*)
	from sys.dba_extents
	where segment_type not in ('TABLE','INDEX','CLUSTER')
	group by owner , segment_name , segment_type
	order by owner , segment_name , segment_type
/
prompt
prompt
rem ***************************************************************************
rem Database objects by type report
column etype format a20 heading 'Object Type'
column kount format 99,999 heading 'Count'
compute sum of kount on report
break on report
prompt ########################################################################
prompt
prompt Numbers of Database Objects by Type
prompt
select decode (o.type#,1,'INDEX' , 2,'TABLE' , 3 , 'CLUSTER' ,
	4, 'VIEW' , 5 , 'SYNONYM' , 6 , 'SEQUENCE' , '??' ) etype# ,
	count(*) kount
	from sys.obj$ o 
	where o.type# > 1
	group by   decode (o.type#,1,'INDEX' , 2,'TABLE' , 3 , 'CLUSTER' ,
	     4, 'VIEW' , 5 , 'SYNONYM' , 6 , 'SEQUENCE' , '??' )
union
select 'COLUMN' , count(*) kount
	from sys.col$
union
select 'DB LINKS' , count(*) kount
	from sys.link$
union
select 'CONSTRAINT' , count(*) kount
	from sys.con$
/
prompt
prompt
rem ***************************************************************************
rem Background Processes
column name format a6 heading 'BGProc'
column description format a27
column error format 999999999999
prompt ########################################################################
prompt
prompt Oracle Background Processes Running
prompt
select paddr , name , description , error
from v$bgprocess
where paddr != '00'
/
prompt
prompt
rem ***************************************************************************
rem SGA Sizing
column value format 999,999,999 heading 'Value - Bytes'
column name format a30 heading 'SGA Group Name'
compute sum of value on report
break on report
prompt ########################################################################
prompt
prompt SGA Sizing
prompt
select * from v$sga
/
prompt
prompt
clear computes
rem ***************************************************************************
rem SGA Parameters
column num format 999 heading 'Num'
column value format a37 heading 'Parameter Value'
column name format a35 heading 'Parameter Name'
prompt ########################################################################
prompt
prompt SGA Parameter Listing
prompt
select num , name , value
	from v$parameter
/
prompt
rem ***************************************************************************
rem End Of SQL*Plus Script
spool off
rem ***************************************************************************
rem ***************************************************************************
/
