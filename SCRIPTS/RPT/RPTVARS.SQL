REM rptvars.sql checked out on 7/23/97 17:05:16 version 1.4
WHENEVER OSERROR EXIT SQL.OSCODE
column nowdate new_value jobdate noprint
column nowtime new_value jobtime noprint
column blksize new_value blocksize noprint

define plp=rlp132p
define llp=rlp132l

rem **** Variable dependent on ORACLE and possible versions
rem **** Table overhead sizes
rem ****  all are in bytes!
define tab_fixed_header=57
define tab_variable_header=23
define tab_row_header=3
define tab_table_directory=4
define tab_row_directory=2
 
 rem **** Index overhead sizes
 rem ****  all are in bytes!
 define ind_fixed_header=113
 define ind_variable_header=23
 define ind_entry_header=2
 define ind_rowid_length=6


select to_char(sysdate,'Month DD, YYYY') nowdate,
       to_char(sysdate,'  HH:MI PM') nowtime
from dual;

select value blksize
from v$parameter
where name = 'db_block_size';

