select hash_value, address, piece, sql_text
from   v$sqltext 
where  hash_value = <cursor hash value>
order by piece;













