-- Set TIME_STATISTICS to TRUE for SID 1234, Serial# 56789

exec sys.dbms_system.set_bool_param_in_session( -
     sid => 1234, -
     serial# => 56789, -
     parnam => ‘TIMED_STATISTICS’, -
     bval => true);
-- Set MAX_DUMP_FILE_SIZE to 2147483647
-- for SID 1234, Serial# 56789
exec sys.dbms_system.set_int_param_in_session( -
     sid => 1234, -
     serial# => 56789, -
     parnam => ‘MAX_DUMP_FILE_SIZE’, -
     intval => 2147483647);




