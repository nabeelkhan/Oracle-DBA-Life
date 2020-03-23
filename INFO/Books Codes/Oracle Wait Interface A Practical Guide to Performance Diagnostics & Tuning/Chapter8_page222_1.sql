select cr_requests cr, 
       current_requests cur,
       data_requests data,
       undo_requests undo,
       tx_requests tx 
from   v$cr_block_server;














