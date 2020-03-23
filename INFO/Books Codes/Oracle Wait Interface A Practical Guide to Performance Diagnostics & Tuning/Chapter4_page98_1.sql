select chr(bitand(<cursor P1>,-16777216)/16777215) || 
       chr(bitand(<cursor P1>,16711680)/65535) lock_type,
       mod(<cursor P1>,16) lock_mode
from   dual;





