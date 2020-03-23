select a.sid,  a.serial#,  a.username,  a.paddr,  a.logon_time,
       a.sql_hash_value,   b.kglpnmod
from   v$session a, sys.x$kglpn b
where  a.saddr     = b.kglpnuse
and    b.inst_id   = userenv('instance')
and    b.kglpnreq  = 0
and    b.kglpnmod not in (0,1)
and    b.kglpnhdl  = <cursor P1RAW>;












