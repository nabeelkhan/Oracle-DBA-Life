REM	This script will show you your tablespace 
REM	size, what percentage is used and free, 
REM	and the number of fragments that happened. 


col tablespace format a11
set linesize 119
select substr(a.TABLESPACE,1,5) tablespace,
a.SIZE_IN_MB,b.FREE_IN_MB,b.MAX_IN_MB,
rpad(ROUND((b.FREE_IN_MB/a.SIZE_IN_MB)*100,2),5)
FREE_PCT,substr(b.FRAG#,1,5) FRAGS# from dual,
(select tablespace_name TABLESPACE,
rpad(round(sum(bytes)/1024/1024,2),5) SIZE_IN_MB
from dba_data_files group by tablespace_name) a,
(select tablespace_name TABLESPACE,
rpad(round(SUM(BYTES)/1024/1024,2),5) FREE_IN_MB,
rpad(round(MAX(BYTES)/1024/1024,2),5) MAX_IN_MB,
count(1) FRAG#
from dba_free_space group by tablespace_name) b
WHERE a.tablespace=b.tablespace(+)
