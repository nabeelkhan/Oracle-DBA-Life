select s.sid, kglpnmod "Mode", kglpnreq "Req"
from   x$kglpn p, v$session s
where  p.kglpnuse=s.saddr
and    kglpnhdl='&P1RAW';








