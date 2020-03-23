Rem
Rem $Header: statspack.sql 01-nov-99.14:11:07 cdialeri Exp $
Rem
Rem statspack.sql
Rem
Rem  Copyright (c) Oracle Corporation 1999. All Rights Reserved.
Rem
Rem    NAME
Rem      statspack.sql
Rem
Rem    DESCRIPTION
Rem      SQL*PLUS command file to create statistics package
Rem
Rem    NOTES
Rem      Must be run as the STATSPACK owner, PERFSTAT
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    cdialeri    11/01/99 - Enhance, 1059172
Rem    cgervasi    06/16/98 - Remove references to wrqs
Rem    cmlim       07/30/97 - Modified system events
Rem    gwood.uk    02/30/94 - Modified
Rem    densor.uk   03/31/93 - Modified
Rem    cellis.uk   11/15/89 - Created
Rem

set echo off;
whenever sqlerror exit;

spool statspack.lis

/* ---------------------------------------------------------------------- */

prompt Creating Package STATSPACK...
 
create or replace package STATSPACK as
 
   procedure STAT_CHANGES
      ( bid               IN     number
      , eid               IN     number
      , lhtr OUT number, bfwt  OUT number,   tran OUT number,   chng OUT number
      , ucal OUT number, urol  OUT number,   rsiz OUT number,   phyr OUT number
      , phyw OUT number
      , prse OUT number, hprse OUT number,   recr OUT number,   gets OUT number
      , rlsr OUT number, rent  OUT number,   srtm OUT number,   srtd OUT number
      , srtr OUT number, strn  OUT number, lhr  OUT number
      , bc   OUT varchar2, sp  OUT varchar2
      , lb   OUT varchar2, bs  OUT varchar2, twt OUT number
      );
 
   procedure SNAP
      (i_snap_level          in number   default null
      ,i_session_id          in number   default null
      ,i_ucomment            in varchar2 default null
      ,i_num_sql             in number   default null
      ,i_executions_th       in number   default null
      ,i_parse_calls_th      in number   default null
      ,i_disk_reads_th       in number   default null
      ,i_buffer_gets_th      in number   default null
      ,i_pin_statspack       in varchar2 default null
      ,i_modify_parameter    in varchar2 default 'FALSE'
      );

   function SLARTI
      (i_snap_level          in number   default null
      ,i_session_id          in number   default null
      ,i_ucomment            in varchar2 default null
      ,i_num_sql             in number   default null
      ,i_executions_th       in number   default null
      ,i_parse_calls_th      in number   default null
      ,i_disk_reads_th       in number   default null
      ,i_buffer_gets_th      in number   default null
      ,i_pin_statspack       in varchar2 default null
      ,i_modify_parameter    in varchar2 default 'FALSE'
      )
      RETURN integer;

   procedure MODIFY_STATSPACK_PARAMETER
      ( i_dbid                in  number   default null
      , i_instance_number     in  number   default null
      , i_snap_level          in  number   default null
      , i_session_id          in  number   default null
      , i_ucomment            in  varchar2 default null
      , i_num_sql             in  number   default null
      , i_executions_th       in  number   default null
      , i_parse_calls_th      in  number   default null
      , i_disk_reads_th       in  number   default null
      , i_buffer_gets_th      in  number   default null
      , i_pin_statspack       in  varchar2 default null
      , i_modify_parameter    in  varchar2 default 'TRUE'
      );

   procedure QAM_STATSPACK_PARAMETER
      ( i_dbid                in  number   default null
      , i_instance_number     in  number   default null
      , i_snap_level          in  number   default null
      , i_session_id          in  number   default null
      , i_ucomment            in  varchar2 default null
      , i_num_sql             in  number   default null
      , i_executions_th       in  number   default null
      , i_parse_calls_th      in  number   default null
      , i_disk_reads_th       in  number   default null
      , i_buffer_gets_th      in  number   default null
      , i_pin_statspack       in  varchar2 default null
      , i_modify_parameter    in  varchar2
      , o_snap_level          out number
      , o_session_id          out number
      , o_ucomment            out varchar2
      , o_num_sql             out number
      , o_executions_th       out number
      , o_parse_calls_th      out number
      , o_disk_reads_th       out number
      , o_buffer_gets_th      out number
      , o_pin_statspack       out varchar2
      );
 
end STATSPACK;
/
show errors

/* ---------------------------------------------------------------------- */

prompt Creating Package Body STATSPACK...

