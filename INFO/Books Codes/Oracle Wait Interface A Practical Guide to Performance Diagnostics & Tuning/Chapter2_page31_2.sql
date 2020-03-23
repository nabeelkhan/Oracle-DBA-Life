-- To include Wait Event data with SQL trace (default option)
exec sys.dbms_support.start_trace;
-- To include Bind variable values, Wait Event data with SQL trace
exec sys.dbms_support.start_trace(waits => TRUE, binds=> TRUE)
-- Run your SQL script or program to trace wait event information
-- To turn off the tracing:
exec sys.dbms_support.stop_trace;



