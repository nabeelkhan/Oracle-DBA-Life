rem ***************************************************************************
rem Script:    tunechk.sql
rem Purpose:   Provide tuning statistics for an Oracle 8 database instance
rem Author:    NABEEL KHAN
rem Revised:   8/11/99
rem Inputs:    Much of the logic in this script is taken from scripts found
rem            on the Compuserve Oracle Forum, the Oracle Server 
rem            Administrator's Guide and other references, Some of my personal
rem	       experiences
rem ***************************************************************************
rem Set up environment
set termout off
set pause off
set pages 540
set feedback off
set time off
rem ***************************************************************************
rem send output to a file
spool lst\tunechk
rem ***************************************************************************
rem Print overall heading for report
set heading off
prompt ########################################################################
prompt #               Oracle Database Tuning Report                        			        #
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
prompt
prompt
set heading on
rem ***************************************************************************
rem  Section of Memory Allocation checks
prompt ########################################################################
prompt
prompt Memory Allocation Checks
prompt
prompt ########################################################################
Prompt
prompt
rem ***************************************************************************
rem Library Cache checks
column libcache format 99.99 heading 'Library Cache Miss Ratio (%)'
prompt Library Cache Check 
prompt
prompt Goal:			<1%
prompt
prompt Corrective Action:	Increase shared_pool_size
prompt .			Write identical SQL statements
prompt
select sum(reloads)/sum(pins) *100 libcache
from v$librarycache
/
prompt
prompt
rem ***************************************************************************
rem Data dictionary cache checks
column ddcache format 99.99 heading 'Data Dictionary Cache Miss Ratio (%)'
prompt ########################################################################
prompt
prompt Data Dictionary Cache Check
prompt
prompt Goal:			<10%
prompt
prompt Corrective Actions:	Increase shared_pool_size
prompt
Select sum(getmisses)/sum(gets) * 100 ddcache
from v$rowcache
/
prompt
prompt
rem ***************************************************************************
rem Shared Pool Checks
column sess_mem heading "Session Memory (Bytes)" format 999,999,999
column sh_pool heading "Shared_Pool_Size (Bytes)" format 999,999,999
column name noprint
prompt ########################################################################
prompt
prompt Multi-Threaded Server Session Memory
prompt
prompt Goal:			Shared_pool_size at lease equal to maximum 
prompt .			session memory
prompt
prompt Corrective Action:	Increase shared_pool_size
prompt
select sum(value) sess_mem
	from v$sysstat
	where name='session memory'
/
prompt
select name,to_number(value) sh_pool
	from v$parameter
	where name='shared_pool_size'
/
prompt
prompt
rem ***************************************************************************
rem Buffer Cache Checks
column pct heading "Hit Ratio (%)" format 999.9
prompt ########################################################################
prompt
prompt Buffer Cache Hit Ratio
prompt
prompt Goal:			Above 60 to 70 percent
prompt
prompt Corrective Action:	Increase db_block_buffers
prompt
select (1- (sum(decode(a.name,'physical reads',value,0)))/
	(sum(decode(a.name,'db block gets',value,0)) +
	sum(decode(a.name,'consistent gets',value,0)))) * 100 pct
	from v$sysstat a
/
prompt
prompt
rem ***************************************************************************
rem I/O checks
prompt ########################################################################
prompt
prompt Disk I/O Checks
prompt
prompt ########################################################################
rem ***************************************************************************
rem Disk Activity Check
column name print
column name heading "Data File" format a45
column phyrds heading "Reads" format 999,999,999
column phywrts heading "Writes" format 999,999,999
prompt ########################################################################
prompt
prompt Disk Activity Check
prompt
prompt Goal:			Balance Load Between Disks
prompt
prompt Corrective Action:	Transfer files, reduce other loads to disks,
prompt .			striping disks, separating data files and redo
prompt .			logs
prompt
prompt
select name,phyrds,phywrts
from v$datafile dr,v$filestat fs
where dr.file#=fs.file#
/
prompt
prompt
rem ***************************************************************************
rem Contention Checks
prompt ########################################################################
prompt
prompt Oracle Contention Checks
prompt
prompt ########################################################################
rem ***************************************************************************
rem Rollback Segment Contention
column class heading "Class" format a20
column count heading "Counts" format 999,999,999
column gets heading "Total Gets" format 999,999,999,999
prompt ########################################################################
prompt
prompt Rollback Segment Contention
prompt
prompt Goal:			Measured Counts < 1% of total gets
prompt .			(the choice of Oracle column names makes it
prompt .			impossible to do this calculation for you)
prompt
prompt Corrective Action:	Add more rollback segments
prompt
prompt
select sum(value) gets
	from v$sysstat
	where name in ('db block gets','consistent gets')
/
prompt
prompt
select class,count
	from v$waitstat
	where class in ('system undo header','system undo block',
	  'undo header','undo block')
