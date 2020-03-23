SELECT  pid,spid,username,serial#,terminal
FROM  v$process
ORDER BY username,pid
/
