select a.total_waits, b.sum_of_sleeps
from  (select total_waits from v$system_event where event = 'latch free') a,
      (select sum(sleeps) sum_of_sleeps from v$latch) b;
