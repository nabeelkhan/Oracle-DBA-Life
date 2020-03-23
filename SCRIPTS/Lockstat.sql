set linesize 150
SELECT   NVL (owner, 'SYS') owner, session_id, NAME, mode_held, mode_requested
    FROM sys.dba_dml_locks
ORDER BY 2
/
