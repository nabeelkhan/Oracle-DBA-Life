[InstantScripts]
Node0Directory=
[Nodes]
F^InstantScripts^welcome.txt
	F^SetUp
		R^Issue SYS Grants Required^7.3.3.5, 8.0.4.1, 8.1.5^grants.sql
		R^Create Required Views and Tables^7.3.3.5, 8.0.4.1, 8.1.5^Crea_tab.sql
		R^Build a Standard 80 column Report Heading^7.3.3.5, 8.0.4.1, 8.1.5^Title80.sql
		R^Build a Standard 132 column Report Heading^7.3.3.5, 8.0.4.1, 8.1.5^title132.sql
	F^Object Management
		F^Database Reports
			R^"Bad" objects^7.3.3.5, 8.0.4.1, 8.1.5^o_cache2.sql
			R^All invalid objects in database^7.3.3.5, 8.0.4.1, 8.1.5^inv_obj.sql
			R^All objects^7.3.3.5, 8.0.4.1, 8.1.5^db_obj.sql
			R^Directories known by the database^7.3.3.5, 8.0.4.1, 8.1.5^dir_rep.sql
			R^External library entries in the database^7.3.3.5, 8.0.4.1, 8.1.5^lib_rep.sql
			R^Object creation and modification dates^7.3.3.5, 8.0.4.1, 8.1.5^object.sql
		F^Tablespaces and Datafiles
			F^Utilities
				R^Alter multiple user's tablespace assignments^7.3.3.5, 8.0.4.1, 8.1.5^Alt_user.sql
				R^Defragment tablespace^7.3.3.5, 8.0.4.1, 8.1.5^defrag.sql
			F^Reports 
				R^Extent map for a specific tablespace^7.3.3.5, 8.0.4.1, 8.1.5^mapper.sql
				R^File sizes and locations^7.3.3.5, 8.0.4.1, 8.1.5^datafile.sql
				R^File storage statistics^7.3.3.5, 8.0.4.1, 8.1.5^file_sta.sql
				R^Objects with Extents Bounded by Freespace^ 7.3.3.5, 8.0.4.1, 8.1.5^Bound_ob.sql
				R^Tablespace defaults^7.3.3.5, 8.0.4.1, 8.1.5^db_tblsp.sql
				R^Tablespace extent status^7.3.3.5, 8.0.4.1, 8.1.5^free_sp2.sql
				R^Tablespace extents^7.3.3.5, 8.0.4.1, 8.1.5^db_ext.sql
				R^Tablespace freespace^7.3.3.5, 8.0.4.1, 8.1.5^db_fspc.sql
				R^Tablespace map^7.3.3.5, 8.0.4.1, 8.1.5^ts_map.sql
		F^Tables
			F^Utilities
				R^Calculate table average row size^7.3.3.5, 8.0.4.1, 8.1.5^rowsize.sql
			F^Reports
				R^Column definitions^7.3.3.5, 8.0.4.1, 8.1.5^tab_col.sql
				R^Execute SPACE Procedure^7.3.3.5, 8.0.4.1, 8.1.5^space_rp.sql
				R^Identify chained rows for a specific table^7.3.3.5, 8.0.4.1, 8.1.5^chaining.sql
				R^Identify chained rows for all of a specified user's tables^7.3.3.5, 8.0.4.1, 8.1.5^AUTO_CHN.sql
				R^Nested tables^7.3.3.5, 8.0.4.1, 8.1.5^tab_nest.sql
				R^Partitioned table storage characteristics^7.3.3.5, 8.0.4.1, 8.1.5^tab_psto.sql
				R^Partitioned table structure^7.3.3.5, 8.0.4.1, 8.1.5^tab_part.sql
				R^Statistics - Oracle7^7.3.3.5^db_tbl7.sql
				R^Statistics - Oracle8^8.0.4.1, 8.1.5^db_tbl8.sql
				R^Table comments^7.3.3.5, 8.0.4.1, 8.1.5^getcom.sql
				R^Table extended parameters^7.3.3.5, 8.0.4.1, 8.1.5^tab_rep.sql
				R^Table partition keys^7.3.3.5, 8.0.4.1, 8.1.5^tab_pkey.sql
				R^Table size - actual for Oracle7^7.3.3.5^act_siz7.sql
				R^Table size - actual for Oracle8^8.0.4.1, 8.1.5^act_siz8.sql
				R^Table space usage^7.3.3.5, 8.0.4.1, 8.1.5^Space.sql
				R^Table statistics^7.3.3.5, 8.0.4.1, 8.1.5^tab_stat.sql
		F^View Reports
			R^Column definitions^7.3.3.5, 8.0.4.1, 8.1.5^tab_col.sql
			R^Statistics - Oracle7^7.3.3.5, 8.0.4.1, 8.1.5^db_view7.sql
			R^Statistics - Oracle8^7.3.3.5, 8.0.4.1, 8.1.5^db_view8.sql
		F^Indexes
			F^Utilities
				R^Calculate index average length^7.3.3.5, 8.0.4.1, 8.1.5^in_cm_sz.sql
				R^Calculate index space requirements^7.3.3.5, 8.0.4.1, 8.1.5^in_es_sz.sql
			F^Reports
				R^Columns^7.3.3.5, 8.0.4.1, 8.1.5^db_inx.sql
				R^Foreign keys that do not have an index on the child table^7.3.3.5, 8.0.4.1, 8.1.5^fkeys.sql
				R^Foreign keys^7.3.3.5, 8.0.4.1, 8.1.5^fkeylist.sql
				R^Index browning^7.3.3.5, 8.0.4.1, 8.1.5^Brown.sql
				R^Partitioned index storage characteristics^7.3.3.5, 8.0.4.1, 8.1.5^ind_psto.sql
				R^Partitioned index structure^7.3.3.5, 8.0.4.1, 8.1.5^ind_part.sql
				R^primary keys other than those owned by SYS and SYSTEM^7.3.3.5, 8.0.4.1, 8.1.5^pkey.sql
				R^Primary/foreign key relationships^7.3.3.5, 8.0.4.1, 8.1.5^pk_fk.sql
				R^Statistics - Oracle7^7.3.3.5, 8.0.4.1, 8.1.5^in_stat7.sql
				R^Statistics - Oracle8^7.3.3.5, 8.0.4.1, 8.1.5^in_stat8.sql
		F^Cluster Reports
			R^Cluster sizing^7.3.3.5, 8.0.4.1, 8.1.5^clus_siz.sql
			R^Cluster types^7.3.3.5, 8.0.4.1, 8.1.5^clu_typ.sql
			R^Statistics^7.3.3.5, 8.0.4.1, 8.1.5^db_clus.sql
		F^Snapshot and Snapshot Log Reports
			R^Snapshot log statistics^7.3.3.5, 8.0.4.1, 8.1.5^db_snplo.sql
			R^Snapshot statistics^7.3.3.5, 8.0.4.1, 8.1.5^db_snp.sql
		F^Functions, Procedures, and Packages
			F^Reports
				R^Objects that need recompiling ^7.3.3.5, 8.0.4.1, 8.1.5^Hanging.sql
				R^Stored code^7.3.3.5, 8.0.4.1, 8.1.5^proc_rep.sql
				R^Stored procedure list^7.3.3.5, 8.0.4.1, 8.1.5^st_proc.sql
		F^Trigger Reports
			R^Trigger Statistics^7.3.3.5, 8.0.4.1, 8.1.5^db_trig.sql
		F^Database Link Reports
			R^Database link statistics^7.3.3.5, 8.0.4.1, 8.1.5^db_links.sql
		F^Synonym Reports
			R^User synonym statistics^7.3.3.5, 8.0.4.1, 8.1.5^synonym.sql
		F^Rollback Segment Reports
			R^Rollback segment statistics^7.3.3.5, 8.0.4.1, 8.1.5^rbk2.sql
			R^Rollback segment storage^7.3.3.5, 8.0.4.1, 8.1.5^rbk1.sql
			R^Rollback segment storage parameters^7.3.3.5, 8.0.4.1, 8.1.5^db_rbks.sql
		F^Sequence Reports
			R^Sequence statistics^7.3.3.5, 8.0.4.1, 8.1.5^db_seqs.sql
		F^Redo Log Reports
			R^Redo log physical files^7.3.3.5, 8.0.4.1, 8.1.5^db_logs.sql
			R^Redo log threads^7.3.3.5, 8.0.4.1, 8.1.5^db_thrd.sql
		F^Collection Reports
			R^Collection types^7.3.3.5, 8.0.4.1, 8.1.5^col_type.sql
			R^Database types^7.3.3.5, 8.0.4.1, 8.1.5^types.sql
			R^REF columns in the database^7.3.3.5, 8.0.4.1, 8.1.5^tab_ref.sql
			R^Type methods^7.3.3.5, 8.0.4.1, 8.1.5^typ_meth.sql
	F^Backup & Recovery
		F^Hot Backup
			R^Hot UNIX Backup^ ^unix_bu.sql
			R^Hot VMS backup^7.3.3.5, 8.0.4.1, 8.1.5^vms_bu.sql
		F^Utilities
			R^Export from Database on Remote Server^8.0^rem_exp.sql
			R^Perform Tablespace Level Exports^ ^tbsp_exp.sql
		F^Reports 
			R^Datafile archive status^7.3.3.5, 8.0.4.1, 8.1.5^backup.sql
			R^Database parameters^7.3.3.5, 8.0.4.1, 8.1.5^db_parm.sql
	F^Application Tuning
		F^Utilities 
			R^Create a compile list for invalid objects^ 7.3.3.5^Com_proc.sql
			R^Format Explain Plan Outputs^7.3.3.5, 8.0.4.1, 8.1.5^plan.sql
		F^Reports
			R^Chained rows^7.3.3.5, 8.0.4.1, 8.1.5^chaining.sql
			R^Index statistics - Oracle7^7.3.3.5, 8.0.4.1, 8.1.5^in_stat7.sql
			R^Index statistics - Oracle8^7.3.3.5, 8.0.4.1, 8.1.5^in_stat8.sql
			R^Session memory usage^7.3.3.5, 8.0.4.1, 8.1.5^mem.sql
			R^SQL area disk reads^7.3.3.5, 8.0.4.1, 8.1.5^sqldrd.sql
			R^SQL area memory usage^7.3.3.5, 8.0.4.1, 8.1.5^sqlmem.sql
			R^SQL area memory user usage^7.3.3.5, 8.0.4.1, 8.1.5^sqlsum.sql
			R^Statistics used by Cost Base Optimizer^7.3.3.5, 8.0.4.1, 8.1.5^cbo_stats.sql
			R^Stored object statistics^7.3.3.5, 8.0.4.1, 8.1.5^o_cache.sql
	F^Database Tuning
		F^Database-level Reports
			R^Run various database Health Scripts^7.3.3.5, 8.0.4.1, 8.1.5^status.sql 
		F^Contention Reports
			R^Contention for resources in Buffer Busy Waits^7.3.3.5, 8.0.4.^Contend.sql
			R^Current internal locks^7.3.3.5, 8.0.4.1, 8.1.5^int_lock.sql
			R^Database locks^7.3.3.5, 8.0.4.1, 8.1.5^db_locks.sql
			R^Latch contention^7.3.3.5, 8.0.4.1, 8.1.5^latch_co.sql
		F^File I/O Reports
			R^File IO efficiencies^7.3.3.5, 8.0.4.1, 8.1.5^File_eff.sql 
			R^Full table scans^7.3.3.5, 8.0.4.1, 8.1.5^fullscan.sql
			R^Non-index lookup ratios^7.3.3.5, 8.0.4.1, 8.1.5^ni_lookup.sql 
			R^Tablespace extents^7.3.3.5, 8.0.4.1, 8.1.5^db_ext.sql
		F^Rollback Segment Reports
			R^Rollback segment statistics^7.3.3.5, 8.0.4.1, 8.1.5^rbk2.sql
			R^Rollback segment storage^7.3.3.5, 8.0.4.1, 8.1.5^rbk1.sql
		F^Redo Log Reports
			R^Monitor redo logs^7.3.3.5, 8.0.4.1, 8.1.5^rdo_stat.sql
			R^Redo log history - Oracle7^7.3.3.5, 8.0.4.1, 8.1.5^logs7.sql
			R^Redo log history - Oracle8^7.3.3.5, 8.0.4.1, 8.1.5^logs8.sql
		F^Shared Pool Reports
			R^Count open cursors per user^7.3.3.5, 8.0.4.1, 8.1.5^open_cur.sql
			R^Data Dictionary cache condition^7.3.3.5, 8.0.4.1, 8.1.5^dd_cache.sql
			R^Estimates shared pool utilization^7.3.3.5, 8.0.4.1, 8.1.5^Shared_p.sql
			R^Library cache^7.3.3.5, 8.0.4.1, 8.1.5^libcache.sql
			R^Shared pool flushes^7.3.3.5, 8.0.4.1, 8.1.5^flush_rep.sql
			R^Shared SQL Utilization^7.3.3.5, 8.0.4.1, 8.1.5^sql_garbage.sql
			R^v$rowcache table statistics^7.3.3.5, 8.0.4.1, 8.1.5^ddcache.sql
		F^Buffer Cache Reports
			R^Buffer cache decrement^7.3.3.5, 8.0.4.1, 8.1.5^sga_dec.sql
			R^Buffer cache hit ratio summary^7.3.3.5, 8.0.4.1, 8.1.5^ratiosum.sql
			R^Buffer cache hit ratios (graph)^7.3.3.5, 8.0.4.1, 8.1.5^hratio2.sql
			R^Buffer cache hit ratios between two dates^7.3.3.5, 8.0.4.1, 8.1.5^hrsumm.sql
			R^Buffer cache hit ratios^7.3.3.5, 8.0.4.1, 8.1.5^hratio.sql
		F^Disk Sort Reports
			R^Disk sort activities^7.3.3.5, 8.0.4.1, 8.1.5^sorts_disk.sql 
			R^Disk to memory sorts percent^7.3.3.5, 8.0.4.1, 8.1.5^disk_mem.sql
	F^Security Administration
		F^Utilities
			R^Drop a user's objects^7.3.3.5, 8.0.4.1, 8.1.5^rm_us.sql
			R^Kill a non-essential Oracle sessions^7.3.3.5, 8.0.4.1, 8.1.5^Ora_kill.sql
			R^Kill a session^7.3.3.5, 8.0.4.1, 8.1.5^Kill_ses.sql
		F^Reports
			R^Grants - Oracle7^7.3.3.5, 8.0.4.1, 8.1.5^grants7.sql
			R^Grants - Oracle8^7.3.3.5, 8.0.4.1, 8.1.5^grants8.sql
			R^Quotas^7.3.3.5, 8.0.4.1, 8.1.5^tsquota.sql
			R^Roles^7.3.3.5, 8.0.4.1, 8.1.5^db_role.sql
			R^Session events by user^7.3.3.5, 8.0.4.1, 8.1.5^Events.sql
			R^Table grants^7.3.3.5, 8.0.4.1, 8.1.5^db_tgnts.sql
			R^Table or procedure grants^7.3.3.5, 8.0.4.1, 8.1.5^db_tgrnt.sql
			R^User login time^7.3.3.5, 8.0.4.1, 8.1.5^login_tm.sql
			R^User profiles^7.3.3.5, 8.0.4.1, 8.1.5^db_prof.sql
			R^User statistics - Oracle7^7.3.3.5, 8.0.4.1, 8.1.5^db_user7.sql
			R^User statistics - Oracle8^7.3.3.5, 8.0.4.1, 8.1.5^db_user8.sql
			R^Users of full table scans^7.3.3.5, 8.0.4.1, 8.1.5^fullscan.sql
			R^Users with SYSTEM ADMINISTRATOR privileges for Oracle Applications^8.0.4.1, 8.1.5^oa_sys.sql
	F^System Monitoring
		F^Utilities
			R^Count open cursors per user^7.3.3.5, 8.0.4.1, 8.1.5^open_cur.sql
			R^Examine x$KCBRBH table to see if SGA needs to expand ^7.3.3.5, 8.0.4.1, 8.1.5^Sga_inc.sql
			R^Flush Shared Pool Memory^ 7.3.3.5, 8.0.4.1, 8.1.5^flush_it.sql
			R^K-Shell report menu^7.3.3.5, 8.0.4.1, 8.1.5^report_m.shl
			R^Load data buffer data^7.3.3.5, 8.0.4.1, 8.1.5^ld_data.sql
			R^Loads table stats and analyzes all tables^7.3.3.5, 8.0.4.1, 8.1.5^Do_stat.sql
			R^Query X$KCBCBH with the intent to shrink the SGA ^ 7.3.3.5, 8.0.4.1, 8.1.5^Sga_dec.sql
			R^Run a set of scripts to report system status^7.3.3.5, 8.0.4.1, 8.1.5^status.sql
		F^Reports
			R^Active Users^7.3.3.5, 8.0.4.1, 8.1.5^cur_user.sql
			R^All processes causing a deadlock^7.3.3.5, 8.0.4.1, 8.1.5^Blockers.sql
			R^Average lengths of full table scans by user^7.3.3.5, 8.0.4.1, 8.1.5^fscanavg.sql
			R^Blocking User Sessions and Waiting User Sessions^ 7.3.3.5, 8.0.4.1, 8.1.5^lockhldr.sql
			R^Current internal locks^ 7.3.3.5, 8.0.4.1, 8.1.5^Int_lock.sql
			R^Current Oracle sids/pids^ 7.3.3.5, 8.0.4.1, 8.1.5^PID.sql
			R^Database parameters^7.3.3.5, 8.0.4.1, 8.1.5^db_parm.sql
			R^Ddisk activity^7.3.3.5, 8.0.4.1, 8.1.5^file_eff.sql
			R^DDL locks currently in use^7.3.3.5, 8.0.4.1, 8.1.5^Ddl_lock.sql
			R^Disk to memory sorts percent^7.3.3.5, 8.0.4.1, 8.1.5^disk_mem.sql
			R^DML locks currently in use^ 8.0.4.1, 8.1.5^Dml_lock.sql
			R^File I/O status of all datafiles in database^7.3.3.5, 8.0.4.1, 8.1.5^fileio.sql
			R^Lock type being held^7.3.3.5, 8.0.4.1, 8.1.5^tranlock.sql
			R^Locks held by all users^7.3.3.5, 8.0.4.1, 8.1.5^lockall.sql
			R^MTS average wait time per request^7.3.3.5, 8.0.4.1, 8.1.5^mts_awt.sql
			R^MTS average wait time per response^7.3.3.5, 8.0.4.1, 8.1.5^protwt.sql
			R^MTS dispatcher percent busy^7.3.3.5, 8.0.4.1, 8.1.5^mts_disp.sql
			R^MTS dispatcher wait time^7.3.3.5, 8.0.4.1, 8.1.5^mts_wait.sql
			R^Non-sys owned tables in SYSTEM tablespace^ 7.3.3.5, 8.0.4.1, 8.1.5^nonsys.sql
			R^Objects and users involved in a blocking situation^ 7.3.3.5, 8.0.4.1, 8.1.5^locksql.sql
			R^Objects waiting due to disk I/O^7.3.3.5, 8.0.4.1, 8.1.5^objwait.sql
			R^Operating system process id for each session^7.3.3.5, 8.0.4.1, 8.1.5^lockproc.sql
			R^Redo log current status^7.3.3.5, 8.0.4.1, 8.1.5^log_stat.sql
			R^Redo log group^7.3.3.5, 8.0.4.1, 8.1.5^redo_grp.sql
			R^Redo log statistics^7.3.3.5, 8.0.4.1, 8.1.5^redostat.sql
			R^Redo logs since last switch^7.3.3.5, 8.0.4.1, 8.1.5^log_swch.sql
			R^Rollbacks - active^7.3.3.5, 8.0.4.1, 8.1.5^tx_rbs.sql
			R^Rollback waits^7.3.3.5, 8.0.4.1, 8.1.5^rbk_wait.sql
			R^Sessions waiting for locks^7.3.3.5, 8.0.4.1, 8.1.5^Waiters.sql
			R^SGA components^7.3.3.5, 8.0.4.1, 8.1.5^sgastat.sql
			R^Sids/pids^7.3.3.5, 8.0.4.1, 8.1.5^pid.sql
			R^Spread of disk I/Os^7.3.3.5, 8.0.4.1, 8.1.5^diskperc.sql
			R^Undocumented Init.ora parameters^ 7.3.3.5, 8.0.4.1, 8.1.5^undoc.sql
			R^User SID, PID, and user name^7.3.3.5, 8.0.4.1, 8.1.5^osuser.sql
			R^Wait time for dispatchers^7.3.3.5, 8.0.4.1, 8.1.5^mts_wait.sql
			R^Write Batch Size^ 7.3.3.5, 8.0.4.1, 8.1.5^Wbs.sql
	F^Data Replication Reports
		R^Snapshot log statistics^7.3.3.5, 8.0.4.1, 8.1.5^db_snplo.sql
		R^Snapshot statistics^7.3.3.5, 8.0.4.1, 8.1.5^db_snp.sql
