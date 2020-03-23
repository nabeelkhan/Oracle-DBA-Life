select a.sid,
       a.event,
       a.time_waited,
       a.time_waited / c.sum_time_waited * 100 pct_wait_time,
       round((sysdate - b.logon_time) * 24) hours_connected
from   v$session_event a, v$session b,
      (select sid, sum(time_waited) sum_time_waited
       from   v$session_event
       where  event not in (
                   'Null event',
                   'client message',
                   'KXFX: Execution Message Dequeue - Slave',
                   'PX Deq: Execution Msg',
                   'KXFQ: kxfqdeq - normal deqeue',
                   'PX Deq: Table Q Normal',
                   'Wait for credit - send blocked',
                   'PX Deq Credit: send blkd',
                   'Wait for credit - need buffer to send',
                   'PX Deq Credit: need buffer',
                   'Wait for credit - free buffer',
                   'PX Deq Credit: free buffer',
                   'parallel query dequeue wait',
                   'PX Deque wait',
                   'Parallel Query Idle Wait - Slaves',
                   'PX Idle Wait',
                   'slave wait',
                   'dispatcher timer',
                   'virtual circuit status',
                   'pipe get',
                   'rdbms ipc message',
                   'rdbms ipc reply',
                   'pmon timer',
                   'smon timer',
                   'PL/SQL lock timer',
                   'SQL*Net message from client',
                   'WMON goes to sleep')
       having sum(time_waited) > 0 group by sid) c
where a.sid = b.sid
and   a.sid = c.sid
and   a.time_waited > 0
and   a.event = 'db file sequential read'
order by hours_connected desc, pct_wait_time;
