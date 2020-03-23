REM-----------------------------------------------
REM	This script finds the Schema or user Size
REM------------------------------------------ 

SELECT tablespace_name, 
Sum(bytes)/1024/1024 AS total_size_mb
FROM dba_segments
WHERE owner = Upper('&User_Name')
GROUP BY owner, rollup(tablespace_name);


REM------------------------------------------
REM	 WITH ALL DB USERS
REM------------------------------------------

REM BREAK ON OWNER;
REM COMPUTE SUM LABEL 'TOTAL' OF total_size_mb ON OWNER; -- THIS ONE OR 
REM COMPUTE SUM OF total_size_mb ON REPORT;	-- THIS ONE!
COLUMN DUMMY NOPRINT
COMPUTE SUM OF total_size_mb ON DUMMY
BREAK ON DUMMY SKIP 1
REM SELECT NULL DUMMY, owner, tablespace_name,
REM Sum(bytes)/1024/1024 AS total_size_mb
REM FROM dba_segments
REM --WHERE owner = Upper('&User_Name')
REM GROUP BY owner, rollup(tablespace_name)

REM------------------------------------------
REM	 Type 3
REM------------------------------------------
BREAK ON OWNER SKIP 1
COMPUTE SUM LABEL 'TOTAL' OF total_size_mb ON OWNER
SELECT NULL DUMMY, owner, tablespace_name,
Sum(bytes)/1024/1024 AS total_size_mb
FROM dba_segments
GROUP BY owner, tablespace_name
