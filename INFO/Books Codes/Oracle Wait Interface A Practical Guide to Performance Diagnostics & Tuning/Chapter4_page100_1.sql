select kglnaobj
from   x$kglob
where  inst_id  = userenv('instance')
and    kglhdadr = <cursor P1RAW>;











