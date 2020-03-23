Rem
Rem $Header: spcpkg.sql 17-apr-2002.16:59:10 vbarrier Exp $
Rem
Rem spcpkg.sql
Rem
Rem Copyright (c) 1999, 2002, Oracle Corporation.  All rights reserved.  
Rem
Rem    NAME
Rem      spcpkg.sql
Rem
Rem    DESCRIPTION
Rem      SQL*PLUS command file to create statistics package
Rem
Rem    NOTES
Rem      Must be run as the STATSPACK owner, PERFSTAT
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    vbarrier    03/20/02 - 2184504
Rem    spommere    03/19/02 - 2274095
Rem    vbarrier    03/05/02 - Segment Statistics
Rem    spommere    02/14/02 - cleanup RAC stats that are no longer needed
Rem    spommere    02/08/02 - 2212357
Rem    cdialeri    02/07/02 - 2218573
Rem    cdialeri    01/30/02 - 2184717
Rem    cdialeri    01/09/02 - 9.2 - features 2
Rem    cdialeri    11/30/01 - 9.2 - features 1
Rem    hbergh      08/23/01 - 1940915: use substrb on sql_text
Rem    cdialeri    04/26/01 - 9.0
Rem    cdialeri    09/12/00 - sp_1404195
Rem    cdialeri    04/07/00 - 1261813
Rem    cdialeri    03/28/00 - sp_purge
Rem    cdialeri    02/16/00 - 1191805
Rem    cdialeri    11/01/99 - Enhance, 1059172
Rem    cgervasi    06/16/98 - Remove references to wrqs
Rem    cmlim       07/30/97 - Modified system events
Rem    gwood.uk    02/30/94 - Modified
Rem    densor.uk   03/31/93 - Modified
Rem    cellis.uk   11/15/89 - Created
Rem

set echo off;
whenever sqlerror exit;

spool spcpkg.lis

/* ---------------------------------------------------------------------- */

prompt Creating Package STATSPACK...

