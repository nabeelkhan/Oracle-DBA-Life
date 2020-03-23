-- Enable Level 12 trace for known Service, 
-- Module and Action
exec dbms_monitor.serv_mod_act_trace_enable( -
     service_name => ‘APPS1’, -
     module_name => ‘GLEDGER’, -
     action_name => ‘DEBIT_ENTRY’, -
     waits => true, -
     binds => true, -
     instance_name => null);

-- Let the session execute SQL script 
-- or program for some amount of time 

-- To turn off the tracing:
exec dbms_monitor.serv_mod_act_trace_disable( -
     service_name => ‘APPS1’, - 
     module_name => ‘GLEDGER’, -
     action_name => ‘DEBIT_ENTRY’);

