-- ***************************************************************************
-- File: 9_23.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 9_23.lis

SELECT a.name, b.xacts tr, c.sid, c.serial#, c.username, d.sql_text 
FROM   v$rollname a, v$rollstat b, v$session c, 
       v$sqltext d,v$transaction e 
WHERE  a.usn            = b.usn    
AND    b.usn            = e.xidusn 
AND    c.taddr          = e.addr 
AND    c.sql_address    = d.address 
AND    c.sql_hash_value = d.hash_value 
ORDER BY a.name, c.sid, d.piece;

SPOOL OFF
