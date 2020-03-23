-- Assumption is that you have TOOLS tablespace in your database.

-- Create Begin and End tables to store V$SYSTEM_EVENT contents for
-- time T1 and T2 to compute delta. 
-- ===================================
-- You only need to create these tables once. 
-- ===================================
create table begin_system_event tablespace tools
as 
select * 
from   v$system_event 
where  1=2;

create table end_system_event tablespace tools
as 
select * 
from   v$system_event 
where  1=2;

-- Take a snapshot of V$SYSTEM_EVENT information at time T1
truncate table begin_system_event;
insert into begin_system_event 
  select * 
  from   v$system_event;

-- Wait n seconds or n minutes, and then take another snapshot
-- of V$SYSTEM_EVENT at time T2
truncate table end_system_event;
insert into end_system_event 
  select * 
  from   v$system_event;

-- Report the ‘delta’ numbers for wait events between times T2 and T1
select t1.event,
       (t2.total_waits - nvl(t1.total_waits,0)) "Delta_Waits",
       (t2.total_timeouts - nvl(t1.total_timeouts,0)) "Delta_Timeouts",
       (t2.time_waited - nvl(t1.time_waited,0)) "Delta_Time_Waited"
from   begin_system_event t1,
       end_system_event t2
where t2.event = t1.event(+)
order by (t2.time_waited - nvl(t1.time_waited,0)) desc;
