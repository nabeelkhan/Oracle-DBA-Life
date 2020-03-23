select event, sid, seq#,
         wait_time,
         seconds_in_wait,
  /*     state,
         p1text, p1, p1raw,
         p2text, p2, p2raw,
         p3text, p3, p3raw
         p1text || ' = ' || p1 parm1,
         p2text || ' = ' || p2 parm2,
         p3text || ' = ' || p3 parm3
  */
         decode( p1text, null, null,
                 p1text || ' = ' || p1 ) ||
         decode( p2text, null, null,
                 ', ' || p2text || ' = ' || p2 ) ||
         decode( p3text, null, null,
                 ', ' || p3text || ' = ' || p3 )
       parameters
    from v$session_wait
    where event not in ( 'pmon timer', 'rdbms ipc message', 'smon timer',
                         'WMON goes to sleep',
                         'SQL*Net message from client' )
   order by event, p1, p2
/
