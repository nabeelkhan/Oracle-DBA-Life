-- ***************************************************************************
-- File: 9_12.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 9_12.lis

SELECT SUBSTR(USERNAME,1,10) "User",
       SUBSTR(machine,1,10) "Machine",
       sharable_mem, persistent_mem, 
       runtime_mem, executions, v$sql.module,
       SUBSTR(v$sql.sql_text,1,60) "Statement"
FROM   v$session, v$sql, v$open_cursor
WHERE  v$open_cursor.saddr   = v$session.saddr
AND    v$open_cursor.address = v$sql.address
--AND   users_executing        > 0
--AND   v$session.username     = UPPER('&username')
ORDER BY SUBSTR(USERNAME,1,10), SUBSTR(machine,1,10);

SPOOL OFF
