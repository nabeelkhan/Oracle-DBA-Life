select thread#,
       to_char(first_time,'DD-MON-YYYY') creation_date,
       to_char(first_time,'HH24:MI')     time,
       sequence#,
       first_change# lowest_SCN_in_log,
       next_change#  highest_SCN_in_log,
       recid         controlfile_record_id,
       stamp         controlfile_record_stamp
from   v$log_history
order by first_time;
