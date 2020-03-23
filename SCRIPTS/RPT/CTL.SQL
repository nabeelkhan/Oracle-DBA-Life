REM ctl.sql checked out on 10/25/96 17:05:12 version 1.4
set heading off
set feedback off
set verify off
set embedded on
set pagesize 0
set linesize 125
set space 0
set wrap off
set linesize 90
column nulls format a18
column buff fold_after 1
column commts WORD_WRAPPED

select
'--/*--------------------------------------------------------------------------------' buff,
'--|' buff,
'--|   File Name     : &file_prefix'||lower(substr('&1',6))||'.ctl' buff,
'--|   Description   : Provides the SQLLOADER control file to read data from a file and' buff, 
'--|                   insert it into the database table' buff,
'--|		        &1' buff,
'--|   Author        : Marc E. Marchioli' buff,
'--|   Version       : @(#)ctl.sql	1.1' buff,
'--|   Date          : '||SYSDATE buff,
'--|   ' buff,
'--|   Revision History:' buff,
'--|   ' buff,
'--|   Author      Date    Comments/Description' buff,
'--| -----------  ------  ----------------------------------------------------------' buff,
'--| ME Marchioli '||to_char(sysdate,'DDMonYY')||' Generated automatically from data dictionary for database' buff,
'--| ' buff,
'--| ' buff,
'--|-----------------------------------------------------------------------------*/' buff
from dual;
select 
'LOAD DATA' buff,
'APPEND' buff,
'INTO TABLE &1' buff,
'FIELDS TERMINATED BY '' '' OPTIONALLY ENCLOSED BY '' ''' buff,
'     ('
from dual;
select
'     '||rpad(ac.column_name,32,' ')||
decode(data_type,'VARCHAR2',lpad('CHAR ENCLOSED BY  ''"'',',25,' '),
		 'CHAR',lpad('CHAR ENCLOSED BY  ''"'',',25,' '),
		 'LONG',lpad('CHAR ENCLOSED BY  ''"'',',25,' '),
		 'NUMBER',decode(substr(ac.column_name,length(ac.column_name)-3),
			  '_EID',lpad('SEQUENCE(MAX,1),',25,' '),
			  'N_ID',lpad('CONSTANT 1,',25,' '),
			  decode(data_scale,'0',lpad('INTEGER EXTERNAL,',25,' '),lpad('DECIMAL EXTERNAL,',25,' '))),
		 'DATE',decode(substr(ac.column_name,length(ac.column_name)-4),
				'_TMST',lpad('DATE   ''YYYYMMDDHH24MISS'',',25,' '),
				lpad('DATE,',25,','))) buff
from all_tab_columns ac,all_col_comments alcom
where ac.table_name like upper('&1')
and   ac.table_name = alcom.table_name
and   ac.column_name = alcom.column_name
and   ac.owner = alcom.owner
and   ac.owner like upper('&owner')
order by column_id;
select
'     )'
from dual;

set heading on
set feedback on
set space 1
