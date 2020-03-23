REM hit_rati.sql checked out on 1/28/97 17:05:15 version 1.9
set termout off
REM ---- Var '&1' not used

REM ---- Var '&2' not used

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Var '&4' not used

REM ---- Var '&5' not used

REM ---- Enter Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Var '&7' not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1990 For his personal use
rem
start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Performance Statistics (Hit Ratio)' skip 2

set feedback off
set verify off
set heading on

column hitratio format a107 word_wrapped heading 'Statistic Reported'
column ratio format 999,999,999,990.90 headin '% Ratio'
column get_ratio heading 'Gets Ratio|above 80 need attention'
column cache_miss heading 'Cache Misses while Executing'
column rank noprint
set null 'null'

set termout on
prompt
prompt ******** Running DBA List Performance Statistics (Redo log Space Requests,
prompt ********   Hit Ratio, Rollback Contention, Shared Server)
prompt 
set termout off


spool &output_file
select 0 rank, 'Hit Ratio should be near 100 (ref SAG 21-17)' hitratio,
decode(bgets.value + cgets.value, 0, 0, (1 - (reads.value/(bgets.value + cgets.value)))*100) Ratio
from v$sysstat reads,
     v$sysstat bgets,
     v$sysstat cgets
where reads.name = 'physical reads'
  and bgets.name = 'db block gets'
  and cgets.name = 'consistent gets'
union
select 1 rank, 'Redo Log Statistics (ratios should be < 1% or near 0 (ref SAG 23-9)' hitratio , 0 ratio
from dual
union
select 2 rank, 'Redo log Space Requests' hitratio, value ratio
from v$sysstat
where name = 'redo log space requests'
union
select 3 rank, 'Average Redo Entry Size (bytes)' hitratio, vs1.value/vs2.value ratio
from v$sysstat vs1, v$sysstat vs2
where vs1.name = 'redo size'
  and vs2.name = 'redo entries'
union
select 4 rank, 'Redo Log Activity - '||l.name||' misses/gets' hitratio, 
decode(gets,0, 0, (misses/gets)*100) ratio
from v$latch l, v$latchname ln
where ln.name in ('redo allocation', 'redo copy')
  and ln.latch# = l.latch#
union
select 5 rank, 'Redo Log Activity - '||l.name||' immediate misses/(immediate_gets + immediate_misses)' hitratio, 
decode(immediate_gets + immediate_misses,0,0,immediate_misses/(immediate_gets + immediate_misses)*100) ratio
from v$latch l, v$latchname ln
where ln.name in ('redo allocation', 'redo copy')
  and ln.latch# = l.latch#
union
select 6 rank, 'Sort Statistics (ref SAG 24-2) - '||name hitratio, value ratio
from v$sysstat
where name like 'sorts%'
union
select 7 rank, 'Free list contention should be < 1% (ref SAG 24-5)' hitratio , 
decode(sum(value), 0, 0, w.count/sum(value)*100) ratio
from v$waitstat w,
     v$sysstat st
where w.class = 'free list'
  and st.name in ('db block gets', 'consistent gets')
group by 6 , 'Free list contention should be < 1% (ref SAG 24-5)', w.count
union
select 8 rank, 'Rollback Contention Statistics - should be < 1% (ref SAG 23-3)' hitratio, 0 ratio
from dual
union
select 9 rank, 'Rollback - '||w.class hitratio, 
decode(sum(st.value), 0, 0, w.count/sum(st.value)*100) ratio
from v$waitstat w,
     v$sysstat st
where w.class in ('system undo header', 'system undo block', 'undo header', 'undo block')
  and st.name in ('db block gets', 'consistent gets')
group by 8, 'Rollback - '||w.class, w.count
union
select 10 rank, 'Shared Server Statistics (ref SAG 23-4) -  Busy Rate ('||network||')' hitratio, 
decode(sum(busy)+sum(idle), 0, 0, sum(busy)/(sum(busy) + sum(idle))) ratio
from v$dispatcher
group by  10 , 'Shared Server Statistics (ref SAG 23-4) -  Busy Rate ('||network||')'
union
select 11 rank, 'Shared Server Statistics (ref SAG 23-5) - Wait Times in hundredths of seconds ('||network||')' hitratio, 
decode(sum(totalq), 0, 0, sum(wait)/sum(totalq)) ratio
from v$queue q, v$dispatcher d
where q.type = 'DISPATCHER'
  and q.paddr = d.paddr
group by 11 , 'Shared Server Statistics (ref SAG 23-5) - Wait Times in hundredths of seconds ('||network||')'
union
select 12 rank, 'Shared Server Statistics (ref SAG 23-7) - Server Contention Times in hundredths of seconds' hitratio, 
decode(totalq, 0, 0, wait/totalq) ratio
from v$queue q
where q.type = 'COMMON'
union
select 13 rank, 'Library Cache - '||initcap(namespace) hitratio, gethitratio*100 ratio
from sys.v_$librarycache
order by 1
/
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Library Cache Statistics'  skip 2
column namespace heading 'Library Object' format a15
column get heading 'Gets' format 999,999,990
column gethits heading 'Get Hits' format 999,999,990
column gethitratio heading 'Get Hit|Ratio' format 999.90
column pins heading 'Pins' format 999,999,990
column pinhits heading 'Pin Hits' format 999,999,990
column pinhitratio heading 'Pin Hit|Ratio' format 999.90
column reloads heading 'Reloads' format 999,990
column invalidations heading 'Invalids' format 999,990
column status_txt heading 'Status' format a8
column stat_count heading 'Count' format 999,990

select initcap(namespace) namespace, gets, gethits, gethitratio, pins, pinhits, pinhitratio, reloads, invalidations 
from sys.v_$librarycache
order by namespace;

ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Session Wait Summary'  skip 2
column event format a30 word_wrapped
column event_count heading 'Count' format 999,999,990

select event, count(event) event_count
from v$session_wait
group by event;


ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Performance Statistics (Gets Ratio for parameters having usage > .8*count and gets != 0)'  skip 2

select parameter,type,100*getmisses/gets get_ratio, count count, usage
from v$rowcache
where gets != 0
and usage > .8*count
order by get_ratio desc;

ttitle center '&app_name' -
center 'Performance Statistics (Cache Misses the Ratio should be near zero)'  skip 1 -
center 'If the Ratio is greater than 1% increase SHARED_POOL_SIZE'  skip 2

select sum(pins) "Executions",sum(reloads) cache_miss,
decode(sum(pins), 0, 0, sum(reloads)/sum(pins)*100) "Ratio"
from v$librarycache;

ttitle center '&app_name' -
center 'Summary of Active/Innactive users' skip 2
select initcap(status) status_txt, count(*) stat_count
from v$session
group by initcap(status);

ttitle center '&app_name' skip 1 -
center 'ORACLE System Global Area' skip 2

column name heading 'System Area'
column value heading 'Size (bytes)' format 999,999,999,990
compute sum of value on report
break on report
select * from v$sga;

spool off
start &tool_home/ppcmd
exit
