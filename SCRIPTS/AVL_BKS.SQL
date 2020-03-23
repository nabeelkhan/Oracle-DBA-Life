select decode(state,0, 'Free',1,decode(lrba_seq,0,'Available','Being Used'),3,
'Being Used', state) "BLock Status" , count(*)
from x$bh
group by decode(state,0, 'Free',1,decode(lrba_seq,0,'Available','Being Used'),3,'Being Used', state)
/
