REM – Run this as SYS user
begin
   dbms_advisor.set_default_task_parameter (
                ‘ADDM’,’DBIO_EXPECTED’,30000);
end;
/











