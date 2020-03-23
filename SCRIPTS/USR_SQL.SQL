SET LINESIZE 200
SELECT osuser, username, sql_text
from v$session a, v$sqltext b
where a.sql_address =b.address
order by address, piece
/
