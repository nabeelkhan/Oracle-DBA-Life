prompt
Prompt ********This Script was created by Nabeel Khan
prompt ********for his personal use...Don't use it with
prompt ********with out his permission!!!
prompt
spool &output_file
prompt
prompt ********RUNNING Disk I/O Activity by file
prompt
--set sqlprompt "KHAN>"
--set termout off
--set verify off
--set feedback off
column PHYRDS format 999,999,999 heading 'Physical Reads' jus cen
column PHYWRTS format 999,999,999 heading 'Physical Writes' jus cen
column PHYRDS format 999,999,999 heading 'Physical Reads' jus cen
column PHYWRTS format 999,999,999 heading 'Physical Writes' jus cen
ttitle center 'Disk Balance Report' skip 2
select 
substr(name,1,35)name, phyrds, phywrts, readtim, writetim
from v$filestat a, v$dbfile b
where a.file# = b.file#
order by readtim desc;
SPOOL OFF
set termout on
set feedback on
set verify on
prompt ********File "Disk I/O Activity by file" complete
