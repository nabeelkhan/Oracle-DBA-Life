-- Remark: This is an incomplete procedure.
create or replace procedure DC
as
  cursor current_event is
  select a.sid,        a.seq#,            a.event,    a.p1text,
         a.p1,         a.p1raw,           a.p2text,   a.p2,
         a.p2raw,      a.p3text,          a.p3,       a.p3raw,
         a.wait_time,  a.seconds_in_wait, a.state,    b.serial#,
         b.username,   b.osuser,          b.paddr,    b.logon_time,
         b.process,    b.sql_hash_value,  b.saddr,    b.module,
         b.row_wait_obj#, b.row_wait_file#, b.row_wait_block#,
         b.row_wait_row#
  from   v$session_wait a, v$session b
  where  a.sid       = b.sid
  and    b.username is not null 
  and    b.type     <> 'BACKGROUND'
  and    a.event in (
         'db file sequential read',
         'db file scattered read',
         'latch free',
         'direct path read',
         'direct path write',
         'enqueue',
         'library cache pin',
         'library cache load lock',
         'buffer busy waits',
         'free buffer waits');