/
prompt
prompt
rem ***************************************************************************
rem Latch Contention
column name heading "Latch Type" format a25
column pct_miss heading "Misses/Gets (%)" format 999.99999
column pct_immed heading "Immediate Misses/Gets (%)" format 999.99999
prompt ########################################################################
prompt
prompt Latch Contention Analysis
prompt
prompt Goal:			< 1% miss/get for redo allocation
prompt .			< 1% immediate miss/get for redo copy
prompt
prompt Corrective Action:	Redo allocation-  decrease log_small_entry_
prompt .			  max_size
prompt .			Redo copyIncrease log_simultaneous_copies
prompt
prompt
select n.name,misses*100/(gets+1) pct_miss,
	immediate_misses*100/(immediate_gets+1) pct_immed
	from v$latchname n,v$latch l
	where n.latch# = l.latch# and
	n.name in ('redo allocation','redo copy')
/
prompt
prompt
rem ***************************************************************************
rem MTS Dispatcher contention
column protocol heading "Protocol" format a15
column pct heading "Percent Busy" format 999.99999
prompt ########################################################################
prompt
prompt MTS Dispatcher Contention
prompt
prompt Goal:			< 50%
prompt
prompt Corrective Action:	Add dispatcher processes
prompt
prompt
select network protocol,sum(busy)*100/(sum(busy)+sum(idle)) pct
	from v$dispatcher
	group by network
/
prompt
prompt
rem ***************************************************************************
rem Shared Server Processes Contention
column wait heading "Average Wait Per Request (1/100 sec)" format 9,999.99
column sh_proc heading "Shared Server Processes" format 99
column max_srv heading "MTS_MAX_SERVERS" format 99
prompt ########################################################################
prompt
prompt Shared Server Process Contention
prompt
prompt Goal:			Shared processes less that MTS_MAX_SERVERS
prompt
prompt Corrective Action:	Alter MTS_MAX_SERVERS
prompt
prompt
select decode(totalq,0,'No Requests',wait/totalq || '1/100 sec')
"Average wait per request"
from v$queue
where type='COMMON'
/
prompt
select count(*) "Shared Server Processes"
from v$shared_server
where status !='QUIT'
/
prompt
select name,to_number(value) "MTS_MAX_SERVERS"
        from v$parameter
        where name='mts_max_servers'
/
prompt
prompt
rem ***************************************************************************
rem Redo Log Buffer Space Contention
column value heading "Requests" format 999,999,999
column name noprint
prompt ########################################################################
prompt
prompt Redo Log Buffer Space Contention
prompt
prompt Goal:			Near 0
prompt
prompt Corrective Action:	Increase size of redo log buffer
prompt
prompt
select name,value
	from v$sysstat
	where name='redo log space requests'
/
column name print
prompt
prompt
rem ***************************************************************************
rem Sort Memory Contention
column value heading "Number" format 999,999,999
column name heading "Type" format a15
prompt ########################################################################
prompt
prompt Sort Memory Contention
prompt
prompt Goal:			Mimimize sorts to disk
prompt
prompt Corrective Action:	Increase sort-area-size
prompt
prompt
select name,value
	from v$sysstat
	where name in ('sorts (memory)','sorts (disk)')
/
prompt
prompt
rem ***************************************************************************
rem Free List Contention
column class heading "Class" format a20
column count heading "Counts" format 999,999,999
column gets heading "Total Gets" format 999,999,999,999
prompt ########################################################################
prompt
prompt Free List Contention
prompt
prompt Goal:			Number of counts less that 1% of total gets
prompt
prompt Corrective Action:	Increase free lists (per table)
prompt
prompt
select sum(value) gets
	from v$sysstat
	where name in ('db block gets','consistent gets')
/
prompt
select class,count
	from v$waitstat
	where class='free list'
/
prompt
prompt
rem ***************************************************************************
rem Insert commentary for sar checks that will be appended on the end
prompt
prompt ########################################################################
prompt ########################################################################
prompt
prompt sar statistics
prompt
prompt These statistics have been gathered by the operating system's sar
prompt utility.
prompt
prompt The data will be concantonated onto the end of this file approximately
prompt five minutes after the dbcheck script is started (these processes
prompt monitor operating system activity for 5 minutes)
prompt
prompt
prompt Factors to watch:
prompt
prompt %idle > 0 at peak load	If users see appreciable degradation and
prompt .			user CPU time > system CPU time and memory
prompt .			and disks are not issued, then larger
prompt .			CPU needed
prompt
prompt bread,bwrit,pread,pwrit	If this sum if over 40 for two drives or 
prompt .			60 for 4 to 8 drives, I/O problem
prompt
prompt %wio			If consistently greater than 20, may be
prompt .			I/O bound
prompt
prompt %rcache > 90		For file systems, else I/O bound
prompt % wcache > 60		For file systems, else I/O bound
prompt
prompt page outs,swaps outs	If high, memory may be too small
prompt
prompt
prompt ########################################################################
prompt
prompt System Monitoring Data
prompt
prompt ########################################################################
prompt
prompt
rem ***************************************************************************
rem Close out SQL*Plus script
End Of Script File
spool off
rem ***************************************************************************
rem ***************************************************************************
/
