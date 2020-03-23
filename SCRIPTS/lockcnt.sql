SELECT   count(*), NVL (owner, 'SYS') owner, session_id
    FROM sys.dba_dml_locks
group by owner, session_id
ORDER BY 1
/
