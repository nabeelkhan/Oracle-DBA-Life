-- Enable ‘level 12’ trace in session 1234 with serial# 56789
exec dbms_support.start_trace_in_session( -
     sid => 1234, -
     serial# => 56789, -
     waits => true, -
     binds => true);

-- Let the session execute SQL script or 
-- program for some amount of time 

-- To turn off the tracing:
exec dbms_support.stop_trace_in_session( -
     sid => 1234, -
     serial# => 56789);



