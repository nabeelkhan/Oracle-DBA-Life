set echo on
alter session set sql_trace=true;

begin
    for x in ( select /* this is my very nice Comment */ * 
                 from big_table.big_table 
                where rownum <= 10000 ) 
    loop
        null;
    end loop;
end;
/
pause
connect /
host tkprof `ls -t $ORACLE_HOME/admin/$ORACLE_SID/udump/*ora_*.trc | head -1` ./tk.prf   sys=no 
edit tk.prf
