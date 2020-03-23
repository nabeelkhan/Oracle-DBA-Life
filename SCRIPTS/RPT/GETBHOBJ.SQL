REM getbhobj.sql checked out on 12/14/97 17:05:18 version 1.3
select ds.owner, ds.segment_name, ds.segment_type, to_char('^1') dbafil, to_char('^2') dbablk,
       decode(^3, 1, 'shared current',
                     2, 'exclusive current',
                     3, 'CR version',
                     0 ) state_desc,
       to_char('^4') occurrances
from    sys.uet$ ue,
        sys.dba_segments ds
where ue.segfile# = ds.header_file
  and ue.segblock# = ds.header_block
  and ue.file# = '^1'
  and ^2 between ue.block# and ue.block#+ue.length-1
order by 7 desc
/
