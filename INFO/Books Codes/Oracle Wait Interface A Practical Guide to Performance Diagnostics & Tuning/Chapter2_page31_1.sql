alter session set timed_statistics = true;
alter session set max_dump_file_size = unlimited;
-- To enable the trace event 10046 in Oracle 7.3 onwards
alter session set events ‘10046 trace name context forever, level 8’;
-- Run your SQL script or program to trace wait event information
-- To turn off the tracing:
alter session set events ‘10046 trace name context off’;


