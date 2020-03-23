select a.kslldnam, b.kslltnum, b.class_ksllt 
from   x$kslld a, x$ksllt b 
where  a.kslldadr = b.addr 
and    b.class_ksllt > 0;
