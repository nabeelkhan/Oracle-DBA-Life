Rem
Rem $Header: statsrep80.sql 01-nov-99.14:39:59 cdialeri Exp $
Rem
Rem statsrep80.sql
Rem
Rem  Copyright (c) Oracle Corporation 1999. All Rights Reserved.
Rem
Rem    NAME
Rem      statsrep80.sql
Rem
Rem    DESCRIPTION
Rem      SQL*Plus command file to report on differences between
Rem      values recorded in two snapshots.
Rem
Rem      8.0 specific report
Rem
Rem    NOTES
Rem      Usually run as the STATSPACK owner, PERFSTAT
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    cdialeri    01/19/00 - Fix %gets and %reads for top SQL
Rem    cdialeri    12/13/99 - Remove top-N for 8.0 replace
Rem                           with PL/SQL
Rem    cdialeri    11/01/99 - Enhance, 1059172
Rem    cgervasi    06/16/98 - Remove references to wrqs
Rem    cmlim       07/30/97 - Modified system events
Rem    gwood.uk    02/30/94 - Modified
Rem    densor.uk   03/31/93 - Modified
Rem    cellis.uk   11/15/89 - Created
Rem

clear break compute;
repfooter off;
ttitle off;
btitle off;
set timing off veri off space 1 flush on pause off termout on numwidth 10;
set echo off feedback off pagesize 60 linesize 132 newpage 2;

--
-- Get the current database/instance information - this will be used 
-- later in the report along with bid, eid to lookup snapshots

column inst_num  heading "Inst Num"    new_value inst_num  format 99999;
column inst_name heading "Instance"  new_value inst_name format a10;
column db_name   heading "DB Name"   new_value db_name   format a10;
column dbid      heading "DB Id"     new_value dbid      format 9999999999 just c;
select d.dbid            dbid
     , d.name            db_name
     , i.instance_number inst_num
     , i.instance_name   inst_name
  from v$database d,
       v$instance i;

variable dbid       number;
variable inst_num   number;
variable inst_name  varchar2(20);
variable db_name    varchar2(20);
begin 
  :dbid      :=  &dbid;
  :inst_num  :=  &inst_num; 
  :inst_name := '&inst_name';
  :db_name   := '&db_name';
end;
/


--
--  Ask for the snapshots Id's which are to be compared

set termout on;
column instart_fmt noprint;
column versn noprint    heading 'Release'  new_value versn;
column host_name noprint heading 'Host'    new_value host_name;
column para  noprint    heading 'OPS'      new_value para;
column level            heading 'Snap Level';
column snap_id      	heading 'SnapId' format 9990;
column snapdat      	heading 'Snap Started' just c	format a22;
column comment          heading 'Comment' format a20;
break on inst_name on db_name on instart_fmt skip 1;
ttitle lef 'Completed Snapshots' skip 2;

select di.instance_name                                  inst_name
     , di.host_name                                      host_name
     , di.db_name                                        db_name
     , sga.version                                       versn
     , sga.parallel                                      para
     , to_char(s.startup_time,' dd Mon "at" HH24:mi:ss') instart_fmt
     , s.snap_id
     , to_char(s.snap_time,' dd Mon YYYY HH24:mi:ss')    snapdat
     , s.snap_level                                      "level"
     , substr(s.ucomment, 1,20)                          "comment"
  from stats$snapshot s
     , stats$database_instance di
     , stats$sgaxs sga
 where s.dbid              = :dbid
   and di.dbid             = :dbid
   and sga.dbid            = :dbid
   and s.instance_number   = :inst_num
   and di.instance_number  = :inst_num
   and sga.instance_number = :inst_num
   and sga.startup_time    = s.startup_time
   and sga.name            = 'Database Buffers'
 order by db_name, instance_name, snap_id;
clear break;
ttitle off;

accept bid number prompt "Enter beginning Snap Id: ";
accept eid number prompt "Enter ending    Snap Id: ";

set termout on;
variable bid   number;
variable eid   number;
variable versn varchar2(10);
variable para  varchar2(9);
variable host_name varchar2(64);
begin 
  :bid    := &bid; 
  :eid    := &eid; 
  :versn  := '&versn';
  :para   := '&para';
  :host_name := '&host_name';
end;
/



--
-- Request output file name, or use default and begin spooling

column sp_fil new_value sp_fil noprint;
select 'st_'||:bid||'_'||:eid sp_fil from dual;

set termout on;
accept spool char prompt "Enter name of output file [&sp_fil] : ";
set termout off;
col spool new_value spool;
select nvl('&spool','&sp_fil') spool from dual;
spool &spool;
set termout on;



--
--  Verify begin and end snapshot Ids exist for the database, and that
--  there wasn't an instance shutdown in between the two snapshots 
--  being taken.

set heading off;

select 'ERROR: Database/Instance does not exist in STATS$DATABASE_INSTANCE'
  from dual
 where not exists
      (select null
         from stats$database_instance
        where instance_number = :inst_num
          and dbid            = :dbid);


select 'ERROR: Begin Snapshot Id specified does not exist for this database/instance'
  from dual
 where not exists
      (select null
         from stats$snapshot b
        where b.snap_id         = :bid
          and b.dbid            = :dbid
          and b.instance_number = :inst_num);


select 'ERROR: End Snapshot Id specified does not exist for this database/instance'
  from dual
 where not exists
      (select null
         from stats$snapshot e
        where e.snap_id         = :eid
          and e.dbid            = :dbid
          and e.instance_number = :inst_num);


select 'WARNING: timed_statitics setting changed between begin/end snaps: TIMINGS ARE INVALID'
  from dual
 where not exists
      (select null
         from stats$parameter b
            , stats$parameter e
        where b.snap_id         = :bid
          and e.snap_id         = :eid
          and b.dbid            = :dbid
          and e.dbid            = :dbid
          and b.instance_number = :inst_num
          and e.instance_number = :inst_num
          and b.name            = e.name
          and b.name            = 'timed_statistics'
          and b.value           = e.value);


select 'ERROR: Snaps chosen spanned an instance shutdown: RESULTS ARE INVALID'
  from dual
 where not exists
      (select null
         from stats$snapshot b
            , stats$snapshot e
        where b.snap_id         = :bid
          and e.snap_id         = :eid
          and b.dbid            = :dbid
          and e.dbid            = :dbid
          and b.instance_number = :inst_num
          and e.instance_number = :inst_num
          and b.startup_time    = e.startup_time);