create or replace package STATSPACK as
 
   procedure STAT_CHANGES
      ( bid           IN  number
      , eid           IN  number
      , db_ident      IN  number
      , inst_num      IN  number
      , parallel      IN  varchar2
      , lhtr    OUT number,     bfwt   OUT number
      , tran    OUT number,     chng   OUT number
      , ucal    OUT number,     urol   OUT number
      , rsiz    OUT number
      , phyr    OUT number,     phyrd  OUT number
      , phyrdl  OUT number
      , phyw    OUT number,     ucom   OUT number
      , prse    OUT number,     hprse  OUT number
      , recr    OUT number,     gets   OUT number
      , rlsr    OUT number,     rent   OUT number
      , srtm    OUT number,     srtd   OUT number
      , srtr    OUT number,     strn   OUT number
      , lhr     OUT number,     bc     OUT varchar2
      , sp      OUT varchar2,   lb     OUT varchar2
      , bs      OUT varchar2,   twt    OUT number
      , logc    OUT number,     prscpu OUT number
      , tcpu    OUT number,     exe    OUT number
      , prsela  OUT number
      , bspm    OUT number,     espm   OUT number
      , bfrm    OUT number,     efrm   OUT number
      , blog    OUT number,     elog   OUT number
      , bocur   OUT number,     eocur  OUT number
      , dmsd    OUT number,     dmfc   OUT number     -- begin RAC
      , dmsi    OUT number
      , pmrv    OUT number,     pmpt   OUT number
      , npmrv   OUT number,     npmpt  OUT number
      , dbfr    OUT number
      , dpms    OUT number,     dnpms  OUT number
      , glsg    OUT number,     glag   OUT number
      , glgt    OUT number,     glsc   OUT number
      , glac    OUT number,     glct   OUT number
      , glrl    OUT number,     gcdfr  OUT number
      , gcge    OUT number,     gcgt   OUT number
      , gccv    OUT number,     gcct   OUT number
      , gccrrv  OUT number,     gccrrt OUT number
      , gccurv  OUT number,     gccurt OUT number
      , gccrsv  OUT number
      , gccrbt  OUT number,     gccrft OUT number
      , gccrst  OUT number,     gccusv OUT number
      , gccupt  OUT number,     gccuft OUT number
      , gccust  OUT number
      , msgsq   OUT number,     msgsqt  OUT number
      , msgsqk  OUT number,     msgsqtk OUT number
      , msgrq   OUT number,     msgrqt  OUT number    -- end RAC
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
      ,i_sharable_mem_th     in number   default null
      ,i_version_count_th    in number   default null
      ,i_seg_phy_reads_th    in number   default null
      ,i_seg_log_reads_th    in number   default null
      ,i_seg_buff_busy_th    in number   default null
      ,i_seg_rowlock_w_th    in number   default null
      ,i_seg_itl_waits_th    in number   default null
      ,i_seg_cr_bks_sd_th    in number   default null
      ,i_seg_cu_bks_sd_th    in number   default null
      ,i_all_init            in varchar2 default null
      ,i_pin_statspack       in varchar2 default null
      ,i_modify_parameter    in varchar2 default 'FALSE'
      );

   function SNAP
      (i_snap_level          in number   default null
      ,i_session_id          in number   default null
      ,i_ucomment            in varchar2 default null
      ,i_num_sql             in number   default null
      ,i_executions_th       in number   default null
      ,i_parse_calls_th      in number   default null
      ,i_disk_reads_th       in number   default null
      ,i_buffer_gets_th      in number   default null
      ,i_sharable_mem_th     in number   default null
      ,i_version_count_th    in number   default null
      ,i_seg_phy_reads_th    in number   default null
      ,i_seg_log_reads_th    in number   default null
      ,i_seg_buff_busy_th    in number   default null
      ,i_seg_rowlock_w_th    in number   default null
      ,i_seg_itl_waits_th    in number   default null
      ,i_seg_cr_bks_sd_th    in number   default null
      ,i_seg_cu_bks_sd_th    in number   default null
      ,i_all_init            in varchar2 default null
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
      , i_sharable_mem_th     in  number   default null
      , i_version_count_th    in  number   default null
      , i_seg_phy_reads_th    in  number   default null
      , i_seg_log_reads_th    in  number   default null
      , i_seg_buff_busy_th    in  number   default null
      , i_seg_rowlock_w_th    in  number   default null
      , i_seg_itl_waits_th    in  number   default null
      , i_seg_cr_bks_sd_th    in  number   default null
      , i_seg_cu_bks_sd_th    in  number   default null
      , i_all_init            in  varchar2 default null
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
      , i_sharable_mem_th     in  number   default null
      , i_version_count_th    in  number   default null
      , i_seg_phy_reads_th    in  number   default null
      , i_seg_log_reads_th    in  number   default null
      , i_seg_buff_busy_th    in  number   default null
      , i_seg_rowlock_w_th    in  number   default null
      , i_seg_itl_waits_th    in  number   default null
      , i_seg_cr_bks_sd_th    in  number   default null
      , i_seg_cu_bks_sd_th    in  number   default null
      , i_all_init            in  varchar2 default null
      , i_pin_statspack       in  varchar2 default null
      , i_modify_parameter    in  varchar2 default 'FALSE'
      , o_snap_level          out number
      , o_session_id          out number
      , o_ucomment            out varchar2
      , o_num_sql             out number
      , o_executions_th       out number
      , o_parse_calls_th      out number
      , o_disk_reads_th       out number
      , o_buffer_gets_th      out number
      , o_sharable_mem_th     out number
      , o_version_count_th    out number
      , o_seg_phy_reads_th    out number
      , o_seg_log_reads_th    out number
      , o_seg_buff_busy_th    out number
      , o_seg_rowlock_w_th    out number
      , o_seg_itl_waits_th    out number
      , o_seg_cr_bks_sd_th    out number
      , o_seg_cu_bks_sd_th    out number
      , o_all_init            out varchar2
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
   p_def_sharable_mem_th   number default 1048576;   /* Sharable memory      */
   p_def_version_count_th  number default 20;        /* Child Cursors        */
   /* Below are the default threshold (_th) values for choosing Segment stats      
      to store in the stats$seg_stat table - these segments will typically 
      be the segments using the most resources or segments having the most 
      contention.
   */
   p_def_seg_phy_reads_th      number default 1000;   /* Num. physical reads */
   p_def_seg_log_reads_th      number default 10000;  /* Num. logical reads  */
   p_def_seg_buff_busy_th      number default 100; /* Num. buffer busy waits */
   p_def_seg_rowlock_w_th      number default 100;    /* Num. row lock waits */
   p_def_seg_itl_waits_th      number default 100;         /* Num. ITL waits */
   p_def_seg_cr_bks_sd_th      number default 1000;  /* Num. RAC CR bks done */
   p_def_seg_cu_bks_sd_th      number default 1000;  /* Num. RAC CU bks done */
   p_def_all_init          varchar2(10)  default 'FALSE';

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
      ,i_sharable_mem_th     in number   default null
      ,i_version_count_th    in number   default null
      ,i_seg_phy_reads_th    in number   default null
      ,i_seg_log_reads_th    in number   default null
      ,i_seg_buff_busy_th    in number   default null
      ,i_seg_rowlock_w_th    in number   default null
      ,i_seg_itl_waits_th    in number   default null
      ,i_seg_cr_bks_sd_th    in number   default null
      ,i_seg_cu_bks_sd_th    in number   default null
      ,i_all_init            in varchar2 default null
      ,i_pin_statspack       in varchar2 default null
      ,i_modify_parameter    in varchar2 default 'FALSE'
      )
   is 

   /*  Takes a snapshot by calling the SNAP function, and discards 
       the snapshot id.  This is useful when automating taking 
       snapshots from dbms_job
   */   

   l_snap_id number;

   begin
     l_snap_id := statspack.snap  ( i_snap_level, i_session_id, i_ucomment 
                                  , i_num_sql
                                  , i_executions_th 
                                  , i_parse_calls_th
                                  , i_disk_reads_th
                                  , i_buffer_gets_th
                                  , i_sharable_mem_th
                                  , i_version_count_th
                                  , i_seg_phy_reads_th
                                  , i_seg_log_reads_th
                                  , i_seg_buff_busy_th
                                  , i_seg_rowlock_w_th
                                  , i_seg_itl_waits_th
				  , i_seg_cr_bks_sd_th
				  , i_seg_cu_bks_sd_th
                                  , i_all_init
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
      , i_sharable_mem_th     in  number   default null
      , i_version_count_th    in  number   default null
      , i_seg_phy_reads_th    in  number   default null
      , i_seg_log_reads_th    in  number   default null
      , i_seg_buff_busy_th    in  number   default null
      , i_seg_rowlock_w_th    in  number   default null
      , i_seg_itl_waits_th    in  number   default null
      , i_seg_cr_bks_sd_th    in  number   default null
      , i_seg_cu_bks_sd_th    in  number   default null
      , i_all_init            in  varchar2 default null
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
      l_sharable_mem_th            number;
      l_version_count_th           number;
      l_seg_phy_reads_th           number;
      l_seg_log_reads_th           number;
      l_seg_buff_busy_th           number;
      l_seg_rowlock_w_th           number;
      l_seg_itl_waits_th           number;
      l_seg_cr_bks_sd_th           number;
      l_seg_cu_bks_sd_th           number;
      l_all_init                   varchar2(5);
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
                                       , i_sharable_mem_th
                                       , i_version_count_th
      				       , i_seg_phy_reads_th
				       , i_seg_log_reads_th
				       , i_seg_buff_busy_th
				       , i_seg_rowlock_w_th
				       , i_seg_itl_waits_th
				       , i_seg_cr_bks_sd_th
				       , i_seg_cu_bks_sd_th
                                       , i_all_init
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
                                       , l_sharable_mem_th
                                       , l_version_count_th
      				       , l_seg_phy_reads_th
				       , l_seg_log_reads_th
				       , l_seg_buff_busy_th
				       , l_seg_rowlock_w_th
				       , l_seg_itl_waits_th
				       , l_seg_cr_bks_sd_th
				       , l_seg_cu_bks_sd_th
                                       , l_all_init
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
      , i_sharable_mem_th     in  number   default null
      , i_version_count_th    in  number   default null
      , i_seg_phy_reads_th    in  number   default null
      , i_seg_log_reads_th    in  number   default null
      , i_seg_buff_busy_th    in  number   default null
      , i_seg_rowlock_w_th    in  number   default null
      , i_seg_itl_waits_th    in  number   default null
      , i_seg_cr_bks_sd_th    in  number   default null
      , i_seg_cu_bks_sd_th    in  number   default null
      , i_all_init            in  varchar2 default null
      , i_pin_statspack       in  varchar2 default null
      , i_modify_parameter    in  varchar2 default 'FALSE'
      , o_snap_level          out number
      , o_session_id          out number
      , o_ucomment            out varchar2
      , o_num_sql             out number
      , o_executions_th       out number
      , o_parse_calls_th      out number
      , o_disk_reads_th       out number
      , o_buffer_gets_th      out number
      , o_sharable_mem_th     out number
      , o_version_count_th    out number
      , o_seg_phy_reads_th    out number
      , o_seg_log_reads_th    out number
      , o_seg_buff_busy_th    out number
      , o_seg_rowlock_w_th    out number
      , o_seg_itl_waits_th    out number
      , o_seg_cr_bks_sd_th    out number
      , o_seg_cu_bks_sd_th    out number
      , o_all_init            out varchar2
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
     ui_all_init       varchar2(5);
     l_params_exist    varchar2(1);

     begin

       if ((i_dbid is null ) or (i_instance_number is null)) then
         l_dbid            := p_dbid;
         l_instance_number := p_instance_number;
       else
         l_dbid            := i_dbid;
         l_instance_number := i_instance_number;
       end if;

       /*  Upper case any input vars which are inserted  */
       ui_all_init := upper(i_all_init);

       if (   (i_modify_parameter is null)
           or (upper(i_modify_parameter) = 'FALSE')  ) then

       /* Query values, if none exist, insert the defaults tempered 
          with variables supplied */

         begin

           select nvl(i_session_id,       session_id)
                , nvl(i_snap_level,       snap_level)
                , nvl(i_ucomment,         ucomment)
                , nvl(i_num_sql,          num_sql)
                , nvl(i_executions_th,    executions_th)
                , nvl(i_parse_calls_th,   parse_calls_th)
                , nvl(i_disk_reads_th,    disk_reads_th)
                , nvl(i_buffer_gets_th,   buffer_gets_th)
                , nvl(i_sharable_mem_th,  sharable_mem_th)
                , nvl(i_version_count_th, version_count_th)
                , nvl(i_seg_phy_reads_th, seg_phy_reads_th)
                , nvl(i_seg_log_reads_th, seg_log_reads_th)
                , nvl(i_seg_buff_busy_th, seg_buff_busy_th)
                , nvl(i_seg_rowlock_w_th, seg_rowlock_w_th)
                , nvl(i_seg_itl_waits_th, seg_itl_waits_th)
                , nvl(i_seg_cr_bks_sd_th, seg_cr_bks_sd_th)
                , nvl(i_seg_cu_bks_sd_th, seg_cu_bks_sd_th)
                , nvl(ui_all_init,        all_init)
                , nvl(i_pin_statspack,    pin_statspack)   
             into o_session_id
                , o_snap_level
                , o_ucomment
                , o_num_sql
                , o_executions_th
                , o_parse_calls_th
                , o_disk_reads_th
                , o_buffer_gets_th
                , o_sharable_mem_th
                , o_version_count_th
                , o_seg_phy_reads_th
                , o_seg_log_reads_th
                , o_seg_buff_busy_th
                , o_seg_rowlock_w_th
                , o_seg_itl_waits_th
                , o_seg_cr_bks_sd_th
                , o_seg_cu_bks_sd_th
                , o_all_init
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
                  , sharable_mem_th
                  , version_count_th
                  , seg_phy_reads_th
                  , seg_log_reads_th
                  , seg_buff_busy_th
                  , seg_rowlock_w_th
                  , seg_itl_waits_th
                  , seg_cr_bks_sd_th
                  , seg_cu_bks_sd_th
                  , all_init
                  , pin_statspack
                  , last_modified
                  )
             values 
                  ( l_dbid
                  , l_instance_number
                  , p_def_session_id
                  , p_def_snap_level
                  , p_def_ucomment
                  , p_def_num_sql
                  , p_def_executions_th
                  , p_def_parse_calls_th
                  , p_def_disk_reads_th
                  , p_def_buffer_gets_th
                  , p_def_sharable_mem_th
                  , p_def_version_count_th
                  , p_def_seg_phy_reads_th
                  , p_def_seg_log_reads_th
                  , p_def_seg_buff_busy_th
                  , p_def_seg_rowlock_w_th
                  , p_def_seg_itl_waits_th
                  , p_def_seg_cr_bks_sd_th
                  , p_def_seg_cu_bks_sd_th
                  , p_def_all_init
                  , p_def_pin_statspack
                  , SYSDATE
                  )
          returning nvl(i_session_id,       p_def_session_id)
                  , nvl(i_snap_level,       p_def_snap_level)
                  , nvl(i_ucomment,         p_def_ucomment)
                  , nvl(i_num_sql,          p_def_num_sql)
                  , nvl(i_executions_th,    p_def_executions_th)
                  , nvl(i_parse_calls_th,   p_def_parse_calls_th)
                  , nvl(i_disk_reads_th,    p_def_disk_reads_th)
                  , nvl(i_buffer_gets_th,   p_def_buffer_gets_th)
                  , nvl(i_sharable_mem_th,  p_def_sharable_mem_th)
                  , nvl(i_version_count_th, p_def_version_count_th)
                  , nvl(i_seg_phy_reads_th, p_def_seg_phy_reads_th)
                  , nvl(i_seg_log_reads_th, p_def_seg_log_reads_th)
                  , nvl(i_seg_buff_busy_th, p_def_seg_buff_busy_th)
                  , nvl(i_seg_rowlock_w_th, p_def_seg_rowlock_w_th)
                  , nvl(i_seg_itl_waits_th, p_def_seg_itl_waits_th)
                  , nvl(i_seg_cr_bks_sd_th, p_def_seg_cr_bks_sd_th)
                  , nvl(i_seg_cu_bks_sd_th, p_def_seg_cu_bks_sd_th)
                  , nvl(ui_all_init,        p_def_all_init)
                  , nvl(i_pin_statspack,    p_def_pin_statspack)
               into o_session_id
                  , o_snap_level
                  , o_ucomment
                  , o_num_sql
                  , o_executions_th
                  , o_parse_calls_th
                  , o_disk_reads_th
                  , o_buffer_gets_th
                  , o_sharable_mem_th
                  , o_version_count_th
                  , o_seg_phy_reads_th
                  , o_seg_log_reads_th
                  , o_seg_buff_busy_th
                  , o_seg_rowlock_w_th
                  , o_seg_itl_waits_th
                  , o_seg_cr_bks_sd_th
                  , o_seg_cu_bks_sd_th
                  , o_all_init
                  , o_pin_statspack;

         end; /* don't modify parameter values */

       elsif upper(i_modify_parameter) = 'TRUE' then

       /* modify values, if none exist, insert the defaults tempered 
          with the variables supplied */

         begin

           update stats$statspack_parameter
              set session_id       = nvl(i_session_id,       session_id)
                , snap_level       = nvl(i_snap_level,       snap_level)
                , ucomment         = nvl(i_ucomment,         ucomment)
                , num_sql          = nvl(i_num_sql,          num_sql)
                , executions_th    = nvl(i_executions_th,    executions_th)
                , parse_calls_th   = nvl(i_parse_calls_th,   parse_calls_th)
                , disk_reads_th    = nvl(i_disk_reads_th,    disk_reads_th)
                , buffer_gets_th   = nvl(i_buffer_gets_th,   buffer_gets_th)
                , sharable_mem_th  = nvl(i_sharable_mem_th,  sharable_mem_th)
                , version_count_th = nvl(i_version_count_th, version_count_th)
                , seg_phy_reads_th = nvl(i_seg_phy_reads_th, seg_phy_reads_th)
                , seg_log_reads_th = nvl(i_seg_log_reads_th, seg_log_reads_th)
                , seg_buff_busy_th = nvl(i_seg_buff_busy_th, seg_buff_busy_th)
                , seg_rowlock_w_th = nvl(i_seg_rowlock_w_th, seg_rowlock_w_th)
                , seg_itl_waits_th = nvl(i_seg_itl_waits_th, seg_itl_waits_th)
                , seg_cr_bks_sd_th = nvl(i_seg_cr_bks_sd_th, p_def_seg_cr_bks_sd_th)
                , seg_cu_bks_sd_th = nvl(i_seg_cu_bks_sd_th, p_def_seg_cu_bks_sd_th)
                , all_init         = nvl(ui_all_init,        all_init)
                , pin_statspack    = nvl(i_pin_statspack,    pin_statspack)   
            where instance_number  = l_instance_number
              and dbid             = l_dbid
        returning session_id
                , snap_level
                , ucomment
                , num_sql
                , executions_th
                , parse_calls_th
                , disk_reads_th
                , buffer_gets_th
                , sharable_mem_th
                , version_count_th
                , seg_phy_reads_th
                , seg_log_reads_th
                , seg_buff_busy_th
                , seg_rowlock_w_th
                , seg_itl_waits_th
                , seg_cr_bks_sd_th
                , seg_cu_bks_sd_th
                , all_init
                , pin_statspack
             into o_session_id
                , o_snap_level
                , o_ucomment
                , o_num_sql
                , o_executions_th
                , o_parse_calls_th
                , o_disk_reads_th
                , o_buffer_gets_th
                , o_sharable_mem_th
                , o_version_count_th
                , o_seg_phy_reads_th
                , o_seg_log_reads_th
                , o_seg_buff_busy_th
                , o_seg_rowlock_w_th
                , o_seg_itl_waits_th
                , o_seg_cr_bks_sd_th
                , o_seg_cu_bks_sd_th
                , o_all_init
                , o_pin_statspack;

             if SQL%ROWCOUNT = 0 then

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
                    , sharable_mem_th
                    , version_count_th
                    , seg_phy_reads_th
                    , seg_log_reads_th
                    , seg_buff_busy_th
                    , seg_rowlock_w_th
                    , seg_itl_waits_th
                    , seg_cr_bks_sd_th
                    , seg_cu_bks_sd_th
                    , all_init
                    , pin_statspack
                    , last_modified
                    )
              values 
                    ( l_dbid
                    , l_instance_number
                    , nvl(i_session_id,       p_def_session_id)
                    , nvl(i_snap_level,       p_def_snap_level)
                    , nvl(i_ucomment,         p_def_ucomment)
                    , nvl(i_num_sql,          p_def_num_sql)
                    , nvl(i_executions_th,    p_def_executions_th)
                    , nvl(i_parse_calls_th,   p_def_parse_calls_th)
                    , nvl(i_disk_reads_th,    p_def_disk_reads_th)
                    , nvl(i_buffer_gets_th,   p_def_buffer_gets_th)
                    , nvl(i_sharable_mem_th,  p_def_sharable_mem_th)
                    , nvl(i_version_count_th, p_def_version_count_th)
                    , nvl(i_seg_phy_reads_th, p_def_seg_phy_reads_th)
                    , nvl(i_seg_log_reads_th, p_def_seg_log_reads_th)
                    , nvl(i_seg_buff_busy_th, p_def_seg_buff_busy_th)
                    , nvl(i_seg_rowlock_w_th, p_def_seg_rowlock_w_th)
                    , nvl(i_seg_itl_waits_th, p_def_seg_itl_waits_th)
                    , nvl(i_seg_cr_bks_sd_th, p_def_seg_cr_bks_sd_th)
                    , nvl(i_seg_cu_bks_sd_th, p_def_seg_cu_bks_sd_th)
                    , nvl(ui_all_init,        p_def_all_init)
                    , nvl(i_pin_statspack,    p_def_pin_statspack)
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
                    , sharable_mem_th
                    , version_count_th
                    , seg_phy_reads_th
                    , seg_log_reads_th
                    , seg_buff_busy_th
                    , seg_rowlock_w_th
                    , seg_itl_waits_th
                    , seg_cr_bks_sd_th
                    , seg_cu_bks_sd_th
                    , all_init
                    , pin_statspack
                 into o_session_id
                    , o_snap_level
                    , o_ucomment
                    , o_num_sql
                    , o_executions_th
                    , o_parse_calls_th
                    , o_disk_reads_th
                    , o_buffer_gets_th
                    , o_sharable_mem_th
                    , o_version_count_th
                    , o_seg_phy_reads_th
                    , o_seg_log_reads_th
                    , o_seg_buff_busy_th
                    , o_seg_rowlock_w_th
                    , o_seg_itl_waits_th
                    , o_seg_cr_bks_sd_th
                    , o_seg_cu_bks_sd_th
                    , o_all_init
                    , o_pin_statspack;

                end if;

         end; /* modify values */

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
      Modified to include multi-db support.
   */
      ( bid           IN  number
      , eid           IN  number
      , db_ident      IN  number
      , inst_num      IN  number
      , parallel      IN  varchar2
      , lhtr    OUT number,     bfwt   OUT number
      , tran    OUT number,     chng   OUT number
      , ucal    OUT number,     urol   OUT number
      , rsiz    OUT number
      , phyr    OUT number,     phyrd  OUT number
      , phyrdl  OUT number
      , phyw    OUT number,     ucom   OUT number
      , prse    OUT number,     hprse  OUT number
      , recr    OUT number,     gets   OUT number
      , rlsr    OUT number,     rent   OUT number
      , srtm    OUT number,     srtd   OUT number
      , srtr    OUT number,     strn   OUT number
      , lhr     OUT number,     bc     OUT varchar2
      , sp      OUT varchar2,   lb     OUT varchar2
      , bs      OUT varchar2,   twt    OUT number
      , logc    OUT number,     prscpu OUT number
      , tcpu    OUT number,     exe    OUT number
      , prsela  OUT number
      , bspm    OUT number,     espm   OUT number
      , bfrm    OUT number,     efrm   OUT number
      , blog    OUT number,     elog   OUT number
      , bocur   OUT number,     eocur  OUT number
      , dmsd    OUT number,     dmfc   OUT number     -- begin RAC
      , dmsi    OUT number
      , pmrv    OUT number,     pmpt   OUT number
      , npmrv   OUT number,     npmpt  OUT number
      , dbfr   OUT number
      , dpms    OUT number,     dnpms  OUT number
      , glsg    OUT number,     glag   OUT number
      , glgt    OUT number,     glsc   OUT number
      , glac    OUT number,     glct   OUT number
      , glrl    OUT number,     gcdfr  OUT number
      , gcge    OUT number,     gcgt   OUT number
      , gccv    OUT number,     gcct   OUT number
      , gccrrv  OUT number,     gccrrt OUT number
      , gccurv  OUT number,     gccurt OUT number
      , gccrsv  OUT number
      , gccrbt  OUT number,     gccrft OUT number
      , gccrst  OUT number,     gccusv OUT number
      , gccupt  OUT number,     gccuft OUT number
      , gccust  OUT number
      , msgsq   OUT number,     msgsqt  OUT number
      , msgsqk  OUT number,     msgsqtk OUT number
      , msgrq   OUT number,     msgrqt  OUT number    -- end RAC
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
               and dbid            = db_ident
               and instance_number = inst_num;

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

      function GET_PARAM (i_name varchar2) RETURN varchar2 is

      /* Returns the value for the init.ora parameter for the snapshot
         specified.
      */

         cursor PARAMETER is
            select value
              from stats$parameter
             where snap_id         = eid
               and dbid            = db_ident
               and instance_number = inst_num
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

      function GET_SYSSTAT (i_name varchar2, i_beid number) RETURN number is

      /* Returns the value for the System Statistic for the snapshot
         specified.
      */

         cursor SYSSTAT is
            select value
              from stats$sysstat
             where snap_id         = i_beid
               and dbid            = db_ident
               and instance_number = inst_num
               and name            = i_name;

         stat_value varchar2(512);

      begin

         if not SYSSTAT%ISOPEN then open SYSSTAT; end if;
         fetch SYSSTAT into stat_value;
         if SYSSTAT%NOTFOUND then
            raise_application_error
			(-20100,'Missing System Statistic '|| i_name);
         end if; close SYSSTAT;

         return stat_value;

      end GET_SYSSTAT;

      /* ---------------------------------------------------------------- */

      function BUFFER_WAITS RETURN number is

      /* Returns the total number of waits for all buffers in the interval
         specified by the begin and end snapshot id's (bid, eid)
      */

         cursor BW (i_snap_id number) is
            select sum(wait_count)
              from stats$waitstat
             where snap_id         = i_snap_id
               and dbid            = db_ident
               and instance_number = inst_num;

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
            select sum(time_waited_micro)
              from stats$system_event
             where snap_id         = i_snap_id
               and dbid            = db_ident
               and instance_number = inst_num
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
               and dbid            = db_ident
               and instance_number = inst_num;

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

      function SGASTAT (i_name varchar2, i_beid number) RETURN number is

      /* Returns the bytes used by i_name in the shared pool
         for the begin or end snapshot (bid, eid) specified
      */

      cursor bytes_used is
        select bytes
          from stats$sgastat
         where snap_id         = i_beid
           and dbid            = db_ident
           and instance_number = inst_num
           and pool            in ('shared pool', 'all pools')
           and name            = i_name; 

       total_bytes number;

       begin
        if i_name = 'total_shared_pool' then
          select sum(bytes)
            into total_bytes
            from stats$sgastat
           where snap_id         = i_beid
             and dbid            = db_ident
             and instance_number = inst_num
             and pool            in ('shared pool','all pools');
        else
          open bytes_used; fetch bytes_used into total_bytes;
          if bytes_used%notfound then
             raise_application_error
			(-20100,'Missing value for SGASTAT: '||i_name);
          end if;
          close bytes_used;
        end if;
 
         return total_bytes;
      end SGASTAT;

      /* ---------------------------------------------------------------- */

      function SYSDIF (i_name varchar2) RETURN number is

      /* Returns the difference between statistics for the statistic
         name specified for the interval between the begin and end 
         snapshot id's (bid, eid)

         In the case the Statspack schema includes data from a prior
         server release, this function returns NULL for statistics which
         do not appear in both the begin and end snapshots
      */

      beg_val_missing   boolean := false;
      end_val_missing   boolean := false;

      cursor SY (i_snap_id number) is
      select value 
        from stats$sysstat
       where snap_id         = i_snap_id
         and dbid            = db_ident
         and instance_number = inst_num
         and name            = i_name;

      begin
         /* Get start value */
         open SY (bid); fetch SY into bval;
         if SY%notfound then
            beg_val_missing := true;
         end if; close SY;

         /* Get end value */
         open SY (eid); fetch SY into eval;
         if SY%notfound then
            end_val_missing := true;
         end if; close SY;

         if     beg_val_missing = true
            and end_val_missing = true      then

              /* this is likely a newer SYSSTAT statitic which did not
                 exist for these snapshot ranges / database version    */
              return null;

         elsif     beg_val_missing = true
               and end_val_missing = false  then

               raise_application_error
		(-20100,'Missing start value for statistic: '||i_name);

         elsif     beg_val_missing = false
               and end_val_missing = true   then

               raise_application_error
		(-20100,'Missing end value for statistic: '||i_name);
         else

              /* Return difference */
              return eval - bval;

         end if;

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
            and ses.dbid        = db_ident
            and sys.dbid        = db_ident
            and ses.instance_number = inst_num
            and sys.instance_number = inst_num
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

/* ---------------------------------------------------------------- */

      function DLMDIF (i_name varchar2) RETURN number is

      /* Returns the difference between statistics for the statistic
         name specified for the interval between the begin and end
         snapshot id's (bid, eid)

         In the case the Statspack schema includes data from a prior
         server release, this function returns NULL for statistics which
         do not appear in both the begin and end snapshots
      */

      beg_val_missing   boolean := false;
      end_val_missing   boolean := false;

      cursor DLM (i_snap_id number) is
      select value
        from stats$dlm_misc
       where snap_id         = i_snap_id
         and dbid            = db_ident
         and instance_number = inst_num
         and name            = i_name;

      begin

         /* Get start value */
         open DLM (bid); fetch DLM into bval;
         if DLM%notfound then
            beg_val_missing := true;
         end if; close DLM;

         /* Get end value */
         open DLM (eid); fetch DLM into eval;
         if DLM%notfound then
            end_val_missing := true;
         end if; close DLM;

         if     beg_val_missing = true
            and end_val_missing = true      then

              /* this is likely a newer DLM_MISC statitic which did not
                 exist for these snapshot ranges / database version    */
              return null;

         elsif     beg_val_missing = true
               and end_val_missing = false  then

               raise_application_error
		(-20100,'Missing start value for statistic: '||i_name);

         elsif     beg_val_missing = false
               and end_val_missing = true   then

               raise_application_error
		(-20100,'Missing end value for statistic: '||i_name);
         else

              /* Return difference */
              return eval - bval;

         end if;

      end DLMDIF;


   /* ------------------------------------------------------------------- */
 

   begin     /* main procedure body of STAT_CHANGES */

      lhtr := LIBRARYCACHE_HITRATIO;
      bfwt := BUFFER_WAITS;
      lhr  := LATCH_HITRATIO;
      chng := SYSDIF('db block changes');
      ucal := SYSDIF('user calls');
      urol := SYSDIF('user rollbacks');
      ucom := SYSDIF('user commits');
      tran := ucom + urol;
      rsiz := SYSDIF('redo size');
      phyr := SYSDIF('physical reads');
      phyrd := SYSDIF('physical reads direct');
      phyrdl := SYSDIF('physical reads direct (lob)');
      phyw := SYSDIF('physical writes');
      hprse := SYSDIF('parse count (hard)');
      prse  := SYSDIF('parse count (total)');
      gets := SYSDIF('session logical reads');
      recr := SYSDIF('recursive calls');
      rlsr := SYSDIF('redo log space requests');
      rent := SYSDIF('redo entries');
      srtm := SYSDIF('sorts (memory)');
      srtd := SYSDIF('sorts (disk)');
      srtr := SYSDIF('sorts (rows)');
      logc := SYSDIF('logons cumulative');
      prscpu := SYSDIF('parse time cpu');
      prsela := SYSDIF('parse time elapsed');
      tcpu := SYSDIF('CPU used by this session');
      exe  := SYSDIF('execute count');
      bs   := GET_PARAM('db_block_size');
      bc   := GET_PARAM('db_block_buffers') * bs;
      if bc = 0 then
        bc   :=   GET_PARAM('db_cache_size')
                + GET_PARAM('db_keep_cache_size')
                + GET_PARAM('db_recycle_cache_size')
                + GET_PARAM('db_2k_cache_size')
                + GET_PARAM('db_4k_cache_size')
                + GET_PARAM('db_8k_cache_size')
                + GET_PARAM('db_16k_cache_size')
                + GET_PARAM('db_32k_cache_size');
      end if;
      sp   := GET_PARAM('shared_pool_size');
      lb   := GET_PARAM('log_buffer');
      twt  := TOTAL_EVENT_TIME;     -- total wait time for all non-idle events
      bspm := SGASTAT('total_shared_pool', bid);
      espm := SGASTAT('total_shared_pool', eid);
      bfrm := SGASTAT('free memory', bid);
      efrm := SGASTAT('free memory', eid);
      blog := GET_SYSSTAT('logons current', bid);
      elog := GET_SYSSTAT('logons current', eid);
      bocur := GET_SYSSTAT('opened cursors current', bid);
      eocur := GET_SYSSTAT('opened cursors current', eid);

      /*  Do we want to report on cluster-specific statistics? Check
          in procedure variable "parallel".
      */

      if parallel = 'YES' then

        dmsd     := DLMDIF('messages sent directly');
        dmfc     := DLMDIF('messages flow controlled');
        dmsi     := DLMDIF('messages sent indirectly');
        pmrv     := DLMDIF('gcs msgs received');
        pmpt     := DLMDIF('gcs msgs process time(ms)');
        npmrv    := DLMDIF('ges msgs received');
        npmpt    := DLMDIF('ges msgs process time(ms)');
        dbfr     := SYSDIF('DBWR fusion writes');
        dpms     := SYSDIF('gcs messages sent');
        dnpms    := SYSDIF('ges messages sent');
        glsg     := SYSDIF('global lock sync gets');
        glag     := SYSDIF('global lock async gets');
        glgt     := SYSDIF('global lock get time');
        glsc     := SYSDIF('global lock sync converts');
        glac     := SYSDIF('global lock async converts');
        glct     := SYSDIF('global lock convert time');
        glrl     := SYSDIF('global lock releases');
        gcdfr    := SYSDIF('global cache defers');
        gcge     := SYSDIF('global cache gets');
        gcgt     := SYSDIF('global cache get time');
        gccv     := SYSDIF('global cache converts');
        gcct     := SYSDIF('global cache convert time');
        gccrrv   := SYSDIF('global cache cr blocks received');
        gccrrt   := SYSDIF('global cache cr block receive time');
        gccurv   := SYSDIF('global cache current blocks received');
        gccurt   := SYSDIF('global cache current block receive time');
        gccrsv   := SYSDIF('global cache cr blocks served');
        gccrbt   := SYSDIF('global cache cr block build time');
        gccrft   := SYSDIF('global cache cr block flush time');
        gccrst   := SYSDIF('global cache cr block send time');
        gccusv   := SYSDIF('global cache current blocks served');
        gccupt   := SYSDIF('global cache current block pin time');
        gccuft   := SYSDIF('global cache current block flush time');
        gccust   := SYSDIF('global cache current block send time');
        msgsq    := DLMDIF('msgs sent queued');
        msgsqt   := DLMDIF('msgs sent queue time (ms)');
        msgsqk   := DLMDIF('msgs sent queued on ksxp');
        msgsqtk  := DLMDIF('msgs sent queue time on ksxp (ms)');
        msgrqt   := DLMDIF('msgs received queue time (ms)');
        msgrq    := DLMDIF('msgs received queued');

     end if;


      /*  Determine if we want to report on session-specific statistics.
          Check that the session is the same one for both snapshots.
      */
      select session_id
           , serial#
        into l_b_session_id
           , l_b_serial#
        from stats$snapshot
       where snap_id         = bid
         and dbid            = db_ident
         and instance_number = inst_num;

      select session_id
           , serial#
        into l_e_session_id
           , l_e_serial#
        from stats$snapshot
       where snap_id         = eid
         and dbid            = db_ident
         and instance_number = inst_num;

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

   function SNAP
      (i_snap_level               in number   default null
      ,i_session_id               in number   default null
      ,i_ucomment                 in varchar2 default null
      ,i_num_sql                  in number   default null
      ,i_executions_th            in number   default null
      ,i_parse_calls_th           in number   default null
      ,i_disk_reads_th            in number   default null
      ,i_buffer_gets_th           in number   default null
      ,i_sharable_mem_th          in number   default null
      ,i_version_count_th         in number   default null
      ,i_seg_phy_reads_th         in number   default null
      ,i_seg_log_reads_th         in number   default null
      ,i_seg_buff_busy_th         in number   default null
      ,i_seg_rowlock_w_th         in number   default null
      ,i_seg_itl_waits_th         in number   default null
      ,i_seg_cr_bks_sd_th         in number   default null
      ,i_seg_cu_bks_sd_th         in number   default null
      ,i_all_init                 in varchar2 default null
      ,i_pin_statspack            in varchar2 default null
      ,i_modify_parameter         in varchar2 default 'FALSE'
      )
     RETURN integer IS

   /*  This function performs a snapshot of the v$ views into the
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
   l_sharable_mem_th            number;
   l_version_count_th           number;
   l_seg_phy_reads_th           number;
   l_seg_log_reads_th           number;
   l_seg_buff_busy_th           number;
   l_seg_rowlock_w_th           number;
   l_seg_itl_waits_th           number;
   l_seg_cr_bks_sd_th           number;
   l_seg_cu_bks_sd_th           number;
   l_all_init                   varchar2(5);
   l_pin_statspack              varchar2(10);
/*
   l_sql_stmt                   varchar2(3000);
   l_slarti                     varchar2(20);
   l_threshold                  number;
   l_total_sql                  number := 0;
   l_total_sql_mem              number := 0;
   l_single_use_sql             number := 0;
   l_single_use_sql_mem         number := 0;
   l_text_subset                varchar2(31);
*/
   l_sharable_mem               number;
   l_version_count              number;
/*
   l_sorts                      number;
   l_module                     varchar2(64);
   l_loaded_versions            number;
   l_executions                 number;
   l_loads                      number;
   l_invalidations              number;
   l_parse_calls                number;
   l_disk_reads                 number;
   l_buffer_gets                number;
   l_rows_processed             number;
   l_address                    raw(8);
   l_hash_value                 number;
*/
   l_max_begin_time             date;

   l_counter_maxvalue		positive := 100;
   l_counter			integer  := 0;
   l_insert_done		boolean  := FALSE; -- avoid ORA-1

   cursor GETSERIAL is
      select serial#
        from v$session
       where sid = l_session_id;

  /* ---------------------------------------------------------------- */

    PROCEDURE snap_sql IS

     begin

        /*  Gather summary statistics  */

        insert into stats$sql_statistics
             ( snap_id
             , dbid
             , instance_number
             , total_sql
             , total_sql_mem
             , single_use_sql
             , single_use_sql_mem
             )
        select l_snap_id
             , p_dbid
             , p_instance_number
             , count(1)
             , sum(sharable_mem)
             , sum(decode(executions, 1, 1,            0))
             , sum(decode(executions, 1, sharable_mem, 0))
          from stats$v$sqlxs
         where is_obsolete = 'N';


       /*  Gather SQL statements which exceed any threshold,
           excluding obsolete parent cursors
        */

       insert into stats$sql_summary
            ( snap_id
            , dbid
            , instance_number
            , text_subset
            , sharable_mem
            , sorts
            , module
            , loaded_versions
            , fetches
            , executions
            , loads
            , invalidations
            , parse_calls
            , disk_reads
            , buffer_gets
            , rows_processed
            , command_type
            , address
            , hash_value
            , version_count
            , cpu_time
            , elapsed_time
            , outline_sid
            , outline_category
            , child_latch
            )
       select l_snap_id
            , p_dbid
            , p_instance_number
            , substrb(sql_text,1,31)
            , sharable_mem
            , sorts
            , module
            , loaded_versions
            , fetches
            , executions
            , loads
            , invalidations
            , parse_calls
            , disk_reads
            , buffer_gets
            , rows_processed
            , command_type
            , address
            , hash_value
            , version_count
            , cpu_time
            , elapsed_time
            , outline_sid
            , outline_category
            , child_latch
         from stats$v$sqlxs
        where is_obsolete = 'N'
          and (   buffer_gets   > l_buffer_gets_th 
               or disk_reads    > l_disk_reads_th
               or parse_calls   > l_parse_calls_th
               or executions    > l_executions_th
               or sharable_mem  > l_sharable_mem_th
               or version_count > l_version_count_th
              );

         /*  Insert the SQL Text for hash_values captured in the snapshot
             into stats$sqltext if it's not already there.  Identify SQL which
             execeeded the threshold by querying stats$sql_summary for this
             snapid and database instance
          */


        while (not (l_insert_done) and l_counter < l_counter_maxvalue) loop
          begin
            insert into stats$sqltext
                 ( hash_value
                 , text_subset
                 , piece
                 , sql_text
                 , address
                 , command_type
                 , last_snap_id
                 )
            select st1.hash_value
                 , ss.text_subset
                 , st1.piece
                 , st1.sql_text
                 , st1.address
                 , st1.command_type
                 , ss.snap_id
              from v$sqltext         st1
                 , stats$sql_summary ss
             where ss.snap_id         = l_snap_id
               and ss.dbid            = p_dbid
               and ss.instance_number = p_instance_number
               and st1.hash_value     = ss.hash_value
               and st1.address        = ss.address
               and not exists (select 1
                                 from stats$sqltext st2
                                where st2.hash_value  = ss.hash_value
                                  and st2.text_subset = ss.text_subset
                              )
             order by st1.hash_value,ss.text_subset; -- deadlock avoidance
            l_insert_done := TRUE;
          exception
            when DUP_VAL_ON_INDEX then
              l_counter := l_counter + 1;
          end;
        end loop;
        l_counter := 0;
        l_insert_done := FALSE;

     IF l_snap_level >= 6 THEN

         /*  Identify SQL which execeeded the threshold by querying 
             stats$sql_summary for this snapid and database instance.

             Note: original algorithm only captured plans the first time a new
             plan appeared.  New algorithm captures each distinct plan usage
             for each high-load sql statements for each snapshot.

             Omit capturing plan usage information for cursors which
             have a zero plan hash value.

             Currently this is captured in a level 6 (or greater)
             snapshot, however this may be integrated into level 5 
             snapshot at a later date.
          */

         insert into stats$sql_plan_usage
              ( snap_id
              , dbid
              , instance_number
              , hash_value
              , text_subset
              , plan_hash_value
              , cost
              , address
              , optimizer
              )
         select /*+ ordered use_nl(sq) index(sq) */
                l_snap_id
              , p_dbid
              , p_instance_number
              , ss.hash_value
              , ss.text_subset
              , sq.plan_hash_value
              , nvl(sq.optimizer_cost,-9)
              , max(ss.address)
              , max(sq.optimizer_mode)
           from stats$sql_summary ss
              , v$sql             sq
          where ss.snap_id         = l_snap_id
            and ss.dbid            = p_dbid
            and ss.instance_number = p_instance_number
            and sq.hash_value      = ss.hash_value
            and sq.address         = ss.address
            and sq.plan_hash_value > 0
          group by l_snap_id
              , p_dbid
              , p_instance_number
              , ss.hash_value
              , ss.text_subset
              , sq.plan_hash_value
              , nvl(sq.optimizer_cost,-9);


         /*  For all new hash_value, plan_hash_value, cost combinations
             just captured, get the optimizer plans, if we don't already
             have them.  Note that the plan (and hence the plan hash value)
             comprises the access path and the join order (and not 
             variable factors such as the cardinality).
          */

         insert into stats$sql_plan
              ( plan_hash_value
              , id
              , operation
              , options
              , object_node
              , object#
              , object_owner
              , object_name
              , optimizer
              , parent_id
              , depth
              , position
              , search_columns
              , cost
              , cardinality
              , bytes
              , other_tag
              , partition_start
              , partition_stop
              , partition_id
              , other
              , distribution
              , cpu_cost
              , io_cost
              , temp_space
              , access_predicates
              , filter_predicates
              , snap_id
              )
         select /*+ ordered use_nl(s) use_nl(sp.p) */
                new_plan.plan_hash_value
              , sp.id
              , max(sp.operation)
              , max(sp.options)
              , max(sp.object_node)
              , max(sp.object#)
              , max(sp.object_owner)
              , max(sp.object_name)
              , max(sp.optimizer)
              , max(sp.parent_id)
              , max(sp.depth)
              , max(sp.position)
              , max(sp.search_columns)
              , max(sp.cost)
              , max(sp.cardinality)
              , max(sp.bytes)
              , max(sp.other_tag)
              , max(sp.partition_start)
              , max(sp.partition_stop)
              , max(sp.partition_id)
              , max(sp.other)
              , max(sp.distribution)
              , max(sp.cpu_cost)
              , max(sp.io_cost)
              , max(sp.temp_space)
              , 0 -- should be max(sp.access_predicates) (2254299)
              , 0 -- should be max(sp.filter_predicates)
              , max(new_plan.snap_id)
           from (select /*+ index(spu) */
                        spu.plan_hash_value
                      , spu.hash_value    hash_value
                      , spu.address       address
                      , spu.text_subset   text_subset
                      , spu.snap_id       snap_id
                   from stats$sql_plan_usage spu
                  where spu.snap_id         = l_snap_id
                    and spu.dbid            = p_dbid
                    and spu.instance_number = p_instance_number
                    and not exists (select /*+ nl_aj */ *
                                      from stats$sql_plan ssp
                                     where ssp.plan_hash_value 
                                         = spu.plan_hash_value
                                   )
                )          new_plan
              , v$sql      s      -- join reqd to filter already known plans
              , v$sql_plan sp
          where s.address         = new_plan.address
            and s.plan_hash_value = new_plan.plan_hash_value
            and s.hash_value      = new_plan.hash_value
            and sp.hash_value     = new_plan.hash_value
            and sp.address        = new_plan.address
            and sp.hash_value     = s.hash_value
            and sp.address        = s.address
            and sp.child_number   = s.child_number
          group by 
                new_plan.plan_hash_value
              , sp.id;

     END IF;   /* snap level >=6 */


   END snap_sql;

  /* ---------------------------------------------------------------- */

   begin /* Function SNAP */

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
       , i_disk_reads_th, i_buffer_gets_th, i_sharable_mem_th
       , i_version_count_th, i_seg_phy_reads_th
       , i_seg_log_reads_th, i_seg_buff_busy_th, i_seg_rowlock_w_th
       , i_seg_itl_waits_th, i_seg_cr_bks_sd_th, i_seg_cu_bks_sd_th
       , i_all_init, i_pin_statspack, i_modify_parameter
       , l_snap_level, l_session_id, l_ucomment, l_num_sql
       , l_executions_th, l_parse_calls_th
       , l_disk_reads_th, l_buffer_gets_th, l_sharable_mem_th
       , l_version_count_th, l_seg_phy_reads_th
       , l_seg_log_reads_th, l_seg_buff_busy_th, l_seg_rowlock_w_th
       , l_seg_itl_waits_th, l_seg_cr_bks_sd_th, l_seg_cu_bks_sd_th
       , l_all_init, l_pin_statspack);

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
 
     /*  The instance has been restarted since the last snapshot */
     if p_new_sga = 0
     then
        begin

          p_new_sga := 1;

          /*  Get the instance startup time, and other characteristics  */

          insert into stats$database_instance
               ( dbid
               , instance_number
               , startup_time
               , snap_id
               , parallel
               , version
               , db_name
               , instance_name
               , host_name
               )
          select p_dbid
               , p_instance_number
               , p_startup_time
               , l_snap_id
               , p_parallel
               , p_version
               , p_name
               , p_instance_name
               , p_host_name
            from sys.dual;

          commit;
          
      end;

     end if; /* new SGA */


    /* Work out the max undo stat time, used for gathering undo stat data */

     select nvl(max(begin_time), to_date('01011900','DDMMYYYY'))
       into l_max_begin_time
       from stats$undostat
      where dbid            = p_dbid
        and instance_number = p_instance_number;


     /*  Save the snapshot characteristics */

     insert into stats$snapshot
          ( snap_id, dbid, instance_number
          , snap_time, startup_time
	  , session_id, snap_level, ucomment
          , executions_th, parse_calls_th, disk_reads_th
          , buffer_gets_th, sharable_mem_th
          , version_count_th, seg_phy_reads_th
          , seg_log_reads_th, seg_buff_busy_th, seg_rowlock_w_th
          , seg_itl_waits_th, seg_cr_bks_sd_th, seg_cu_bks_sd_th
          , serial#, all_init)
     values
          ( l_snap_id, p_dbid, p_instance_number
          , SYSDATE, p_startup_time 
	  , l_session_id, l_snap_level, l_ucomment
          , l_executions_th, l_parse_calls_th, l_disk_reads_th
          , l_buffer_gets_th, l_sharable_mem_th
          , l_version_count_th, l_seg_phy_reads_th
          , l_seg_log_reads_th, l_seg_buff_busy_th, l_seg_rowlock_w_th
          , l_seg_itl_waits_th, l_seg_cr_bks_sd_th, l_seg_cu_bks_sd_th
          , l_serial#, l_all_init);

     /*  Begin gathering statistics */
   
     insert into stats$filestatxs
          ( snap_id
          , dbid
          , instance_number
          , tsname
          , filename
          , phyrds
          , phywrts
          , singleblkrds
          , readtim
          , writetim
          , singleblkrdtim
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
          , singleblkrds
          , readtim
          , writetim
          , singleblkrdtim
          , phyblkrd
          , phyblkwrt
	  , wait_count
	  , time
       from stats$v$filestatxs;

     insert into stats$tempstatxs
          ( snap_id
          , dbid
          , instance_number
          , tsname
          , filename
          , phyrds
          , phywrts
          , singleblkrds
          , readtim
          , writetim
          , singleblkrdtim
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
          , singleblkrds
          , readtim
          , writetim
          , singleblkrdtim
          , phyblkrd
          , phyblkwrt
	  , wait_count
	  , time
       from stats$v$tempstatxs;
   
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
          , block_size
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
          , block_size
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

     if l_all_init = 'FALSE' then
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
            , name
	    , value
            , isdefault
            , ismodified
         from v$system_parameter;
     else
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
         from stats$x$ksppi  i
            , stats$x$ksppsv sv
        where i.indx = sv.indx;
     end if;

     /*  To cater for variable size SGA - insert on each snapshot  */
     insert into stats$sga
          ( snap_id
          , dbid
          , instance_number
          , name
          , value
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , name
          , value
      from v$sga;

     /*  Get current allocation of memory in the SGA  */
     insert into stats$sgastat
          ( snap_id
          , dbid
          , instance_number
          , pool
          , name
          , bytes
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , pool
          , name
          , bytes
       from v$sgastat;
   
     insert into stats$system_event
          ( snap_id
          , dbid
          , instance_number
          , event
          , total_waits
	  , total_timeouts
          , time_waited_micro
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , event
          , total_waits
	  , total_timeouts
          , time_waited_micro
       from v$system_event;

     insert into stats$bg_event_summary
          ( snap_id
          , dbid
          , instance_number
          , event
          , total_waits
          , total_timeouts
          , time_waited_micro
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , e.event
          , sum(e.total_waits)
	  , sum(e.total_timeouts)
          , sum(e.time_waited_micro)
       from v$session_event e
      where e.sid in (select s.sid from v$session s where s.type = 'BACKGROUND')
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

     insert into stats$enqueue_stat
          ( snap_id
          , dbid
          , instance_number
          , eq_type
          , total_req#
          , total_wait#
          , succ_req#
          , failed_req#
          , cum_wait_time
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , eq_type
          , total_req#
          , total_wait#
          , succ_req#
          , failed_req#
          , cum_wait_time
       from v$enqueue_stat
      where total_req# != 0;

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
          , wait_time
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
          , wait_time
       from v$latch;

     insert into stats$latch_misses_summary
          ( snap_id
          , dbid
          , instance_number
          , parent_name
          , where_in_code
          , nwfail_count
          , sleep_count
          , wtr_slp_count
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , parent_name
          , "WHERE"
          , sum(nwfail_count)
          , sum(sleep_count)
          , sum(wtr_slp_count)
       from v$latch_misses
      where sleep_count > 0
      group by l_snap_id, p_dbid, p_instance_number
          , parent_name, "WHERE";

     insert into stats$resource_limit
          ( snap_id
          , dbid
          , instance_number
          , resource_name
          , current_utilization
          , max_utilization
          , initial_allocation
          , limit_value
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , resource_name
          , current_utilization
          , max_utilization
          , initial_allocation
          , limit_value
       from v$resource_limit
      where limit_value != ' UNLIMITED'
        and max_utilization > 0;

      insert into stats$undostat
          ( begin_time
          , end_time
          , dbid
          , instance_number
          , snap_id
          , undotsn
          , undoblks
          , txncount
          , maxquerylen
          , maxconcurrency
          , unxpstealcnt
          , unxpblkrelcnt
          , unxpblkreucnt
          , expstealcnt
          , expblkrelcnt
          , expblkreucnt
          , ssolderrcnt
          , nospaceerrcnt
          )
     select begin_time
          , end_time
          , max(p_dbid)
          , max(p_instance_number)
          , max(l_snap_id)
          , max(undotsn)
          , sum(undoblks)
          , sum(txncount)
          , max(maxquerylen)
          , max(maxconcurrency)
          , sum(unxpstealcnt)
          , sum(unxpblkrelcnt)
          , sum(unxpblkreucnt)
          , sum(expstealcnt)
          , sum(expblkrelcnt)
          , sum(expblkreucnt)
          , sum(ssolderrcnt)
          , sum(nospaceerrcnt)
       from v$undostat
      where begin_time              >  l_max_begin_time
        and begin_time + (1/(24*6)) <= end_time
     group by begin_time, end_time;

     insert into stats$db_cache_advice
          ( snap_id
          , dbid
          , instance_number
          , id
          , name
          , block_size
          , buffers_for_estimate
          , advice_status
          , size_for_estimate
          , size_factor
          , estd_physical_read_factor
          , estd_physical_reads
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , id
          , name
          , block_size
          , buffers_for_estimate
          , advice_status
          , size_for_estimate
          , size_factor
          , estd_physical_read_factor
          , estd_physical_reads
       from v$db_cache_advice
      where advice_status = 'ON';

     insert into stats$shared_pool_advice
          ( snap_id
          , dbid
          , instance_number
          , shared_pool_size_for_estimate
          , shared_pool_size_factor
          , estd_lc_size
          , estd_lc_memory_objects
          , estd_lc_time_saved
          , estd_lc_time_saved_factor
          , estd_lc_memory_object_hits
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , shared_pool_size_for_estimate
          , shared_pool_size_factor
          , estd_lc_size
          , estd_lc_memory_objects
          , estd_lc_time_saved
          , estd_lc_time_saved_factor
          , estd_lc_memory_object_hits
       from v$shared_pool_advice;

     insert into stats$pgastat
          ( snap_id
          , dbid
          , instance_number
          , name
          , value
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , name
          , value
       from v$pgastat
      where value > 0;

     insert into stats$sql_workarea_histogram
          ( snap_id
          , dbid
          , instance_number
          , low_optimal_size
          , high_optimal_size
          , optimal_executions
          , onepass_executions
          , multipasses_executions
          , total_executions
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , low_optimal_size
          , high_optimal_size
          , optimal_executions
          , onepass_executions
          , multipasses_executions
          , total_executions
       from v$sql_workarea_histogram
      where total_executions > 0;

     insert into stats$pga_target_advice
          ( snap_id
          , dbid
          , instance_number
          , pga_target_for_estimate
          , pga_target_factor
          , advice_status
          , bytes_processed
          , estd_extra_bytes_rw
          , estd_pga_cache_hit_percentage
          , estd_overalloc_count
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , pga_target_for_estimate
          , pga_target_factor
          , advice_status
          , bytes_processed
          , estd_extra_bytes_rw
          , estd_pga_cache_hit_percentage
          , estd_overalloc_count
       from v$pga_target_advice
      where advice_status = 'ON';

     insert into stats$instance_recovery
          ( snap_id
          , dbid
          , instance_number
          , recovery_estimated_ios
          , actual_redo_blks
          , target_redo_blks
          , log_file_size_redo_blks
          , log_chkpt_timeout_redo_blks
          , log_chkpt_interval_redo_blks
          , fast_start_io_target_redo_blks
          , target_mttr
          , estimated_mttr
          , ckpt_block_writes
          )
     select l_snap_id
          , p_dbid
          , p_instance_number
          , recovery_estimated_ios
          , actual_redo_blks
          , target_redo_blks
          , log_file_size_redo_blks
          , log_chkpt_timeout_redo_blks
          , log_chkpt_interval_redo_blks
          , fast_start_io_target_redo_blks
          , target_mttr
          , estimated_mttr
          , ckpt_block_writes
       from v$instance_recovery;

     if p_parallel = 'YES' then

       insert into stats$dlm_misc
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
         from v$dlm_misc;

     end if; /* parallel */


     /*  Begin gathering Extended Statistics */

     IF l_snap_level >= 5 THEN

       snap_sql;

     END IF;   /* snap level >=5 */

     IF l_snap_level >= 7 THEN

     /*  Begin gathering Segment Statistics */

        insert into stats$seg_stat
             ( snap_id
             , dbid
             , instance_number
             , ts#
             , obj#
             , dataobj#
             , logical_reads
             , buffer_busy_waits
             , db_block_changes
             , physical_reads
             , physical_writes
             , direct_physical_reads
             , direct_physical_writes
             , global_cache_cr_blocks_served
             , global_cache_cu_blocks_served
             , itl_waits
             , row_lock_waits
             )
        select /*+  ordered use_nl(s1.gv$segstat.X$KSOLSFTS) */
               l_snap_id
             , p_dbid
             , p_instance_number
             , s1.ts#
             , s1.obj#
             , s1.dataobj#
             , sum(decode(s1.statistic#,0,value,0))  -- Logical_reads,
             , sum(decode(s1.statistic#,1,value,0))  -- bb_waits ,
             , sum(decode(s1.statistic#,2,value,0))  -- db_changes,
             , sum(decode(s1.statistic#,3,value,0))  -- ph_reads,
             , sum(decode(s1.statistic#,4,value,0))  -- ph_writes
             , sum(decode(s1.statistic#,5,value,0))  -- dir_ph_reads
             , sum(decode(s1.statistic#,6,value,0))  -- dir_ph_writes
             , sum(decode(s1.statistic#,8,value,0))  -- global_cache_cr_blocks_served
             , sum(decode(s1.statistic#,9,value,0))  -- global_cache_cu_blocks_served
             , sum(decode(s1.statistic#,10,value,0)) -- itl_waits
             , sum(decode(s1.statistic#,11,value,0)) -- row_lock_waits
          from v$segstat s1
         where (s1.dataobj#, s1.obj#) in (
                                 select s2.dataobj#
                                      , s2.obj#
                                   from v$segstat s2
                                  where s2.obj# > 0
                                    and s2.obj# < 4254950912 
                                    and  ( decode(s2.statistic#,0,value,0)  > l_seg_log_reads_th
                                        or decode(s2.statistic#,3,value,0)  > l_seg_phy_reads_th
                                        or decode(s2.statistic#,1,value,0)  > l_seg_buff_busy_th
                                        or decode(s2.statistic#,11,value,0) > l_seg_rowlock_w_th
                                        or decode(s2.statistic#,10,value,0) > l_seg_itl_waits_th
                                        or decode(s2.statistic#,8,value,0)  > l_seg_cr_bks_sd_th
                                        or decode(s2.statistic#,9,value,0)  > l_seg_cu_bks_sd_th
                                         )
                                        )
      group by s1.ts#, s1.obj#, s1.dataobj#;

     /*  Gather Segment Names having statistics captured and avoid ORA-1 */

        while (not (l_insert_done) and l_counter < l_counter_maxvalue) loop 
          begin
            insert into stats$seg_stat_obj
                 ( ts#
                 , obj#
                 , dataobj#
                 , dbid
                 , owner
                 , object_name
                 , subobject_name
                 , object_type
                 , tablespace_name
                 )
            select /*+ ordered index(ss1) */
                   vs.ts#
                 , vs.obj#
                 , vs.dataobj#
                 , p_dbid
                 , vs.owner
                 , vs.object_name
                 , vs.subobject_name
                 , vs.object_type
                 , vs.tablespace_name
              from stats$seg_stat       ss1,
                   v$segment_statistics vs
             where vs.dataobj#         = ss1.dataobj#
               and vs.obj#             = ss1.obj#
               and ss1.snap_id         = l_snap_id
               and ss1.dbid            = p_dbid
               and ss1.instance_number = p_instance_number
               and vs.statistic#       = 0
               and not exists (select 1
                                 from stats$seg_stat_obj ss2
                                where ss2.dataobj# = ss1.dataobj#
                                  and ss2.obj# = ss1.obj#)
             order by dataobj#,obj#,dbid;    -- deadlock avoidance
            l_insert_done := TRUE;
          exception
            when DUP_VAL_ON_INDEX then
              l_counter := l_counter + 1;
          end;
        end loop;
        l_counter := 0;
        l_insert_done := FALSE;

     /*  End gathering Segment Statistics */
             
     END IF;   /* snap level >=7 */


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
              , wait_time
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
              , wait_time
           from v$latch_children;

         insert into stats$latch_parent
              ( snap_id
              , dbid
              , instance_number
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
              , wait_time
              )
         select l_snap_id
              , p_dbid
              , p_instance_number
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
              , wait_time
           from v$latch_parent;

     END IF;  /* snap level >=10 */

   
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
              , time_waited_micro
              , max_wait
              )
       select l_snap_id
              , p_dbid
              , p_instance_number
              , event
              , total_waits
              , total_timeouts
              , time_waited_micro
              , max_wait
           from v$session_event
           where sid = l_session_id;
     end if;

     commit work;

   RETURN l_snap_id;

   end SNAP; /* Function SNAP */

   /* ------------------------------------------------------------------- */

begin  /* STATSPACK body */

  /*  Query the database id, instance_number, database name, instance
      name and startup time for the instance we are working on
  */


  /*  Get information about the current instance  */
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


  /*  Keep the package
  */
  sys.dbms_shared_pool.keep('PERFSTAT.STATSPACK', 'P');


  /*  Determine if the instance has been restarted since the previous snapshot
  */
  begin
     select 1 
       into p_new_sga
       from stats$database_instance
      where startup_time    = p_startup_time
        and dbid            = p_dbid
        and instance_number = p_instance_number;
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
prompt   SPCPKG complete. Please check spcpkg.lis for any errors.
prompt
spool off;
whenever sqlerror continue;
set echo on;
