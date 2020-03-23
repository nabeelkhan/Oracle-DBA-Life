select
  le.leseq  log_sequence#,
  substr(to_char(100 * cp.cpodr_bno / le.lesiz, '999.00'), 2) || '%'  used
from
  x$kcccp  cp,
  x$kccle  le
where
  le.inst_id = userenv('Instance') and
  cp.inst_id = userenv('Instance') and
  le.leseq = cp.cpodr_seq
/
