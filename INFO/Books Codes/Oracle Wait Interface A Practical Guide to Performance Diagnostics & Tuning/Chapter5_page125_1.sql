-- For versions prior to 8.1.5.
-- Note: This query is not able to differentiate parallel query statements
--       that are executed by multiple SYS users as they all share a common
--       AUDSID.
select decode(ownerid,2147483644,'PARENT','CHILD') stmt_level,
       audsid,
       sid,
       serial#,
       username,
       osuser,
       process,
       sql_hash_value hash_value,
       sql_address
from   v$session
where  type <> ‘BACKGROUND’
and    audsid in (select audsid 
                  from   v$session
                  group by audsid
                  having count(*) > 1)
order by audsid, stmt_level desc, sid, username, osuser;
