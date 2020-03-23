select distinct decode(ktssosegt, 1,'SORT', 2,'HASH', 3,'DATA', 
4,'INDEX', 5,'LOB_DATA', 6,'LOB_INDEX', 'UNDEFINED')
from   sys.x$ktsso
where  inst_id  = userenv('instance')
and    ktssoses = <cursor session address>
and    ktssosno = <cursor serial#>;




