-- The columns in uppercase are relevant to Oracle9i Database. 
-- Oracle Database 10g Release 1 has eight additional columns and it 
-- also contains the child cursor address and number.
select a.*, b.hash_value, b.sql_text
from   v$sql_shared_cursor a, v$sqltext b, x$kglcursor c
where  a.unbound_cursor         || a.sql_type_mismatch     ||
       a.optimizer_mismatch     || a.outline_mismatch      ||
       a.stats_row_mismatch     || a.literal_mismatch      ||
       a.sec_depth_mismatch     || a.explain_plan_cursor   ||
       a.buffered_dml_mismatch  || a.pdml_env_mismatch     ||
       a.inst_drtld_mismatch    || a.slave_qc_mismatch     ||
       a.typecheck_mismatch     || a.auth_check_mismatch   ||
       a.bind_mismatch          || a.describe_mismatch     ||
       a.language_mismatch      || a.translation_mismatch  ||
       a.row_level_sec_mismatch || a.insuff_privs          ||
       a.insuff_privs_rem       || a.remote_trans_mismatch ||
       a.LOGMINER_SESSION_MISMATCH || a.INCOMP_LTRL_MISMATCH    ||
       a.OVERLAP_TIME_MISMATCH     || a.sql_redirect_mismatch   ||
       a.mv_query_gen_mismatch     || a.USER_BIND_PEEK_MISMATCH ||
       a.TYPCHK_DEP_MISMATCH       || a.NO_TRIGGER_MISMATCH     ||
       a.FLASHBACK_CURSOR <> 'NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN'
and    a.address = c.kglhdadr
and    b.hash_value = c.kglnahsh
order by b.hash_value, b.piece;