create or replace package body STATSPACK as

  /*  Define package variables.
      Variables prefixed with p_ are package variables.
  */
   p_snap_id               integer;                 /* snapshot id           */
   p_instance_number       number;                  /* instance number       */
   p_instance_name         varchar2(16);            /* instance name         */
   p_startup_time          date;                    /* instance startup time */
   p_parallel              varchar2(3);             /* parallel server       */
   p_version               varchar2(17);            /* Oracle release        */
   p_dbid                  number;                  /* database id           */
   p_host_name             varchar2(64);            /* host instance is on   */
   p_name                  varchar2(9);             /* database name         */
   p_new_sga               integer;     /* Instance bounced since last snap? */
   tmp_int                 integer;                 /* initialise defaults   */
   p_def_snap_level        number    default 5;     /* default snapshot lvl  */
   p_def_session_id        number    default 0;     /* default session id    */
   p_def_ucomment          varchar2(160) default null;
   p_def_pin_statspack     varchar2(10)  default 'TRUE';
   p_def_last_modified     date          default SYSDATE;
   /* Below are the default threshold (_th) values for choosing SQL statements
      to store in the stats$sqlsummary table - these statements will typically 
      be the statements using the most resources.
   */
   p_def_num_sql           number default 50;        /* Num. SQL statements  */
   p_def_executions_th     number default 100;       /* Num. executions      */
   p_def_parse_calls_th    number default 1000;      /* Num. parse calls     */
   p_def_disk_reads_th     number default 1000;      /* Num. disk reads      */
   p_def_buffer_gets_th    number default 10000;     /* Num. buf gets        */

   cursor get_instance is
   select instance_number, instance_name
        , startup_time, parallel, version
        , host_name
     from v$instance;

   cursor get_db is
   select dbid, name
     from v$database;

   /* ------------------------------------------------------------------- */

   procedure SNAP
      (i_snap_level          in number   default null
      ,i_session_id          in number   default null
      ,i_ucomment            in varchar2 default null
      ,i_num_sql             in number   default null
      ,i_executions_th       in number   default null
      ,i_parse_calls_th      in number   default null
      ,i_disk_reads_th       in number   default null
      ,i_buffer_gets_th      in number   default null
      ,i_pin_statspack       in varchar2 default null
      ,i_modify_parameter    in varchar2 default 'FALSE'
      )
   is 

   /*  Takes a snapshot and discards the snapshot id.  This is useful
       when automating taking snapshots from dbms_job
   */   

   l_snap_id number;

   begin
     l_snap_id := statspack.slarti( i_snap_level, i_session_id, i_ucomment 
                                  , i_num_sql
                                  , i_executions_th 
                                  , i_parse_calls_th
                                  , i_disk_reads_th
                                  , i_buffer_gets_th
                                  , i_pin_statspack 
                                  , i_modify_parameter);
   end SNAP;


   /* ------------------------------------------------------------------- */

   procedure MODIFY_STATSPACK_PARAMETER
      ( i_dbid                in  number   default null
      , i_instance_number     in  number   default null
      , i_snap_level          in  number   default null
      , i_session_id          in  number   default null
      , i_ucomment            in  varchar2 default null
      , i_num_sql             in  number   default null
      , i_executions_th       in  number   default null
      , i_parse_calls_th      in  number   default null
      , i_disk_reads_th       in  number   default null
      , i_buffer_gets_th      in  number   default null
      , i_pin_statspack       in  varchar2 default null
      , i_modify_parameter    in  varchar2 default 'TRUE'
      )
      is
      /*  Calls QAM with the modify flag, and discards the
          output variables
      */
      l_snap_level                 number;
      l_session_id                 number;
      l_ucomment                   varchar2(160);
      l_num_sql                    number;
      l_executions_th              number;
      l_parse_calls_th             number;
      l_disk_reads_th              number;
      l_buffer_gets_th             number;
      l_pin_statspack              varchar2(10);

    begin

      statspack.qam_statspack_parameter( i_dbid
                                       , i_instance_number
                                       , i_snap_level
                                       , i_session_id
                                       , i_ucomment
                                       , i_num_sql
                                       , i_executions_th
                                       , i_parse_calls_th
                                       , i_disk_reads_th
                                       , i_buffer_gets_th
                                       , i_pin_statspack
                                       , 'TRUE'
                                       , l_snap_level
                                       , l_session_id
                                       , l_ucomment
                                       , l_num_sql
                                       , l_executions_th
                                       , l_parse_calls_th
                                       , l_disk_reads_th
                                       , l_buffer_gets_th
                                       , l_pin_statspack);

      /*  As we have explicity been requested to change the parameters, 
          independently of taking a snapshot, commit
      */
      commit;

   end MODIFY_STATSPACK_PARAMETER;

   /* ------------------------------------------------------------------- */

   procedure QAM_STATSPACK_PARAMETER
      ( i_dbid                in  number   default null
      , i_instance_number     in  number   default null
      , i_snap_level          in  number   default null
      , i_session_id          in  number   default null
      , i_ucomment            in  varchar2 default null
      , i_num_sql             in  number   default null
      , i_executions_th       in  number   default null
      , i_parse_calls_th      in  number   default null
      , i_disk_reads_th       in  number   default null
      , i_buffer_gets_th      in  number   default null
      , i_pin_statspack       in  varchar2 default null
      , i_modify_parameter    in  varchar2 default 'TRUE'
      , o_snap_level          out number
      , o_session_id          out number
      , o_ucomment            out varchar2
      , o_num_sql             out number
      , o_executions_th       out number
      , o_parse_calls_th      out number
      , o_disk_reads_th       out number
      , o_buffer_gets_th      out number
      , o_pin_statspack       out varchar2
      )
     is
   /* Query And Modify statspack parameter procedure, allows query 
      and/or user modification of the statistics collection parameters 
      for an instance.  If there are no pre-existing parameters for 
      an instance, insert the Oracle defaults.
   */

     l_instance_number number;
     l_dbid            number;

     begin
       if ((i_dbid is null ) or (i_instance_number is null)) then
         l_dbid            := p_dbid;
         l_instance_number := p_instance_number;
       else
         l_dbid            := i_dbid;
         l_instance_number := i_instance_number;
       end if;

       if (   (i_modify_parameter is null)
           or (upper(i_modify_parameter) = 'FALSE')  ) then
       /* Query values, if none exist, insert the defaults tempered 
          with variables supplied */

         begin
           select nvl(i_session_id,     session_id)
                , nvl(i_snap_level,     snap_level)
                , nvl(i_ucomment,       ucomment)
                , nvl(i_num_sql,        num_sql)
                , nvl(i_executions_th,  executions_th)
                , nvl(i_parse_calls_th, parse_calls_th)
                , nvl(i_disk_reads_th,  disk_reads_th)
                , nvl(i_buffer_gets_th, buffer_gets_th)
                , nvl(i_pin_statspack,  pin_statspack)   
             into o_session_id
                , o_snap_level
                , o_ucomment
                , o_num_sql
                , o_executions_th
                , o_parse_calls_th
                , o_disk_reads_th
                , o_buffer_gets_th
                , o_pin_statspack
             from stats$statspack_parameter
            where instance_number = l_instance_number
              and dbid            = l_dbid;
         exception
           when NO_DATA_FOUND then
             insert into stats$statspack_parameter
                  ( dbid
                  , instance_number
                  , session_id
                  , snap_level
                  , ucomment
                  , num_sql
                  , executions_th
                  , parse_calls_th
                  , disk_reads_th
                  , buffer_gets_th
                  , pin_statspack
                  , last_modified
                  )
             values 
                  ( l_dbid
                  , l_instance_number
                  , nvl(i_session_id,     p_def_session_id)
                  , nvl(i_snap_level,     p_def_snap_level)
                  , nvl(i_ucomment,       p_def_ucomment)
                  , nvl(i_num_sql,        p_def_num_sql)
                  , nvl(i_executions_th,  p_def_executions_th)
                  , nvl(i_parse_calls_th, p_def_parse_calls_th)
                  , nvl(i_disk_reads_th,  p_def_disk_reads_th)
                  , nvl(i_buffer_gets_th, p_def_buffer_gets_th)
                  , nvl(i_pin_statspack,  p_def_pin_statspack)
                  , SYSDATE
                  )
          returning session_id
                  , snap_level
                  , ucomment
                  , num_sql
                  , executions_th
                  , parse_calls_th
                  , disk_reads_th
                  , buffer_gets_th
                  , pin_statspack
               into o_session_id
                  , o_snap_level
                  , o_ucomment
                  , o_num_sql
                  , o_executions_th
                  , o_parse_calls_th
                  , o_disk_reads_th
                  , o_buffer_gets_th
                  , o_pin_statspack;
           end; 

       elsif upper(i_modify_parameter) = 'TRUE' then
       /* modify values, if none exist, insert the defaults tempered 
          with the variables supplied */

         begin
           update stats$statspack_parameter
              set session_id      = nvl(i_session_id,     session_id)
                , snap_level      = nvl(i_snap_level,     snap_level)
                , ucomment        = nvl(i_ucomment,       ucomment)
                , num_sql         = nvl(i_num_sql,        num_sql)
                , executions_th   = nvl(i_executions_th,  executions_th)
                , parse_calls_th  = nvl(i_parse_calls_th, parse_calls_th)
                , disk_reads_th   = nvl(i_disk_reads_th,  disk_reads_th)
                , buffer_gets_th  = nvl(i_buffer_gets_th, buffer_gets_th)
                , pin_statspack   = nvl(i_pin_statspack,  pin_statspack)   
            where instance_number = l_instance_number
              and dbid            = l_dbid
        returning session_id
                , snap_level
                , ucomment
                , num_sql
                , executions_th
                , parse_calls_th
                , disk_reads_th
                , buffer_gets_th
                , pin_statspack
             into o_session_id
                , o_snap_level
                , o_ucomment
                , o_num_sql
                , o_executions_th
                , o_parse_calls_th
                , o_disk_reads_th
                , o_buffer_gets_th
                , o_pin_statspack;
          exception
            when NO_DATA_FOUND then 
               insert into stats$statspack_parameter
                    ( dbid
                    , instance_number
                    , session_id
                    , snap_level
                    , ucomment
                    , num_sql
                    , executions_th
                    , parse_calls_th
                    , disk_reads_th
                    , buffer_gets_th
                    , pin_statspack
                    , last_modified
                    )
              values 
                    ( l_dbid
                    , l_instance_number
                    , nvl(i_session_id, p_def_session_id)
                    , nvl(i_snap_level, p_def_snap_level)
                    , nvl(i_ucomment,   p_def_ucomment)
                    , nvl(i_num_sql,    p_def_num_sql)
                    , nvl(i_executions_th, p_def_num_sql)
                    , nvl(i_parse_calls_th, p_def_parse_calls_th)
                    , nvl(i_disk_reads_th,  p_def_disk_reads_th)
                    , nvl(i_buffer_gets_th, p_def_buffer_gets_th)
                    , nvl(i_pin_statspack,  p_def_pin_statspack)
                    , SYSDATE
                    )
            returning session_id
                    , snap_level
                    , ucomment
                    , num_sql
                    , executions_th
                    , parse_calls_th
                    , disk_reads_th
                    , buffer_gets_th
                    , pin_statspack
                 into o_session_id
                    , o_snap_level
                    , o_ucomment
                    , o_num_sql
                    , o_executions_th
                    , o_parse_calls_th
                    , o_disk_reads_th
                    , o_buffer_gets_th
                    , o_pin_statspack;
         end; /* update */
       else
       /* error */
          raise_application_error
            (-20100,'QAM_STATSPACK_PARAMETER i_modify_parameter value is invalid');
       end if; /* modify */

     end QAM_STATSPACK_PARAMETER;

   /* ------------------------------------------------------------------- */

   procedure STAT_CHANGES
   /* Returns a set of differences of the values from corresponding pairs
      of rows in STATS$SYSSTAT, STATS$LIBRARYCACHE and STATS$WAITSTAT,
      based on the begin and end (bid, eid) snapshot id's specified.
      This procedure is the only call to STATSPACK made by the statsrep 
      report.
   */
      ( bid               IN     number
      , eid               IN     number
      , lhtr OUT number, bfwt  OUT number, tran OUT number, chng OUT number
      , ucal OUT number, urol  OUT number, rsiz OUT number, phyr OUT number
      , phyw OUT number
      , prse OUT number, hprse OUT number, recr OUT number, gets OUT number
      , rlsr OUT number, rent  OUT number, srtm OUT number, srtd OUT number
      , srtr OUT number, strn  OUT number, lhr  OUT number
      , bc   OUT varchar2, sp  OUT varchar2
      , lb   OUT varchar2, bs  OUT varchar2, twt OUT number
      ) is

      bval           number;   
      eval           number;
      l_b_session_id number;                         /* begin session id */
      l_b_serial#    number;                         /* begin serial# */
      l_e_session_id number;                         /* end session id */
      l_e_serial#    number;                         /* end serial# */

      /* ---------------------------------------------------------------- */

      function LIBRARYCACHE_HITRATIO RETURN number is

      /* Returns Library cache hit ratio for the begin and end (bid, eid) 
         snapshot id's specified
      */

         cursor LH (i_snap_id number) is
            select sum(pins), sum(pinhits)
              from stats$librarycache
             where snap_id         = i_snap_id
               and dbid            = p_dbid
               and instance_number = p_instance_number;

         bpsum number;  
         bhsum number;    
         epsum number;
         ehsum number;

      begin

         if not LH%ISOPEN then open LH (bid); end if;
         fetch LH into bpsum, bhsum;
         if LH%NOTFOUND then
            raise_application_error
			(-20100,'Missing start value for stats$librarycache');
         end if; close LH;

         if not LH%ISOPEN then open LH (eid); end if;
         fetch LH into epsum, ehsum;
         if LH%NOTFOUND then
            raise_application_error
			(-20100,'Missing end value for stats$librarycache');

         end if; close LH;

         return (ehsum - bhsum) / (epsum - bpsum);

      end LIBRARYCACHE_HITRATIO;
         
         
      /* ---------------------------------------------------------------- */

      function GET_PARAM  (i_name varchar2) RETURN varchar2 is

      /* Returns the value for the init.ora parameter for the snapshot
         specified.
      */

         cursor PARAMETER is
            select value
              from stats$parameter
             where snap_id         = bid
               and dbid            = p_dbid
               and instance_number = p_instance_number
               and name            = i_name;

         par_value varchar2(512);

      begin

         if not PARAMETER%ISOPEN then open PARAMETER; end if;
         fetch PARAMETER into par_value;
         if PARAMETER%NOTFOUND then
            raise_application_error
			(-20100,'Missing Init.ora parameter '|| i_name);
         end if; close PARAMETER;

         return par_value;

      end GET_PARAM;

      /* ---------------------------------------------------------------- */

      function BUFFER_WAITS RETURN number is

      /* Returns the total number of waits for all buffers in the interval
         specified by the begin and end snapshot id's (bid, eid)
      */

         cursor BW (i_snap_id number) is
            select sum(wait_count)
              from stats$waitstat
             where snap_id         = i_snap_id
               and dbid            = p_dbid
               and instance_number = p_instance_number;

         bbwsum number;  ebwsum number;

      begin

         if not BW%ISOPEN then open BW (bid); end if;
         fetch BW into bbwsum;
         if BW%NOTFOUND then
            raise_application_error
			(-20100,'Missing start value for stats$waitstat');
         end if; close BW;

         if not BW%ISOPEN then open BW (eid); end if;
         fetch BW into ebwsum;
         if BW%NOTFOUND then
            raise_application_error
			(-20100,'Missing end value for stats$waitstat');
         end if; close BW;

         return ebwsum - bbwsum;

      end BUFFER_WAITS;

      /* ---------------------------------------------------------------- */

      function TOTAL_EVENT_TIME RETURN number is

      /* Returns the total amount of time waited for events for
         the interval specified by the begin and end snapshot id's 
         (bid, eid) by foreground processes.  This excludes idle
         wait events.
      */

         cursor WAITS (i_snap_id number) is
            select sum(time_waited)
              from stats$system_event
             where snap_id         = i_snap_id
               and dbid            = p_dbid
               and instance_number = p_instance_number
               and event not in (select event from stats$idle_event);

         bwaittime number;
         ewaittime number;

      begin

         if not WAITS%ISOPEN then open WAITS (bid); end if;
         fetch WAITS into bwaittime;
         if WAITS%NOTFOUND then
            raise_application_error
			(-20100,'Missing start value for stats$system_event');
         end if; close WAITS;

         if not WAITS%ISOPEN then open WAITS (eid); end if;
         fetch WAITS into ewaittime;
         if WAITS%NOTFOUND then
            raise_application_error
			(-20100,'Missing end value for stats$system_event');
         end if; close WAITS;

         return ewaittime - bwaittime;

      end TOTAL_EVENT_TIME;

      /* ---------------------------------------------------------------- */

      function LATCH_HITRATIO return NUMBER is

      /* Returns the latch hit ratio specified by the begin and 
         end snapshot id's (bid, eid)
      */

         cursor GETS_MISSES (i_snap_id number) is
            select sum(gets), sum(misses)
              from stats$latch
             where snap_id         = i_snap_id
               and dbid            = p_dbid
               and instance_number = p_instance_number;

         blget number;	-- beginning latch gets
         blmis number;	-- beginning latch misses
         elget number;	-- end latch gets
         elmis number;	-- end latch misses

      begin

         if not GETS_MISSES%ISOPEN then open GETS_MISSES (bid); end if;
         fetch GETS_MISSES into blget, blmis;
         if GETS_MISSES%NOTFOUND then
            raise_application_error
                (-20100,'Missing start value for STATS$LATCH gets and misses');
         end if; close GETS_MISSES;

         if not GETS_MISSES%ISOPEN then open GETS_MISSES (eid); end if;
         fetch GETS_MISSES into elget, elmis;
         if GETS_MISSES%NOTFOUND then
            raise_application_error
                (-20100,'Missing end value for STATS$LATCH gets and misses');
         end if; close GETS_MISSES;

         return ( ( elmis - blmis ) / ( elget - blget ) );

      end LATCH_HITRATIO;

      /* ---------------------------------------------------------------- */

      function SYSDIF (i_name varchar2) RETURN number is

      /* Returns the difference between statistics for the statistic
         name specified for the interval between the begin and end 
         snapshot id's (bid, eid)
      */

      cursor SY (i_snap_id number) is
      select value 
        from stats$sysstat
       where snap_id         = i_snap_id
         and dbid            = p_dbid
         and instance_number = p_instance_number
         and name            = i_name;

      begin
         /* Get start value */
         open SY (bid); fetch SY into bval;
         if SY%notfound then
            raise_application_error
			(-20100,'Missing start value for statistic: '||i_name);
         end if; close SY;

         /* Get end value */
         open SY (eid); fetch SY into eval;
         if SY%notfound then
            raise_application_error
			(-20100,'Missing end value for statistic: '||i_name);
         end if; close SY;

         /* Return difference */
         return eval - bval;
      end SYSDIF;

      /* ---------------------------------------------------------------- */

      function SESDIF (st_name varchar2) RETURN number is

      /* Returns the difference between statistics values for the 
         statistic name specified for the interval between the begin and end 
         snapshot id's (bid, eid), for the session monitored for that
         snapshot
      */

      cursor SE (i_snap_id number) is
         select ses.value 
	   from stats$sysstat sys
              , stats$sesstat ses
          where sys.snap_id     = i_snap_id
            and ses.snap_id     = i_snap_id
            and ses.dbid        = p_dbid
            and sys.dbid        = p_dbid
            and ses.instance_number = p_instance_number
            and sys.instance_number = p_instance_number
            and ses.statistic#  = sys.statistic#
            and sys.name        = st_name;

      begin
         /* Get start value */
         open SE (bid); fetch SE into bval;
         if SE%notfound then
	   eval :=0;
         end if; close SE;
 
         /* Get end value */
         open SE (eid); fetch SE into eval;
         if SE%notfound then
	   eval :=0;
         end if; close SE;
 
         /* Return difference */
         return eval - bval;
      end SESDIF;
 

   begin     /* main procedure body of STAT_CHANGES */

      lhtr := LIBRARYCACHE_HITRATIO;
      bfwt := BUFFER_WAITS;
      lhr  := LATCH_HITRATIO;
      chng := SYSDIF('db block changes');
      ucal := SYSDIF('user calls');
      urol := SYSDIF('user rollbacks');
      tran := SYSDIF('user commits') + urol;
      rsiz := SYSDIF('redo size');
      phyr := SYSDIF('physical reads');
      phyw := SYSDIF('physical writes');
      hprse := SYSDIF('parse count (hard)');
      prse := SYSDIF('parse count (total)');
      gets := SYSDIF('session logical reads');
      recr := SYSDIF('recursive calls');
      rlsr := SYSDIF('redo log space requests');
      rent := SYSDIF('redo entries');
      srtm := SYSDIF('sorts (memory)');
      srtd := SYSDIF('sorts (disk)');
      srtr := SYSDIF('sorts (rows)');
      bc   := GET_PARAM('db_block_buffers');
      sp   := GET_PARAM('shared_pool_size');
      lb   := GET_PARAM('log_buffer');
      bs   := GET_PARAM('db_block_size');
      twt  := TOTAL_EVENT_TIME;     -- total wait time for all non-idle events


      /*  Determine if we want to report on session-specific statistics.
          Check that the session is the same one for both snapshots.
      */
      select session_id
           , serial#
        into l_b_session_id
           , l_b_serial#
        from stats$snapshot
       where snap_id         = bid
         and dbid            = p_dbid
         and instance_number = p_instance_number;

      select session_id
           , serial#
        into l_e_session_id
           , l_e_serial#
        from stats$snapshot
       where snap_id         = eid
         and dbid            = p_dbid
         and instance_number = p_instance_number;

      if (    (l_b_session_id = l_e_session_id)
          and (l_b_serial#    = l_e_serial#)
          and (l_b_session_id != 0)              ) then
	 /*  we have a valid comparison - it is the
             same session - get number of tx performed 
             by this session */
         strn := SESDIF('user rollbacks') + SESDIF('user commits');
         if strn = 0 then
            /*  No new transactions */
            strn :=  1; 
         end if;
      else
         /*  No valid comparison can be made */
         strn :=1;          
      end if;

   end STAT_CHANGES;

   /* ------------------------------------------------------------------- */

   function SLARTI
      (i_snap_level               in number   default null
      ,i_session_id               in number   default null
      ,i_ucomment                 in varchar2 default null
      ,i_num_sql                  in number   default null
      ,i_executions_th            in number   default null
      ,i_parse_calls_th           in number   default null
      ,i_disk_reads_th            in number   default null
      ,i_buffer_gets_th           in number   default null
      ,i_pin_statspack            in varchar2 default null
      ,i_modify_parameter         in varchar2 default 'FALSE'
      )
     RETURN integer IS

   /*  SLARTI - Snapshot Load And Return The Id
       This function performs a snapshot of the v$ views into the
       stats$ tables, and returns the snapshot id.
       If parameters are passed, these are the values used, otherwise
       the values stored in the stats$statspack_parameter table are used.
   */

   l_snap_id                    integer;
   l_snap_level                 number;
   l_session_id                 number;
   l_serial#                    number;
   l_ucomment                   varchar2(160);
   l_num_sql                    number;
   l_executions_th              number;
   l_parse_calls_th             number;
   l_disk_reads_th              number;
   l_buffer_gets_th             number;
   l_pin_statspack              varchar2(10);
   l_sql_stmt                   varchar2(3000);
   l_slarti                     varchar2(20);
   l_threshold                  number;

   cursor GETSERIAL is
      select serial#
        from v$session
       where sid = l_session_id;


   begin /* Function SLARTI */

     /*  Get instance parameter defaults from stats$statspack_parameter,
         or use supplied parameters.
         If all parameters are specified, use them, otherwise get values
         from the parameters not specified from stats$statspack_parameter.
     */

     statspack.qam_statspack_parameter
       ( p_dbid
       , p_instance_number
       , i_snap_level, i_session_id, i_ucomment, i_num_sql
       , i_executions_th, i_parse_calls_th
       , i_disk_reads_th, i_buffer_gets_th
       , i_pin_statspack
       , i_modify_parameter
       , l_snap_level, l_session_id, l_ucomment, l_num_sql
       , l_executions_th, l_parse_calls_th
       , l_disk_reads_th, l_buffer_gets_th
       , l_pin_statspack);

     /*  Generate a snapshot id */
     select stats$snapshot_id.nextval
       into l_snap_id
       from dual
      where rownum = 1;

     /*  Determine the serial# of the session to maintain stats for,
         if this was requested.
     */
     if l_session_id > 0 then
         if not GETSERIAL%ISOPEN then open GETSERIAL; end if;
         fetch GETSERIAL into l_serial#;
         if GETSERIAL%NOTFOUND then
             /*  Session has already disappeared - don't gather 
                statistics for this session in this snapshot */
             l_session_id := 0;
             l_serial#    := 0;
         end if; close GETSERIAL;
     else
       l_serial# := 0;
     end if;
 
     /*  Save the snapshot characteristics */
     insert into stats$snapshot
          ( snap_id, dbid, instance_number
          , snap_time, startup_time
	  , session_id, snap_level, ucomment
          , executions_th, parse_calls_th, disk_reads_th
          , buffer_gets_th, serial#)
     values
          ( l_snap_id, p_dbid, p_instance_number
          , SYSDATE, p_startup_time 
	  , l_session_id, l_snap_level, l_ucomment
          , l_executions_th, l_parse_calls_th, l_disk_reads_th
          , l_buffer_gets_th, l_serial#);


     /*  Begin gathering statistics */
   
     insert into stats$filestatxs
          ( snap_id
          , dbid
          , instance_number
          , tsname
          , filename
          , phyrds
          , phywrts
          , readtim
          , writetim
          , phyblkrd
          , phyblkwrt
	  , wait_count
	  , time
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , tsname
          , filename
          , phyrds
          , phywrts
          , readtim
          , writetim
          , phyblkrd
          , phyblkwrt
	  , wait_count
	  , time
       from v$filestatxs;
   
     insert into stats$librarycache
          ( snap_id
          , dbid
          , instance_number
          , namespace
          , gets
          , gethits
          , pins
          , pinhits
          , reloads
          , invalidations
          , dlm_lock_requests
          , dlm_pin_requests
          , dlm_pin_releases
          , dlm_invalidation_requests
          , dlm_invalidations
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , namespace
          , gets
          , gethits
          , pins
          , pinhits
          , reloads
          , invalidations
          , dlm_lock_requests
          , dlm_pin_requests
          , dlm_pin_releases
          , dlm_invalidation_requests
          , dlm_invalidations
       from v$librarycache;
   
     insert into stats$buffer_pool_statistics
          ( snap_id
          , dbid
          , instance_number
          , id
          , name
          , set_msize
          , cnum_repl
          , cnum_write
          , cnum_set
          , buf_got
          , sum_write
          , sum_scan
          , free_buffer_wait
          , write_complete_wait
          , buffer_busy_wait
          , free_buffer_inspected
          , dirty_buffers_inspected
          , db_block_change
          , db_block_gets
          , consistent_gets
          , physical_reads
          , physical_writes
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
	  , id
	  , name
	  , set_msize
	  , cnum_repl
	  , cnum_write
	  , cnum_set
	  , buf_got
	  , sum_write
	  , sum_scan
	  , free_buffer_wait
	  , write_complete_wait
	  , buffer_busy_wait
	  , free_buffer_inspected
	  , dirty_buffers_inspected
	  , db_block_change
	  , db_block_gets
	  , consistent_gets
	  , physical_reads
	  , physical_writes
       from v$buffer_pool_statistics;
  
     insert into stats$rollstat
          ( snap_id
          , dbid
          , instance_number
          , usn
          , extents
          , rssize
          , writes
          , xacts
          , gets
          , waits
          , optsize
          , hwmsize
          , shrinks
          , wraps
          , extends
          , aveshrink
          , aveactive
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , usn
          , extents
          , rssize
          , writes
          , xacts
          , gets
          , waits
          , optsize
          , hwmsize
          , shrinks
          , wraps
          , extends
          , aveshrink
          , aveactive
       from v$rollstat;
   
     insert into stats$rowcache_summary
          ( snap_id
          , dbid
          , instance_number
          , parameter
          , total_usage
          , usage
          , gets
          , getmisses
          , scans
          , scanmisses
          , scancompletes
          , modifications
          , flushes
          , dlm_requests
          , dlm_conflicts
          , dlm_releases
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , parameter
          , sum("COUNT")
          , sum(usage)
          , sum(gets)
          , sum(getmisses)
          , sum(scans)
          , sum(scanmisses)
          , sum(scancompletes)
          , sum(modifications)
          , sum(flushes)
          , sum(dlm_requests)
          , sum(dlm_conflicts)
          , sum(dlm_releases)
       from v$rowcache
      group by l_snap_id, p_dbid, p_instance_number, parameter;

     /*  Collect parameters every snapshot, to cater for dynamic
         parameters changable while instance is running
     */
     insert into stats$parameter
          ( snap_id
          , dbid
          , instance_number
          , name
          , value
          , isdefault
          , ismodified
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , i.ksppinm
	  , sv.ksppstvl
          , sv.ksppstdf
          , decode(bitand(sv.ksppstvf,7),1,'MODIFIED',4,'SYSTEM_MOD','FALSE')
       from x$ksppi  i
          , x$ksppsv sv
      where i.indx = sv.indx;

     /*  Get current allocation of memory in the SGA  */
     insert into stats$sgastat_summary
          ( snap_id
          , dbid
          , instance_number
          , name
          , bytes
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , name
          , sum(bytes)
       from v$sgastat
      group by l_snap_id, p_dbid, p_instance_number, name;
   
     insert into stats$system_event
          ( snap_id
          , dbid
          , instance_number
          , event
          , total_waits
	  , total_timeouts
          , time_waited
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , event
          , total_waits
	  , total_timeouts
          , time_waited
       from v$system_event;

     insert into stats$bg_event_summary
          ( snap_id
          , dbid
          , instance_number
          , event
          , total_waits
          , total_timeouts
          , time_waited
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , e.event
          , sum(e.total_waits)
	  , sum(e.total_timeouts)
          , sum(e.time_waited)
       from v$session s
          , v$session_event e
      where s.type = 'BACKGROUND'
        and s.sid = e.sid
      group by l_snap_id, p_dbid, p_instance_number, e.event;
 
     insert into stats$sysstat
          ( snap_id
          , dbid
          , instance_number
          , statistic#
          , name
          , value
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
	  , statistic#
          , name
          , value
       from v$sysstat;
   
     insert into stats$waitstat
          ( snap_id
          , dbid
          , instance_number
          , class
          , wait_count
          , time
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , class
          , "COUNT"
          , time
       from v$waitstat;

     insert into stats$enqueuestat
          ( snap_id
          , dbid
          , instance_number
          , name
          , gets
          , waits
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , ksqsttyp
          , ksqstget
          , ksqstwat
       from x$ksqst
      where ksqstget != 0;

     insert into stats$latch
          ( snap_id
          , dbid
          , instance_number
          , name
          , latch#
          , level#
          , gets
          , misses
          , sleeps
          , immediate_gets
          , immediate_misses
          , spin_gets
	  , sleep1
          , sleep2
	  , sleep3
	  , sleep4
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , name
	  , latch#
	  , level#
       	  , gets 
	  , misses
	  , sleeps 
	  , immediate_gets
          , immediate_misses
	  , spin_gets
	  , sleep1
          , sleep2
	  , sleep3
	  , sleep4
       from v$latch;

     insert into stats$latch_misses_summary
          ( snap_id
          , dbid
          , instance_number
          , parent_name
          , where_in_code
          , nwfail_count
          , sleep_count
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , parent_name
          , "WHERE"
          , sum(nwfail_count)
          , sum(sleep_count)
       from v$latch_misses
      where sleep_count > 0
      group by l_snap_id, p_dbid, p_instance_number
          , parent_name, "WHERE";


     /*  Begin gathering Extended Statistics */

     IF l_snap_level >= 5 THEN
         insert into stats$sql_summary
              ( snap_id
              , dbid
              , instance_number
              , sql_text
              , sharable_mem
              , sorts
              , module
              , loaded_versions
              , executions
              , loads
              , invalidations
              , parse_calls
              , disk_reads
              , buffer_gets
              , rows_processed
              , address
              , hash_value
              , version_count
              )
         select min(l_snap_id)
              , min(p_dbid)
              , min(p_instance_number)
              , min(sql_text)
              , sum(sharable_mem)
              , sum(sorts)
              , min(module)
              , sum(loaded_versions)
              , sum(executions)
              , sum(loads)
              , sum(invalidations)
              , sum(parse_calls)
              , sum(disk_reads)
              , sum(buffer_gets)
              , sum(rows_processed)
              , address
              , hash_value
              , count(1)
           from v$sql
          group by address, hash_value
         having (   sum(buffer_gets) > l_buffer_gets_th 
                 or sum(disk_reads)  > l_disk_reads_th
                 or sum(parse_calls) > l_parse_calls_th
                 or sum(executions)  > l_executions_th
                );
     END IF;   /* snap level >=5 */


     IF l_snap_level >= 10 THEN
         insert into stats$latch_children
              ( snap_id
              , dbid
              , instance_number
              , latch#
              , child#
              , gets
              , misses
              , sleeps
              , immediate_gets
              , immediate_misses
              , spin_gets
              , sleep1
              , sleep2
              , sleep3
              , sleep4
              )
         select l_snap_id
              , p_dbid
              , p_instance_number
              , latch#
              , child#
              , gets 
              , misses
              , sleeps
              , immediate_gets
              , immediate_misses
              , spin_gets
              , sleep1
              , sleep2
              , sleep3
              , sleep4
           from v$latch_children;
     END IF;  /* snap level >=10 */

   
     /*  The instance has been restarted since the last snapshot */
     if p_new_sga = 0
     then
        begin

          p_new_sga := 1;

          /*  Get the instance startup time and the non-changable 
              instance SGA statistics  */
          insert into stats$sgaxs
               ( snap_id
               , dbid
               , instance_number
               , startup_time
               , parallel
               , version
               , name
               , value
               )
          select l_snap_id
               , p_dbid
               , p_instance_number
               , p_startup_time
               , p_parallel
               , p_version
               , name
               , value
            from v$sga;

          /*  Get buffer pool statistics  */
          insert into stats$buffer_pool
               ( snap_id
               , dbid
               , instance_number
               , name
	       , lo_setid
	       , set_count
	       , buffers
               )
         select l_snap_id
              , p_dbid
              , p_instance_number
              , nvl(name,'-')
              , lo_setid
              , set_count
              , buffers
           from v$buffer_pool;

      end;
     end if; /* new SGA */

     /*  Record level session-granular statistics if a specific session
         has been requested
     */
     if l_session_id > 0
     then 
         insert into stats$sesstat
              ( snap_id
              , dbid
              , instance_number
              , statistic#
              , value
              )
         select l_snap_id
              , p_dbid
              , p_instance_number
	      , statistic#
	      , value
           from v$sesstat
          where sid = l_session_id;

         insert into stats$session_event
              ( snap_id
              , dbid
              , instance_number
              , event
              , total_waits
              , total_timeouts
              , time_waited
              )
       select l_snap_id
              , p_dbid
              , p_instance_number
              , event
              , total_waits
              , total_timeouts
              , time_waited
           from v$session_event
           where sid = l_session_id;
     end if;

     commit work;

   RETURN l_snap_id;

   end SLARTI; /* Function SLARTI */

   /* ------------------------------------------------------------------- */

begin  /* STATSPACK body */

  /*  Query the database id, instance_number, database name, instance
      name and startup time for the instance we are working on
  */



  /*  Select the instance we are using  */
  open get_instance;
  fetch get_instance into 
        p_instance_number, p_instance_name
      , p_startup_time, p_parallel, p_version
      , p_host_name;
  close get_instance;

  /*  Select the database info for the db connected to */
  open get_db;
  fetch get_db into p_dbid, p_name;
  close get_db;

  /*  Check to see if this database/instance combination already exists
      in the stats$database_instance table.  If not, insert it
  */
  begin
    select 1
      into tmp_int
      from stats$database_instance
     where dbid           = p_dbid
       and instance_number = p_instance_number;
  exception
    when NO_DATA_FOUND then
      insert into stats$database_instance
           ( dbid
           , instance_number
           , db_name
           , instance_name
           , host_name
           ) 
      values
           ( p_dbid
           , p_instance_number
           , p_name
           , p_instance_name
           , p_host_name
           );
      commit;    
  end;

  /*  Keep the package
  */
  sys.dbms_shared_pool.keep('PERFSTAT.STATSPACK', 'P');


  /*  Determine if the instance has been restarted since the previous snapshot
  */
  begin
     select 1 
       into p_new_sga
       from stats$sgaxs
      where startup_time = p_startup_time
        and rownum = 1;
  exception 
     when NO_DATA_FOUND then
        p_new_sga := 0;
  end;

end STATSPACK;
/
show errors;

/* ---------------------------------------------------------------------- */

prompt
prompt NOTE:
prompt   STATSPACK complete. Please check statspack.lis for any errors.
prompt
spool off;
whenever sqlerror continue;
set echo on;
