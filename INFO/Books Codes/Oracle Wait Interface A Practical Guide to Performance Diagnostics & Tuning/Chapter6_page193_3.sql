select set_id, dbwr_num, blk_size, bbwait 
from   x$kcbwds 
where  bbwait > 0;
