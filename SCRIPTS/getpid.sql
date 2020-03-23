SELECT s.SID, s.SERIAL#,p.pid, s.OSUSER, s.MACHINE, s.PROGRAM
from v$process p , v$session s
where p.addr = s.paddr
--WHERE MACHINE LIKE '%NK%'
and SID LIKE '&ID'
--WHERE SERIAL# LIKE %77%
ORDER BY MACHINE
/
