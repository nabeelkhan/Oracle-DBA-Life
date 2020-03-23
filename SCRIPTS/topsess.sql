SELECT ses.sid, ses.serial#, ses.osuser, ses.process
   FROM v$session ses, v$sess_io sio
  WHERE ses.sid  = sio.sid
    AND nvl(ses.username,'SYS') not in ('SYS', 'SYSTEM')
    AND sio.physical_reads = (SELECT MAX(physical_reads)
                                FROM v$session ses2, v$sess_io sio2
                               WHERE ses2.sid = sio2.sid
                                 AND ses2.username
                                  NOT IN ('SYSTEM', 'SYS'))
/
