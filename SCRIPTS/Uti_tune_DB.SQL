rem ***************************************************************************
rem Script:    uti_tune_db.sql
rem Purpose:   Provide basic statistics on the usage of an Oracle 8 database
rem            instance
rem Author:    Nabeel Khan
rem Revised:   20/12/01
rem Inputs:    Much of the logic in this script is taken from scripts found
rem            on the Oracle Forum, the Oracle Server 
rem            Administrator's Guide and other references. Some of them are 
rem	       my personal experience.
rem ***************************************************************************
rem Set up environment
set termout off
set pause off
set pages 540
set feedback off
set time off
rem ***************************************************************************
rem send output to a file
spool C:\DB_uti_sts.txt
rem ***************************************************************************
rem Print overall heading for report
set heading off
prompt ########################################################################
prompt #               Oracle Database Utilization Report                     #
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
rem ***************************************************************************
rem Tablespace utilization section
set heading on
column freespace heading Free_Bytes format 99,999,999,999
column totlbytes heading Total_Bytes format 99,999,999,999
column tablespace_name heading Table_Space format a22
column pct heading %Used format 999.9
prompt ########################################################################
prompt
prompt Tablespace Utilization
prompt
select alloc.tablespace_name,
 NVL(sum(alloc.bytes),0) totlbytes,
 NVL(sum(free.bytes),0) freespace,
 NVL(sum(USED.bytes),0) USEDbytes,
 NVL(sum(used.bytes),0) / NVL(sum(alloc.bytes),0) * 100 pct
 from
 tablespace_free free,
 tablespace_alloc alloc,
 tablespace_used used
   where free.tablespace_name = alloc.tablespace_name
 and alloc.tablespace_name = used.tablespace_name(+)
   group by alloc.tablespace_name
   order by alloc.tablespace_name
/
prompt
prompt
rem ***************************************************************************
rem Data files in database section
column tablespace_name heading "Table Space" format a22
column file_name heading "File Name" format a35
column bytes format 99,999,999,999
prompt ########################################################################
prompt
prompt Data File Listing Report
prompt
select tablespace_name,file_name,bytes
	from sys.dba_data_files
        order by tablespace_name
/
prompt
prompt
rem ***************************************************************************
rem Table Sizes section
column Bytes heading Bytes format 99,999,999,999
column tablespace_name heading 'Tablespace Name' format a24
column segment_name heading 'Table Name' format a28
column owner heading 'Owner' format a10
prompt ########################################################################
prompt
prompt Table Sizes Report
prompt
select tablespace_name,segment_name,owner,sum(bytes) Bytes
	from sys.dba_extents
	where owner not in ('SYS','SYSTEM') and segment_type='TABLE'
	group by tablespace_name,owner,segment_name
        order by tablespace_name,bytes desc
/
prompt
prompt
rem ***************************************************************************
rem Index Sizes section
column Bytes heading Bytes format 99,999,999,999
column tablespace_name heading 'Tablespace Name' format a24
column segment_name heading 'Index Name' format a28
column owner heading 'Owner' format a10
prompt ########################################################################
prompt
prompt Index Sizes Report
prompt
select tablespace_name,segment_name,owner,sum(bytes) Bytes
	from sys.dba_extents
	where owner not in ('SYS','SYSTEM') and segment_type='INDEX'
	group by tablespace_name,owner,segment_name
        order by tablespace_name,bytes desc
/
prompt
prompt
rem ***************************************************************************
rem Views section
prompt ########################################################################
prompt
prompt Views Report
prompt
Select owner,view_name
   from sys.dba_views
   where owner not in ('SYS','SYSTEM','PUBLIC')
   order by owner,view_name
/
prompt
prompt
rem ***************************************************************************
rem Packages section
column Bytes heading Bytes format 99,999,999,999
column tablespace_name heading 'Tablespace Name' format a24
column segment_name heading 'Index Name' format a28
column owner heading 'Owner' format a10
prompt ########################################################################
prompt
prompt Packages Report
prompt
select unique(name),owner
   from sys.dba_source
   where type='PACKAGE'
   and owner not in ('SYS','SYSTEM','PUBLIC')
   order by owner,name
/
prompt
prompt
rem ***************************************************************************
rem Object fragmentation section
column owner format a10 heading "Owner"
column segment_name format a30 heading "Object Name"
column segment_type format a9 heading "Table  |Index"
column sum(bytes) format 99,999,999,999 heading "Bytes  |Used"
column count(*) format 999 heading "Extents"
prompt ########################################################################
prompt
prompt Table Fragmentation Report
prompt
select owner,segment_name,segment_type,sum(bytes),count(*) frags
from sys.dba_extents
where owner not in ('SYS','SYSTEM')
having count(*) > 1
group by owner,segment_name,segment_type
order by frags desc
/
prompt
prompt
rem ***************************************************************************
rem Tablespace free segments section
prompt ########################################################################
prompt
prompt Tablespace Free Segments Report
prompt
column tablespace_name heading "Table Space" format a22
column bytes format 99,999,999,999
select free.tablespace_name,free.bytes
	from sys.dba_free_space free
	order by free.tablespace_name,free.bytes
/
prompt
prompt
prompt ########################################################################
prompt #                         END OF REPORT 
prompt #                       C:\DB_uti_sts.txt
prompt ########################################################################
prompt
rem ***************************************************************************
rem Close out SQL*Plus script
rem End Of Script File
spool off;
prompt ########################################################################
prompt #    Running Script A for table creation to collect tuning statistics
prompt ########################################################################
@tune_sc_a;
prompt ########################################################################
prompt #                        End of tables creation
prompt ########################################################################
prompt ########################################################################
prompt #                  Running Script for tuning statistics
prompt ########################################################################
@tune_sc_b;
prompt ########################################################################
prompt #                           End Of Script
prompt #                      check c:\tune_report.txt
prompt #                        Thankyou for using it!
prompt ########################################################################

exit;
rem ***************************************************************************
rem ***************************************************************************
/
