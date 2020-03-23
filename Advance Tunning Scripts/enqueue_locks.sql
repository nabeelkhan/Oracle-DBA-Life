-------------------------------------------------------------------------------
--
-- Script:	enqueue_locks.sql
-- Purpose:	to display enqueue locks held and wanted in order
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column resource format a20
column sid format a4 justify right
break on resource

select /*+ ordered */
  l.type || '-' || l.id1 || '-' || l.id2  "RESOURCE",
  nvl(b.name, lpad(to_char(l.sid), 4))  sid,
  decode(
    l.lmode,
    1, '      N',
    2, '     SS',
    3, '     SX',
    4, '      S',
    5, '    SSX',
    6, '      X'
  )  holding,
  decode(
    l.request,
    1, '      N',
    2, '     SS',
    3, '     SX',
    4, '      S',
    5, '    SSX',
    6, '      X'
  )  wanting,
  l.ctime  seconds
from
  sys.v_$lock l,
  sys.v_$session s,
  sys.v_$bgprocess b
where
  s.sid = l.sid and
  b.paddr (+) = s.paddr
order by
  l.type || '-' || l.id1 || '-' || l.id2,
  sign(l.request),
  l.ctime desc
/

@restore_sqlplus_settings
