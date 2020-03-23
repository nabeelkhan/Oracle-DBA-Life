-- Prior to Oracle10g:

set lines 130
set numwidth 18
col event for a30
col total_waits for 999,999,999
col total_timeouts for 999,999,999
col time_waited for 999,999,999,999
col average_wait for 999,999,999,999
select a.*, b.startup_time
from   v$system_event a,
       v$instance b
order by a.time_waited;

-- Starting Oracle10g:

set lines 160
set numwidth 18
col class for a15
col event for a30
col total_waits for 999,999,999
col total_timeouts for 999,999,999
col time_waited for 999,999,999,999
col average_wait for 999,999,999,999
select b.class, a.*, c.startup_time
from   v$system_event a,
       v$event_name b,
       v$instance c
where  a.event = b.name
order by b.class, a.time_waited;


