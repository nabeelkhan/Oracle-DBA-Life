SELECT   /*+ RULE */
          s.status "Status", s.serial# "Serial#", s.TYPE "Type",
          s.username "DB User", s.osuser "Client User", s.server "Server",
          s.machine "Machine", s.MODULE "Module", s.client_info "Client Info",
          s.terminal "Terminal", s.program "Program",
          p.program "O.S. Program", s.logon_time "Connect Time",
          lockwait "Lock Wait", si.physical_reads "Physical Reads",
          si.block_gets "Block Gets", si.consistent_gets "Consistent Gets",
          si.block_changes "Block Changes",
          si.consistent_changes "Consistent Changes", s.process "Process",
          p.spid, p.pid, si.SID, s.audsid, s.sql_address "Address",
          s.sql_hash_value "Sql Hash", s.action,
          SYSDATE - (s.last_call_et / 86400) "Last Call"
    FROM v$session s, v$process p, SYS.v_$sess_io si
   WHERE s.paddr = p.addr(+) AND si.SID(+) = s.SID
ORDER BY 5
/
