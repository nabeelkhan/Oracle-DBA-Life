REM	This script would be useful to find
REM	out how rows in a table are spread across 
REM	different datafiles.
REM
REM	To know how many rows are there in each datafile
REM	for that table.

REM	Works for the version 8+ and above where 
REM	dbms_rowid package is available. 

ACCEPT OWNER CHAR PROMPT "ENTER OWNER NAME : " 
ACCEPT TABNAME CHAR PROMPT "ENTER TABLE NAME : " 
COL count Heading "Rows" 
COL name HEADING "File Name " for a60 
set verify off 

select name ,t.count from 
v$datafile d, 
(select count(*) count ,dbms_rowid.rowid_relative_fno(rowid) file# 
from &&OWNER..&&TABNAME group by dbms_rowid.rowid_relative_fno(rowid)) t 
where t.file#=d.file# 
/ 
undefine OWNER 
undefine TABNAME 
