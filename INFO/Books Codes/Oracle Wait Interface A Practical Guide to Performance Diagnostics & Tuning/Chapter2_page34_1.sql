exec dbms_monitor.session_trace_enable( -
     session_id => 1234, -
     serial_num => 56789, -
     waits => true, -
     binds => true);
-- Let the session execute SQL script 
-- or program for some amount of time 

-- To turn off the tracing:
exec dbms_monitor.session_trace_disable( -
     session_id => 1234, -
     serial_num => 56789); 