select 'ERROR: Session statistics are for different sessions: RESULTS ARE INVALID'
  from dual
 where not exists
      (select null
         from stats$snapshot b
            , stats$snapshot e
        where b.snap_id         = :bid
          and e.snap_id         = :eid
          and b.dbid            = :dbid
          and e.dbid            = :dbid
          and b.instance_number = :inst_num
          and e.instance_number = :inst_num
          and b.session_id      = e.session_id
          and b.serial#         = e.serial#);
set heading on;

--
--

set newpage 1 space 2 heading on;

--
--  Summary Statistics
--

--
--  Print database, instance, parallel, release, host and snapshot
--  information

prompt
prompt  STATSPACK report for

set heading on;
column host_name heading "Host"     format a10 print;
column para      heading "OPS"      format a4  print;
column versn     heading "Release"  format a10  print;

select :db_name    db_name
     , :dbid       dbid
     , :inst_name  inst_name
     , :inst_num   inst_num
     , :versn      versn
     , :para       para
     , :host_name  host_name
  from sys.dual;


--
--  Print snapshot information

column inst_num   noprint
column instart_fmt new_value INSTART_FMT noprint;
column instart    new_value instart noprint;
column session_id new_value SESSION noprint;
column ela        new_value ELA     noprint;
column btim       new_value btim    heading 'Start Time' format a20 just c;
column etim       new_value etim    heading 'End Time' format a20 just c;
column bid                          heading 'Start Id'         format 9999990;
column eid                          heading '  End Id'         format 9999990;
column dur        heading 'Snap Length|(Minutes)' format 999,990.00 just c;

select b.instance_number                                 inst_num
     , to_char(b.startup_time, 'dd-Mon-yy hh24:mi:ss')   instart_fmt
     , b.session_id
     , round(((e.snap_time - b.snap_time) * 1440 * 60), 0)    ela  -- secs
     , b.snap_id                                    bid
     , e.snap_id                                    eid
     , to_char(b.snap_time, 'dd-Mon-yy hh24:mi:ss') btim
     , to_char(e.snap_time, 'dd-Mon-yy hh24:mi:ss') etim
     , round(((e.snap_time - b.snap_time) * 1440 * 60), 0)/60 dur  -- mins
     , to_char(b.startup_time,'YYYYMMDD HH24:MI:SS') instart
  from stats$snapshot b
     , stats$snapshot e
 where b.snap_id         = :bid
   and e.snap_id         = :eid
   and b.dbid            = :dbid
   and e.dbid            = :dbid
   and b.instance_number = :inst_num
   and e.instance_number = :inst_num
   and b.startup_time    = e.startup_time
   and b.snap_time       < e.snap_time;


variable btim    varchar2 (20);
variable etim    varchar2 (20);
variable ela     number;
variable instart varchar2 (18);
begin
   :btim    := '&btim'; 
   :etim    := '&etim'; 
   :ela     :=  &ela;
   :instart := '&instart';
end;
/


--
--  Call statspack to calculate certain statistics

set heading off;
variable lhtr number;
variable bfwt number;
variable tran number;
variable chng number;
variable ucal number;
variable urol number;
variable rsiz number;
variable phyr number;
variable phyw number;
variable prse number;
variable hprs number;
variable recr number;
variable gets number;
variable rlsr number;
variable rent number;
variable srtm number;
variable srtd number;
variable srtr number;
variable strn number;
variable call number;
variable lhr  number;
variable sp   varchar2(512);
variable bc   varchar2(512);
variable lb   varchar2(512);
variable bs   varchar2(512);
variable twt  number;
begin STATSPACK.STAT_CHANGES
   ( :bid,  :eid	-- IN arguments
   , :lhtr, :bfwt, :tran, :chng, :ucal, :urol, :rsiz, :phyr, :phyw
   , :prse, :hprs
   , :recr, :gets, :rlsr, :rent, :srtm, :srtd, :srtr, :strn
   , :lhr, :bc, :sp, :lb, :bs,   :twt
   );
   :call := :ucal + :recr;
end;
/

--
--

set heading off;

--
--  Cache Sizes

prompt

column dscr format a28 newline;
column val  format a10 just r;
select 'Cache Sizes' dscr
      ,'~~~~~~~~~~~' dscr
      ,'           db_block_buffers:' dscr, lpad(:bc,10) val
      ,'              db_block_size:' dscr, lpad(:bs,10) val
      ,'                 log_buffer:' dscr, lpad(:lb,10) val
      ,'           shared_pool_size:' dscr, lpad(:sp,10) val
  from sys.dual;

--
--  Load Profile

column dscr  format a28 newline;
column val   format 999,999,999,990.99;
column sval  format 99,990.99;
column totcalls new_value totcalls noprint
select 'Load Profile'
      ,'~~~~~~~~~~~~' dscr
      ,'         Per Second      Per Transaction'
      ,'                                  ---------------      ---------------'
      ,'                  Redo size:' dscr, round(:rsiz/&ela,2)  val
                                          , round(:rsiz/:tran,2) val
      ,'              Logical reads:' dscr, round(:gets/&ela,2)  val
                                          , round(:gets/:tran,2) val
      ,'              Block changes:' dscr, round(:chng/&ela,2)  val
                                          , round(:chng/:tran,2) val
      ,'             Physical reads:' dscr, round(:phyr/&ela,2)  val
                                          , round(:phyr/:tran,2) val
      ,'            Physical writes:' dscr, round(:phyw/&ela,2)  val
                                          , round(:phyw/:tran,2) val
      ,'                 User calls:' dscr, round(:ucal/&ela,2)  val
                                          , round(:ucal/:tran,2) val
      ,'                     Parses:' dscr, round(:prse/&ela,2)  val
                                          , round(:prse/:tran,2) val
      ,'                Hard parses:' dscr, round(:hprs/&ela,2)  val
                                          , round(:hprs/:tran,2) val
      ,'                      Sorts:' dscr, round((:srtm+:srtd)/&ela,2)  val
                                          , round((:srtm+:srtd)/:tran,2) val
      ,'               Transactions:' dscr, round(:tran/&ela,2)  val
      , '                           ' dscr
      ,'              Rows per Sort:' dscr, decode((:srtm+:srtd)
						   ,0,to_number(null)
                                            ,round(:srtr/(:srtm+:srtd),2)) sval
      ,'  Pct Blocks changed / Read:' dscr, round(100*:chng/:gets,2) sval
      ,'         Recursive Call Pct:' dscr, round(100*:recr/:call,2) sval
      ,' Rollback / transaction Pct:' dscr, round(100*:urol/:tran,2) sval
 from  dual;


--
--  Instance Efficiency Percentages

column ldscr  format a50
column pctval format 99,990.99;
select 'Instance Efficiency Percentages (Target 100%)' ldscr
      ,'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' ldscr
      ,'        Buffer Nowait Ratio:' dscr, round(100*(1-:bfwt/:gets),2)     pctval
      ,'        Buffer  Hit   Ratio:' dscr, round(100*(1-:phyr/:gets),2)     pctval
      ,'        Library Hit   Ratio:' dscr, round(100*:lhtr,2)               pctval
      ,'        Redo   NoWait Ratio:' dscr, decode(:rent,0,to_number(null),
                                          round(100*(1-:rlsr/:rent),2))      pctval
      ,'       In-memory Sort Ratio:' dscr, decode((:srtm+:srtd),0,to_number(null),
                                          round(100*:srtm/(:srtd+:srtm),2))  pctval
      ,'           Soft Parse Ratio:' dscr, round(100*(1-:hprs/:prse),2)     pctval
      ,'            Latch Hit Ratio:' dscr, round(100*(1-:lhr),2)            pctval
 from  dual;

--
--

set heading on space 1;
repfooter center -
   '-------------------------------------------------------------';

--
--  Top Wait Events

execute dbms_output.enable;
set serveroutput on size 800000;

declare

  event_name    stats$system_event.event%type;
  waits         stats$system_event.total_waits%type;
  wait_time     stats$system_event.time_waited%type;
  pct_wait_time number(12,2);

  cursor ordered_events is
        select e.event                               event
             , e.total_waits - nvl(b.total_waits,0)  waits
             , e.time_waited - nvl(b.time_waited,0)  time
             , decode(:twt, 0, 0,
                100*((e.time_waited - nvl(b.time_waited,0))/:twt))  pctwtt
          from stats$system_event b
             , stats$system_event e
         where b.snap_id             = :bid
           and e.snap_id             = :eid
           and b.dbid(+)             = :dbid
           and e.dbid                = :dbid
           and b.instance_number (+) = :inst_num
           and e.instance_number     = :inst_num
           and b.event(+)            = e.event
           and e.total_waits         > nvl(b.total_waits,0)
           and e.event not in
               ( select event
                   from stats$idle_event
               )
           order by time desc, waits desc;
begin
  dbms_output.put_line('Top 5 Wait Events');
  dbms_output.put_line('~~~~~~~~~~~~~~~~~                                    Wait    % Total');
  dbms_output.put_line('Event                                      Waits   Time (cs) Wt Time');
  dbms_output.put_line('---------------------------------------- --------- --------- ------');
  open ordered_events;
  for i in 1 .. 5 loop
     fetch ordered_events into event_name, waits, wait_time, pct_wait_time;
     dbms_output.put_line(rpad(event_name,  40)||' '||
                          lpad(waits,        9)||' '||
                          lpad(wait_time,    9)||' '||
                          lpad(pct_wait_time,4));
     exit when ordered_events%NOTFOUND;
  end loop;

end;
/

--
--

set space 1 termout on newpage 0;
whenever sqlerror exit;


--
--  System Events

ttitle lef 'Wait Events for ' -
           'DB: ' db_name  '  Instance: ' inst_name '  '-
           'Snaps: ' format 999999 bid ' -' format 999999 eid -
       skip 1 -
           '->cs - centisecond -  100th of a second' -
       skip 1 -
           '->ms - millisecond - 1000th of a second (unit often used for disk IO timings)' -
       skip 2;

col idle noprint;
col event    format a28              heading 'Event' trunc;
col waits    format 999,999,990      heading 'Waits';
col timeouts format 9,999,990        heading 'Timeouts';
col time     format 999,999,999,990  heading 'Total Wait|Time (cs)';
col wt       format 999990           heading 'Avg|wait|(ms)';
col txwaits  format 990.0            heading 'Waits|/txn';

select e.event 
     , e.total_waits - nvl(b.total_waits,0)       waits
     , e.total_timeouts - nvl(b.total_timeouts,0) timeouts
     , e.time_waited - nvl(b.time_waited,0)       time
     , decode ((e.total_waits - nvl(b.total_waits, 0)),
                0, to_number(NULL),
                (e.time_waited - nvl(b.time_waited,0)) /
                (e.total_waits - nvl(b.total_waits,0))*10) wt
     , (e.total_waits - nvl(b.total_waits,0))/:tran txwaits
     , decode(i.event, null, 0, 99)               idle
  from stats$system_event b
     , stats$system_event e
     , stats$idle_event   i
 where b.snap_id(+)          = :bid
   and e.snap_id             = :eid
   and b.dbid(+)             = :dbid
   and e.dbid                = :dbid
   and b.instance_number (+) = :inst_num
   and e.instance_number     = :inst_num
   and b.event(+)            = e.event
   and e.total_waits         > nvl(b.total_waits,0)
   and e.event       not like '%timer%'
   and e.event       not like 'rdbms ipc%'
   and i.event(+)            = e.event
 order by idle, time desc, waits desc;



--
--  Background process wait events

ttitle lef 'Background Wait Events for ' -
           'DB: ' db_name  '  Instance: ' inst_name '  '-
           'Snaps: ' format 999999 bid ' -' format 999999 eid -
       skip 2;

break on idle;
select e.event
     , e.total_waits - nvl(b.total_waits,0)                waits
     , e.total_timeouts - nvl(b.total_timeouts,0)          timeouts
     , e.time_waited - nvl(b.time_waited,0)                time
     , decode ((e.total_waits - nvl(b.total_waits, 0)),
               0, to_number(NULL),
               (e.time_waited - nvl(b.time_waited,0)) /
               (e.total_waits - nvl(b.total_waits,0))*10)  wt
     , (e.total_waits - nvl(b.total_waits,0))/:tran        txwaits
     , decode(i.event, null, 0, 99)                        idle
  from stats$bg_event_summary   b
     , stats$bg_event_summary   e
     , stats$idle_event i
 where b.snap_id         = :bid
   and e.snap_id         = :eid
   and b.dbid            = :dbid
   and e.dbid            = :dbid
   and b.instance_number = :inst_num
   and e.instance_number = :inst_num
   and b.event           = e.event
   and e.total_waits     > nvl(b.total_waits,0)
   and i.event(+)        = e.event
 order by idle, time desc, waits desc;
clear break;


--
--  SQL Reporting

col Execs     format 9,9,999,990    heading 'Executes';
col GPX       format 9,999,990.0    heading 'Gets|per Exec'  just c;
col RPX       format 9,999,990.0    heading 'Reads|per Exec' just c;
col RWPX      format 9,999,990.0    heading 'Rows|per Exec'  just c;
col Gets      format 9,999,999,990  heading 'Buffer Gets';
col Reads     format 9,999,999,990  heading 'Physical|Reads';
col Rw        format 9,999,999,990  heading 'Rows | Processed';
col hashval   format 99999999999    heading 'Hash Value';
col sql_text  format a78            heading 'SQL statement'  trunc;
col rel_pct   format 999.9          heading '% of|Total';

--
--  SQL statements ordered by buffer gets

ttitle lef 'SQL ordered by Gets for ' -
           'DB: ' db_name  '  Instance: ' inst_name '  '-
           'Snaps: ' format 999999 bid ' -' format 999999 eid -
       skip 2;

repfooter off;
set heading off embedded off;
select ' ' spc from sys.dual;
set heading on;

declare
  Gets       stats$sql_summary.buffer_gets%type;
  Execs      stats$sql_summary.executions%type;
  sqltext    stats$sql_summary.sql_text%type;
  GPX        number;
  hash_value stats$sql_summary.hash_value%type;

  cursor sql_by_gets is
         select e.buffer_gets - nvl(b.buffer_gets,0)       Gets
              , e.executions - nvl(b.executions,0)         Execs
              , decode ((e.executions - nvl(b.executions, 0)), 0, to_number(NULL)
              , (e.buffer_gets - nvl(b.buffer_gets,0)) /
                (e.executions  - nvl(b.executions,0)))     GPX
              , e.sql_text                                 sql_text
              , e.hash_value                               hash_value
           from stats$sql_summary b
              , stats$sql_summary e
          where b.snap_id(+)         = :bid
            and e.snap_id            = :eid
            and b.dbid(+)            = :dbid
            and e.dbid               = :dbid
            and b.instance_number(+) = :inst_num
            and e.instance_number    = :inst_num
            and b.hash_value(+)      = e.hash_value
            and b.address(+)         = e.address
            and e.executions         > nvl(b.executions,0)
          order by Gets desc;

begin

  dbms_output.put_line('Buffer                         Gets       % of');
  dbms_output.put_line('Gets               Executes   Per Exec    Total   Hash value');
  dbms_output.put_line('-------------- ------------ ------------ ------ ------------');
  open sql_by_gets;
  for i in 1 .. 17 loop
     fetch sql_by_gets into Gets, Execs, GPX, sqltext, hash_value;
     dbms_output.put_line(        rpad(Gets,    14)
                          ||' '|| rpad(Execs,   12)
                          ||' '|| rpad(round(GPX,1), 12)
                          ||' '|| rpad(round(100*(Gets/:gets),1), 6)
                          ||' '|| rpad(hash_value,   12)
                         );
     dbms_output.put_line(rpad(sqltext,78));
     exit when sql_by_gets%NOTFOUND;
  end loop;

end;
/

set heading off newpage none;
ttitle off;
repfooter center -
   '-------------------------------------------------------------';
select ' ' spc from sys.dual;
set heading on newpage 0;



--
--  SQL statements ordered by physical reads

ttitle lef 'SQL ordered by Reads for ' -
           'DB: ' db_name  '  Instance: ' inst_name '  '-
           'Snaps: ' format 999999 bid ' -' format 999999 eid -
       skip 2;

repfooter off;
set heading off embedded off;
select ' ' spc from sys.dual;
set heading on;

declare
  Reads   stats$sql_summary.disk_reads%type;
  Execs   stats$sql_summary.executions%type;
  sqltext stats$sql_summary.sql_text%type;
  RPX     number;
  hash_value stats$sql_summary.hash_value%type;

  cursor sql_by_reads is
        select e.disk_reads - nvl(b.disk_reads,0)             Reads
             , e.executions - nvl(b.executions,0)             Execs
             , decode ((e.executions - nvl(b.executions, 0)), 0, to_number(NULL)
                       , (e.disk_reads - nvl(b.disk_reads,0)) /
                       (e.executions - nvl(b.executions,0)))  RPX
             , e.sql_text                                     sql_text
             , e.hash_value                                   hash_value
          from stats$sql_summary b
             , stats$sql_summary e
         where b.snap_id(+)         = :bid
           and e.snap_id            = :eid
           and b.dbid(+)            = :dbid
           and e.dbid               = :dbid
           and b.instance_number(+) = :inst_num
           and e.instance_number    = :inst_num
           and b.hash_value(+)      = e.hash_value
           and b.address(+)         = e.address
           and e.executions         > nvl(b.executions,0)
         order by Reads desc;

begin

  dbms_output.put_line('Physical                      Reads       % of');
  dbms_output.put_line('Reads          Executes      per Exec     Total   Hash Value');
  dbms_output.put_line('-------------- ------------ ------------ ------ ------------');

  open sql_by_reads;
  for i in 1 .. 18 loop
     fetch sql_by_reads into Reads, Execs, RPX, sqltext, hash_value;
     dbms_output.put_line(        rpad(Reads,   14)
                          ||' '|| rpad(Execs,   12)
                          ||' '|| rpad(round(RPX,1), 12)
                          ||' '|| rpad(round(100*(Reads/:phyr),1), 6)
                          ||' '|| rpad(hash_value,   12)
                         );
     dbms_output.put_line(rpad(sqltext,78));
     exit when sql_by_reads%NOTFOUND;
  end loop;

end;
/

set heading off newpage none;
ttitle off;
repfooter center -
   '-------------------------------------------------------------';
select ' ' spc from sys.dual;
set heading on newpage 0;



--
--  SQL statements ordered by rows

ttitle lef 'SQL ordered by Rows for ' -
           'DB: ' db_name  '  Instance: ' inst_name '  '-
           'Snaps: ' format 999999 bid ' -' format 999999 eid -
       skip 2;

repfooter off;
set heading off embedded off;
select ' ' spc from sys.dual;
set heading on;
declare
  Rw      stats$sql_summary.rows_processed%type;
  Execs   stats$sql_summary.executions%type;
  sqltext stats$sql_summary.sql_text%type;
  RWPX    number;
  hash_value stats$sql_summary.hash_value%type;

  cursor sql_by_rows is
         select e.rows_processed - nvl(b.rows_processed,0)       Rw
              , e.executions - nvl(b.executions,0)               Execs
              , decode ( (e.executions - nvl(b.executions,0))
                        , 0, to_number(NULL)
                        , (e.rows_processed - nvl(b.rows_processed,0))
                         /(e.executions - nvl(b.executions,0)))  RWPX
              , e.sql_text                                       sql_text
              , e.hash_value                                     hash_value
           from stats$sql_summary b
              , stats$sql_summary e
          where b.snap_id(+)         = :bid
            and e.snap_id            = :eid
            and b.dbid(+)            = :dbid
            and e.dbid               = :dbid
            and b.instance_number(+) = :inst_num
            and e.instance_number    = :inst_num
            and b.hash_value(+)      = e.hash_value
            and b.address(+)         = e.address
            and e.executions         > nvl(b.executions,0)
          order by Rw desc;

begin

  dbms_output.put_line('Rows                          Rows');
  dbms_output.put_line('Processed      Executes      per Exec      Hash Value');
  dbms_output.put_line('-------------- ------------ ------------ ------------');

  open sql_by_rows;
  for i in 1 .. 18 loop
     fetch sql_by_rows into Rw, Execs, RWPX, sqltext, hash_value;
     dbms_output.put_line(        rpad(Rw,       14)
                          ||' '|| rpad(Execs,    12)
                          ||' '|| rpad(round(RWPX,1),12)
                          ||' '|| rpad(hash_value,   12)
                         );
     dbms_output.put_line(rpad(sqltext,78));
     exit when sql_by_rows%NOTFOUND;
  end loop;

end;
/

set heading off newpage none;
ttitle off;
repfooter center -
   '-------------------------------------------------------------';
select ' ' spc from sys.dual;
set heading on newpage 0;



--
--  Instance Activity Statistics

ttitle lef 'Instance Activity Stats for ' -
           'DB: ' db_name  '  Instance: ' inst_name '  '-
           'Snaps: ' format 999999 bid ' -' format 999999 eid -
       skip 2;

column st	format a33                heading 'Statistic' trunc;
column dif	format 999,999,999,990	  heading 'Total';
column ps	format 999,999,990.9	  heading 'per Second';
column pt       format 999,999,990.9      heading 'per Trans';

select b.name st
     , to_number(decode(instr(b.name,'current')
                     ,0,e.value - b.value,null)) dif
     , to_number(decode(instr(b.name,'current')
                       ,0,round((e.value - b.value) 
					/:ela,2),null)) ps
     , to_number(decode(instr(b.name,'current')
                       ,0,round((e.value - b.value) 
                                     /:tran,2),null)) pt
 from  stats$sysstat b
     , stats$sysstat e
 where b.snap_id         = :bid
   and e.snap_id         = :eid
   and b.dbid            = :dbid
   and e.dbid            = :dbid
   and b.instance_number = :inst_num
   and e.instance_number = :inst_num
   and b.name            = e.name
   and e.value          >= b.value
   and e.value          >  0
 order by st;



--
--  Session Activity Statistics

ttitle lef 'Session Statistics for ' -
           'DB: ' db_name  '  Instance: ' inst_name '  '-
           'Snaps: ' format 999999 bid ' -' format 999999 eid -
       skip 2;
 
select lower(substr(ss.name,1,38)) st
     , to_number(decode(instr(ss.name,'current')
                     ,0,e.value - b.value,null)) dif
     , to_number(decode(instr(ss.name,'current')
                       ,0,round((e.value - b.value)
                                        /:ela,2),null)) ps
     , to_number(decode(instr(ss.name,'current')
                       ,0,decode(:strn, 
				 0, round(e.value - b.value), 
			            round((e.value - b.value)
                                     /:strn,2),null))) pt
  from stats$sesstat b
     , stats$sesstat e
     , stats$sysstat ss
     , stats$snapshot bs
     , stats$snapshot es
 where b.snap_id          = :bid
   and e.snap_id          = :eid
   and b.dbid             = :dbid
   and e.dbid             = :dbid
   and b.instance_number  = :inst_num
   and e.instance_number  = :inst_num
   and ss.snap_id         = :eid
   and ss.dbid            = :dbid
   and ss.instance_number = :inst_num
   and b.statistic#       = e.statistic#
   and ss.statistic#      = e.statistic#
   and e.value            > b.value
   and bs.snap_id         = b.snap_id
   and es.snap_id         = e.snap_id
   and bs.dbid            = b.dbid
   and es.dbid            = b.dbid
   and bs.dbid            = e.dbid
   and es.dbid            = e.dbid
   and bs.dbid            = ss.dbid
   and es.dbid            = ss.dbid
   and bs.instance_number = b.instance_number
   and es.instance_number = b.instance_number
   and bs.instance_number = ss.instance_number
   and es.instance_number = ss.instance_number
   and bs.instance_number = e.instance_number
   and es.instance_number = e.instance_number
   and bs.session_id      = es.session_id
   and bs.serial#         = es.serial#
 order by st;



--
--  Tablespace IO summary statistics

ttitle lef 'Tablespace IO Summary for '-
           'DB: ' db_name  '  Instance: ' inst_name '  '-
           'Snaps: ' format 999999 bid ' -' format 999999 eid -
       skip 2;

col tbsp       format a25         heading 'Tablespace'
col reads      format 99,999,990  heading 'Reads'
col atpr       format 990.0       heading 'Avg Read|(ms)' just c;
col writes     format 99,999,990  heading 'Writes'
col waits      format 9,999,990   heading 'Total|Waits'
col atpwt      format 99990.0     heading 'Avg Wait|(ms)' just c;

select e.tsname                                             tbsp
     , sum (e.phyrds - nvl(b.phyrds,0))                     reads
     , decode( sum(e.phyrds - nvl(b.phyrds,0))
             , 0, 0
             , (sum(e.readtim - nvl(b.readtim,0)) /
                sum(e.phyrds  - nvl(b.phyrds,0)))*10)       atpr
     , sum (e.phywrts    - nvl(b.phywrts,0))                writes
     , sum (e.wait_count - nvl(b.wait_count,0))             waits
     , decode (sum(e.wait_count - nvl(b.wait_count, 0))
            , 0, 0
            , (sum(e.time       - nvl(b.time,0)) / 
               sum(e.wait_count - nvl(b.wait_count,0)))*10) atpwt
  from stats$filestatxs e
     , stats$filestatxs b
 where e.snap_id            = :eid
   and b.snap_id(+)         = :bid
   and b.dbid(+)            = :dbid
   and e.dbid               = :dbid
   and b.dbid(+)            = e.dbid
   and b.instance_number(+) = :inst_num
   and e.instance_number    = :inst_num
   and b.instance_number(+) = e.instance_number
   and e.tsname             = b.tsname(+)
   and e.filename           = b.filename(+)
   and ( (e.phyrds  - nvl(b.phyrds,0)  )  + 
         (e.phywrts - nvl(b.phywrts,0) ) ) > 0
 group by e.tsname
 order by reads + writes desc;



set wrap off;
--
--  File IO statistics

ttitle lef 'File IO Statistics for '-
           'DB: ' db_name  '  Instance: ' inst_name '  '-
           'Snaps: ' format 999999 bid ' -' format 999999 eid -
       skip 2;

col tsname     format a10           heading 'Tablespace';
col filename   format a34           heading 'Filename';
col reads      format 99,999,990    heading 'Reads';
col bpr        format 99.0          heading 'Avg Blks Rd';
col tpr        format 990.0         heading 'Avg Rd (ms)';
col writes     format 99,999,990    heading 'Writes';
col waits      format 9,999,990     heading 'Tot Waits';
col tpwt       format 99990.0       heading 'Avg Wait|(ms)' just c;

select e.tsname
     , e.filename
     , e.phyrds- nvl(b.phyrds,0)                       reads
     , decode ((e.phyrds - nvl(b.phyrds, 0)), 0, to_number(NULL),
          (e.phyblkrd - nvl(b.phyblkrd,0)) / 
          (e.phyrds   - nvl(b.phyrds,0)) )             bpr
     , decode ((e.phyrds - nvl(b.phyrds, 0)), 0, to_number(NULL),
          ((e.readtim  - nvl(b.readtim,0)) /
           (e.phyrds   - nvl(b.phyrds,0)))*10)         tpr
     , e.phywrts - nvl(b.phywrts,0)                    writes
     , e.wait_count - nvl(b.wait_count,0)              waits
     , decode ((e.wait_count - nvl(b.wait_count, 0)), 0, to_number(NULL),
          ((e.time       - nvl(b.time,0)) /
           (e.wait_count - nvl(b.wait_count,0)))*10)   tpwt
  from stats$filestatxs e
     , stats$filestatxs b
 where e.snap_id            = :eid
   and b.snap_id(+)         = :bid
   and b.dbid(+)            = :dbid
   and e.dbid               = :dbid
   and b.dbid(+)            = e.dbid
   and b.instance_number(+) = :inst_num
   and e.instance_number    = :inst_num
   and b.instance_number(+) = e.instance_number
   and e.tsname             = b.tsname(+)
   and e.filename           = b.filename(+)
   and ( (e.phyrds  - nvl(b.phyrds,0)  ) + 
         (e.phywrts - nvl(b.phywrts,0) ) ) > 0
 order by tsname, filename;



--
--  Buffer waits summary

ttitle lef 'Buffer wait Statistics for '-
           'DB: ' db_name  '  Instance: ' inst_name '  '-
           'Snaps: ' format 999999 bid ' -' format 999999 eid -
       skip 2;

column class	                        heading 'Class';
column icnt	format 99,999,990	heading 'Waits';
column itim	format  9,999,990	heading 'Tot Wait|Time (cs)';
column iavg     format    999,990	heading 'Avg|Time (cs)' just c;

select e.class
     , e.wait_count  - nvl(b.wait_count,0)     icnt
     , e.time        - nvl(b.time,0)           itim
     , (e.time       - nvl(b.time,0)) / 
       (e.wait_count - nvl(b.wait_count,0))    iavg  
  from stats$waitstat b
     , stats$waitstat e
 where b.snap_id         = :bid
   and e.snap_id         = :eid
   and b.dbid            = :dbid
   and e.dbid            = :dbid
   and b.dbid            = e.dbid
   and b.instance_number = :inst_num
   and e.instance_number = :inst_num
   and b.instance_number = e.instance_number
   and b.class           = e.class
   and b.wait_count      < e.wait_count
 order by itim desc, icnt desc;


--
--  Enqueue activity

ttitle lef 'Enqueue activity for ' -
           'DB: ' db_name  '  Instance: ' inst_name '  '-
           'Snaps: ' format 999999 bid ' -' format 999999 eid -
            skip 2;

col gets  format 999,999,990  heading 'Gets';
col ename format a10          heading 'Enqueue'
col waits format 9,999,990    heading 'Waits'

select e.name                   ename
     , e.gets - nvl(b.gets,0)   gets
     , e.waits - nvl(b.waits,0) waits
  from stats$enqueuestat b
     , stats$enqueuestat e
 where b.snap_id(+)        = :bid
   and e.snap_id            = :eid
   and b.dbid(+)            = :dbid
   and e.dbid               = :dbid
   and b.dbid(+)            = e.dbid
   and b.instance_number(+) = :inst_num
   and e.instance_number    = :inst_num
   and b.instance_number(+) = e.instance_number
   and b.name (+)           = e.name
   and e.waits - nvl(b.waits,0) > 0
 order by waits desc, gets desc;


--
--  Rollback segment

ttitle lef 'Rollback Segment Stats for ' -
           'DB: ' db_name  '  Instance: ' inst_name '  '-
           'Snaps: ' format 999999 bid ' -' format 999999 eid -
       skip 1 -
       lef '->A high value for "Pct Waits" suggests more rollback segments may be required'-
       skip 2;

 
column usn      format 990	      heading 'RBS No' Just Cen;
column gets     format 9,999,990.9    heading 'Trans Table|Gets' Just Cen;
column waits    format 990.99         heading 'Pct|Waits';
column writes   format 99,999,999,990 heading 'Undo Bytes|Written' Just Cen;
column wraps    format 999,990        heading 'Wraps';
column shrinks  format 999,990        heading 'Shrinks';
column extends  format 999,990        heading 'Extends';
column rssize   format 99,999,999,990 heading 'Segment Size';
column active   format 99,999,990     heading 'Avg Active';
column optsize  format 99,999,999,990 heading 'Optimal Size';
column hwmsize  format 99,999,999,990 heading 'Maximum Size';

select b.usn
     , e.gets    - b.gets     gets
     , to_number(decode(e.gets ,b.gets, null,
       (e.waits  - b.waits) * 100/(e.gets - b.gets))) waits
     , e.writes  - b.writes   writes
     , e.wraps   - b.wraps    wraps
     , e.shrinks - b.shrinks  shrinks
     , e.extends - b.extends  extends
  from stats$rollstat b
     , stats$rollstat e
 where b.snap_id         = :bid
   and e.snap_id         = :eid
   and b.dbid            = :dbid
   and e.dbid            = :dbid
   and b.dbid            = e.dbid
   and b.instance_number = :inst_num
   and e.instance_number = :inst_num
   and b.instance_number = e.instance_number
   and e.usn             = b.usn
 order by e.usn;


ttitle lef 'Rollback Segment Storage for '-
           'DB: ' db_name  '  Instance: ' inst_name '  '-
           'Snaps: ' format 999999 bid ' -' format 999999 eid -
       skip 1 -
       lef '->The value of Optimal should be larger than Avg Active'-
       skip 2;

select b.usn                                                       
     , e.rssize
     , e.aveactive active
     , to_number(decode(e.optsize, -4096, null,e.optsize)) optsize
     , e.hwmsize
  from stats$rollstat b
     , stats$rollstat e
 where b.snap_id         = :bid
   and e.snap_id         = :eid
   and b.dbid            = :dbid
   and e.dbid            = :dbid
   and b.dbid            = e.dbid
   and b.instance_number = :inst_num
   and e.instance_number = :inst_num
   and b.instance_number = e.instance_number
   and e.usn             = b.usn
 order by e.usn;


--
--  Latches Activity

ttitle lef 'Latch Activity for '-
           'DB: ' db_name  '  Instance: ' inst_name '  '-
           'Snaps: ' format 999999 bid ' -' format 999999 eid -
       skip 1 -
       lef '->"Pct Misses" should be very close to 0.0'-
       skip 2;

column name    	format a31    	        heading 'Latch Name' trunc;
column gets   	format 999,999,990	heading 'Get|Requests';
column missed   format 990.9            heading 'Pct|Get|Miss';
column sleeps	format 990.9 	        heading 'Avg|Sleeps|/Miss';
column nowai	format 99,999,990	heading 'Nowait|Requests';
column imiss	format 990.9 	        heading 'Pct|Nowait|Miss';

select b.name                                            name
     , e.gets    - b.gets                                gets
     , to_number(decode(e.gets, b.gets, null,
       (e.misses - b.misses) * 100/(e.gets - b.gets)))   missed
     , to_number(decode(e.misses, b.misses, null,
       (e.sleeps - b.sleeps)/(e.misses - b.misses)))     sleeps
     , e.immediate_gets - b.immediate_gets               nowai
     , to_number(decode(e.immediate_gets,
			b.immediate_gets, null,
                        (e.immediate_misses - b.immediate_misses) * 100 /
	                (e.immediate_gets   - b.immediate_gets)))     imiss
 from  stats$latch b
     , stats$latch e
 where b.snap_id         = :bid
   and e.snap_id         = :eid
   and b.dbid            = :dbid
   and e.dbid            = :dbid
   and b.dbid            = e.dbid
   and b.instance_number = :inst_num
   and e.instance_number = :inst_num
   and b.instance_number = e.instance_number
   and b.name            = e.name
   and e.gets - b.gets   > 0
 order by name, sleeps;



--
--  Latch Sleep breakdown

ttitle lef 'Latch Sleep breakdown for ' -
           'DB: ' db_name  '  Instance: ' inst_name '  '-
           'Snaps: ' format 999999 bid ' -' format 999999 eid -
       skip 2;

column name    	 format a28    	        heading 'Latch Name' trunc;
column sleeps	 format 99,999,990 	heading 'Sleeps';
column spin_gets format 99,999,990 	heading 'Spin|Gets';
column misses    format 99,999,990 	heading 'Misses';
column sleep4 	 format a12 	        heading 'Spin &|Sleeps 1-4';

select b.name                                      name
     , e.gets      - b.gets                        gets
     , e.misses      - b.misses                    misses
     , e.sleeps      - b.sleeps                    sleeps
     , to_char(e.spin_gets          - b.spin_gets)
       ||'/'||to_char(e.sleep1      - b.sleep1) 
       ||'/'||to_char(e.sleep2      - b.sleep2)
       ||'/'||to_char(e.sleep3      - b.sleep3)
       ||'/'||to_char(e.sleep4      - b.sleep4)    sleep4
  from stats$latch b
     , stats$latch e
 where b.snap_id         = :bid
   and e.snap_id         = :eid
   and b.dbid            = :dbid
   and e.dbid            = :dbid
   and b.dbid            = e.dbid
   and b.instance_number = :inst_num
   and e.instance_number = :inst_num
   and b.instance_number = e.instance_number
   and b.name            = e.name
   and e.sleeps - b.sleeps > 0
 order by misses desc;


--
--  Latch Miss sources

ttitle lef 'Latch Miss Sources for ' -
           'DB: ' db_name  '  Instance: ' inst_name '  '-
           'Snaps: ' format 999999 bid ' -' format 999999 eid -
       skip 2;

column parent     format a30          heading 'Latch Name' trunc;
column where_from format a26          heading 'Where'      trunc;
column nwmisses   format 99,990       heading 'No Wait|Misses';

select e.parent_name                          parent
     , e.where_in_code                        where_from
     , e.nwfail_count - nvl(b.nwfail_count,0) nwmisses
     , e.sleep_count  - nvl(b.sleep_count,0)  sleeps
  from stats$latch_misses_summary b
     , stats$latch_misses_summary e
 where b.snap_id(+)         = :bid
   and e.snap_id            = :eid
   and b.dbid(+)            = :dbid
   and e.dbid               = :dbid
   and b.dbid(+)            = e.dbid
   and b.instance_number(+) = :inst_num
   and e.instance_number    = :inst_num
   and b.instance_number(+) = e.instance_number
   and b.parent_name(+)     = e.parent_name
   and b.where_in_code(+)   = e.where_in_code
   and e.sleep_count        > nvl(b.sleep_count,0)
 order by e.parent_name, sleeps desc;



--
--  Buffer pools

ttitle lef 'Buffer Pool Sets for ' -
           'DB: ' db_name  '  Instance: ' inst_name '  '-
           'Snaps: ' format 999999 bid ' -' format 999999 eid -
       skip 2;

col id      format 99         heading 'Set|Id';
col buffs   format 99,999,999 heading 'Buffer|Gets';
col conget  format 99,999,999 heading 'Consistent|Gets';
col phread  format 99,999,999 heading 'Physical|Reads';
col phwrite format 99,999,999 heading 'Physical|Writes';
col fbwait  format 999,999    heading 'Free|Buffer|Waits';
col bbwait  format 999,999    heading 'Buffer|Busy|Waits'
col wcwait  format 999,999    heading 'Write|Complete|Waits';

select e.id			                     id
     , e.buf_got             - b.buf_got	     buffs
     , e.consistent_gets     - b.consistent_gets     conget
     , e.physical_reads      - b.physical_reads	     phread
     , e.physical_writes     - b.physical_writes     phwrite
     , e.free_buffer_wait    - b.free_buffer_wait    fbwait
     , e.write_complete_wait - b.write_complete_wait wcwait
     , e.buffer_busy_wait    - b.buffer_busy_wait    bbwait
  from stats$buffer_pool_statistics b
     , stats$buffer_pool_statistics e
 where b.snap_id         = :bid
   and e.snap_id         = :eid
   and b.dbid            = :dbid
   and e.dbid            = :dbid
   and b.dbid            = e.dbid
   and b.instance_number = :inst_num
   and e.instance_number = :inst_num
   and b.instance_number = e.instance_number
   and b.id              = e.id
 order by e.id;



--
--  Dictionary Cache

ttitle lef 'Dictionary Cache Stats for ' -
           'DB: ' db_name  '  Instance: ' inst_name '  '-
           'Snaps: ' format 999999 bid ' -' format 999999 eid -
       skip 1 -
       lef '->"Pct Misses"  should be very low  (< 2% in most cases)'-
       skip 1 -
       lef '->"Cache Usage" is the number of cache entries being used'-
       skip 1 -
       lef '->"Pct SGA"     is the ratio of usage to allocated size for that cache'-
       skip 2;

column param	format a22 	heading 'Cache'  trunc;
column gets	format 99,999,990	heading 'Get|Requests';
column getm	format 990.9	heading 'Pct|Miss';
column scans	format 999,990	heading 'Scan|Requests';
column scanm	format 90.9	heading 'Pct|Miss';
column mods	format 999,990	heading 'Mod|Req';
column usage	format 9,990	heading 'Final|Usage';
column sgapct	format 990 	heading 'Pct|SGA';

select lower(b.parameter)                                        param
     , e.gets - b.gets                                           gets
     , to_number(decode(e.gets,b.gets,null,
       (e.getmisses - b.getmisses) * 100/(e.gets - b.gets)))     getm
     , e.scans - b.scans                                         scans
     , to_number(decode(e.scans,b.scans,null,
       (e.scanmisses - b.scanmisses) * 100/(e.scans - b.scans))) scanm
     , e.modifications - b.modifications                         mods
     , e.usage                                                   usage
     , e.usage * 100/e.total_usage                               sgapct
  from stats$rowcache_summary b
     , stats$rowcache_summary e
 where b.snap_id         = :bid
   and e.snap_id         = :eid
   and b.dbid            = :dbid
   and e.dbid            = :dbid
   and b.dbid            = e.dbid
   and b.instance_number = :inst_num
   and e.instance_number = :inst_num
   and b.instance_number = e.instance_number
   and b.parameter       = e.parameter
 order by param;



--
--  Library Cache

set newpage 2;
ttitle lef 'Library Cache Activity for '-
           'DB: ' db_name  '  Instance: ' inst_name '  '-
           'Snaps: ' format 999999 bid ' -' format 999999 eid -
       skip 1 -
           '->"Pct Misses"  should be very low  ' skip 2;

column namespace                heading 'Namespace';
column gets	format 99,999,990	heading 'Get|Requests';
column pins	format 99,999,990	heading 'Pin|Requests' just c;
column getm	format 990.9	heading 'Pct|Miss' just c;
column pinm	format 990.9	heading 'Pct|Miss' just c;
column reloads  format 99,999,990    heading 'Reloads';
column inv      format 999,990    heading 'Invali-|dations';

select b.namespace
     , e.gets - b.gets                                         gets  
     , to_number(decode(e.gets,b.gets,null,
       100 - (e.gethits - b.gethits) * 100/(e.gets - b.gets))) getm
     , e.pins - b.pins                                         pins  
     , to_number(decode(e.pins,b.pins,null,
       100 - (e.pinhits - b.pinhits) * 100/(e.pins - b.pins))) pinm
     , e.reloads - b.reloads                                   reloads
     , e.invalidations - b.invalidations                       inv
  from stats$librarycache b
     , stats$librarycache e
 where b.snap_id         = :bid   
   and e.snap_id         = :eid
   and b.dbid            = :dbid
   and e.dbid            = :dbid
   and b.dbid            = e.dbid
   and b.instance_number = :inst_num
   and e.instance_number = :inst_num
   and b.instance_number = e.instance_number
   and b.namespace       = e.namespace;



--
--  SGA

set newpage 0;
column name	format a30	  heading 'SGA regions';
column value	format 999,999,999,990 heading 'Size in Bytes';

break on report;
compute sum of value on report;
ttitle lef 'SGA Memory Summary for ' -
           'DB: ' db_name  '  Instance: ' inst_name '  '-
       skip 2;

select name
     , value
  from stats$sgaxs
 where dbid            = :dbid
   and instance_number = :inst_num
   and startup_time    = to_date(:instart, 'YYYYMMDD HH24:MI:SS')
 order by name;
clear break compute;

set newpage 2;
column name    format a30            heading 'SGA Component';
column b_value format 99,999,999,990 heading 'Start snap';
column e_value format 99,999,999,990 heading 'End snap';
column change  format 99,999,990     heading 'Change |End - Start' just cen;

ttitle lef 'SGA breakdown difference for '-
           'DB: ' db_name  '  Instance: ' inst_name '  '-
           'Snaps: ' format 999999 bid ' -' format 999999 eid -
       skip 2;

column name heading "Name" format a35;
column snap1 format 999,999,999 heading 'Begin value';
column snap2 format 999,999,999 heading 'End value';
column diff  format 999,999,999 heading 'Difference';

select b.name            name
     , b.bytes           snap1
     , e.bytes           snap2
     , e.bytes - b.bytes diff
  from stats$sgastat_summary b
     , stats$sgastat_summary e
 where e.snap_id         = :eid
   and b.snap_id         = :bid
   and b.dbid            = :dbid
   and e.dbid            = :dbid
   and b.dbid            = e.dbid
   and b.instance_number = :inst_num
   and e.instance_number = :inst_num
   and b.instance_number = e.instance_number
   and b.name            = e.name
 order by b.name;



--
--  Initialization Parameters

set newpage 0;
column name     format a29      heading 'Parameter Name'         trunc;
column bval     format a33      heading 'Begin value'            trunc;
column eval     format a14      heading 'End value|(if different)' trunc just c;
 
ttitle lef 'init.ora Parameters for '-
           'DB: ' db_name  '  Instance: ' inst_name '  '-
           'Snaps: ' format 999999 bid ' -' format 999999 eid -
       skip 2;

select b.name
     , b.value                                bval
     , decode(b.value, e.value, ' ', e.value) eval
  from stats$parameter b
     , stats$parameter e
 where b.snap_id           = :bid
   and e.snap_id           = :eid
   and b.dbid              = :dbid
   and e.dbid              = :dbid
   and b.dbid              = e.dbid
   and b.instance_number   = :inst_num
   and e.instance_number   = :inst_num
   and b.instance_number   = e.instance_number
   and b.name              = e.name
   and (   b.isdefault     = 'FALSE'
        or b.ismodified   != 'FALSE'
        or e.ismodified   != 'FALSE'
        or nvl(e.value,0) != nvl(b.value,0));

prompt
prompt                                 End of Report 
prompt
spool off;
set termout off;
clear columns sql;
ttitle off;
btitle off;
repfooter off;
set linesize 78 termout on feedback 6;

--
--  End of script file;
