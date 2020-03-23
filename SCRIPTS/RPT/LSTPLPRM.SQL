REM lstplprm.sql checked out on 12/22/97 17:05:21 version 1.1 created on 8/27/97 13:08:38
set termout off
REM ---- Enter the Owner of package/function/procedure or wildcard to match:%
define owner = '&1'

REM ---- Enter the package/function/procedure name or wildcard to match:%
define pkg_name = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Enter object type ( 1 => package, 2 => function, 3 => procedure)  or wildcard to match:%
define ob_type = '&4'

REM ---- Enter the Procedure/Function name or wildcard to match:%
define proc_name = '&5'

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Var '&7' not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Adam Levine
rem Copyright 1997 by the DataBase Group, Inc.
rem

start &tool_home/pformat
start &tool_home/rptvars

ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Parameter Listing for Owner like &owner and Name like &pkg_name' skip 1 -
center 'Package/Function/Procedure: &ob_type' skip 1 -
center '(D -> Has a Default value)' skip 2

btitle center 'Report: lstparms'

column ob_like_txt new_value ob_like_txt noprint
select
decode('&ob_type', '1', '= ''PACKAGE''', 
                '2', '= ''FUNCTION''', 
								'3', '= ''PROCEDURE''', 
								'%', 'in (''PACKAGE'',''FUNCTION'',''PROCEDURE'')') ob_like_txt
from dual;

set termout on
prompt
prompt ******** Running Package/Function/Procedure Parameter Report
prompt for owner like:                             &owner
prompt and Package/Function/Procedure name like:   &pkg_name
prompt and Procedure/Function name like:           &proc_name
prompt and object type                             &ob_like_txt
prompt
set termout off

set feedback off
set verify off

break on name2 on overload# skip 1 on proc skip 1

column name2 heading 'Owner.Object' format a36
column ob_type heading 'Type' format a9
column name heading 'Object Name' format a30
column proc heading 'Name' format a30
column arg heading 'Param Name' format a22
column ar_type heading 'Type' format a23
column def heading 'D' format a1 
column inout heading 'IN/OUT' format a6
column owner noprint
column object_type noprint
column object_name noprint
column position noprint
column argument noprint
column overload# noprint

spool &output_file

select ob.owner, ob.object_type, ob.object_name, ar.argument, ar.overload#, ar.position,
     ob.owner||'.'||ob.object_name||' ('||ob.object_type||')' name2,
     ar.procedure$ proc, 
     decode(ar.position, 0, '(returned value->> )', ar.argument) arg, 
     decode(ar.type, 0, 'No Parms', 
     1,'VARCHAR2'||decode(nvl(ar.length,-1), -1, '', '('||ar.length||')'),
     2, 'NUMBER'||decode(nvl(ar.precision,-1),-1, '', '('||ar.precision)||
                  decode(nvl(ar.scale, -1),-1, decode(nvl(ar.precision,-1), -1, '', ')'), ','||ar.scale||')'), 
     3, 'BINARY INT',
     8, 'LONG', 11, 'ROWID', 12, 'DATE', 23, 'RAW', 24, 'LONG RAW',
     96, 'CHAR', 106, 'MLSLABEL', 250, 'PL/SQL RECORD', 
     251, 'TABLE OF', 252, 'PL/SQL BOOLEAN')||
     decode(ar2.type, 0, 'No Parms', 
     1,' VARCHAR2'||decode(nvl(ar.length,-1), -1, '', '('||ar.length||')'),
     2, ' NUMBER'||decode(nvl(ar.precision,-1),-1, '', '('||ar.precision)||
                  decode(nvl(ar.scale, -1),-1, decode(nvl(ar.precision,-1), -1, '', ')'), ','||ar.scale||')'), 
     3, ' BINARY INT',
     8, ' LONG', 11, ' ROWID', 12, ' DATE', 23, ' RAW', 24, ' LONG RAW',
     96, '  CHAR', 106, ' MLSLABEL', 250, ' PL/SQL RECORD', 
     251, ' TABLE OF', 252, ' PL/SQL BOOLEAN') ar_type,
     decode(ar.default#, 1, 'Y', 0, 'N') def, 
     decode(ar.in_out, 0, 'IN', 1, 'OUT', 2, 'IN/OUT', 'IN') inout
from
     all_objects ob, sys.argument$ ar
	, sys.argument$ ar2 
where
     ob.owner like upper('&owner')
 and ob.object_name like upper('&pkg_name')
 and ar.procedure$ like upper('&proc_name')
 and ob.object_type &ob_like_txt
 and ar.obj# = ob.object_id
 and ar2.obj#   = ar.obj#  
 and ar2.procedure$  = ar.procedure$  
 and ar2.overload#  = ar.overload#  
 and ar.sequence#   = ar2.sequence# -1 
 and ar2.level# = 1  
 and ar2.position = 1
 and ar2.argument  is NULL  
UNION 
select ob.owner, ob.object_type, ob.object_name, ar.argument, ar.overload#, ar.position,
     ob.owner||'.'||ob.object_name||' ('||ob.object_type||')' name2,
     ar.procedure$ proc, 
     decode(ar.position, 0, '(returned value->> )', ar.argument) arg, 
     decode(ar.type, 0, 'No Parms', 
     1,'VARCHAR2'||decode(nvl(ar.length,-1), -1, '', '('||ar.length||')'),
     2, 'NUMBER'||decode(nvl(ar.precision,-1),-1, '', '('||ar.precision)||
                  decode(nvl(ar.scale, -1),-1, decode(nvl(ar.precision,-1), -1, '', ')'), ','||ar.scale||')'), 
     3, 'BINARY INT',
     8, 'LONG', 11, 'ROWID', 12, 'DATE', 23, 'RAW', 24, 'LONG RAW',
     96, 'CHAR', 106, 'MLSLABEL', 250, 'PL/SQL RECORD', 
     251, 'PL/SQL TABLE', 252, 'PL/SQL BOOLEAN') ar_type,
     decode(ar.default#, 1, 'Y', 0, 'N') def, 
     decode(ar.in_out, 0, 'IN', 1, 'OUT', 2, 'IN/OUT', 'IN') inout
from
     all_objects ob, sys.argument$ ar
where
     ob.owner like upper('&owner')
 and ob.object_name like upper('&pkg_name')
 and ar.procedure$ like upper('&proc_name')
 and ob.object_type &ob_like_txt
 and ar.obj# = ob.object_id
 and ar.level# = 0
 and not exists 
  (select null from sys.argument$ ar2
    where ar2.obj# = ar.obj#
      and ar2.procedure$  = ar.procedure$
      and ar2.overload#  = ar.overload#
      and ar.sequence#  = ar2.sequence# -1
      and ar2.level# = 1
      and ar2.position = 1
      and ar2.argument  is NULL ) 
order by 1,2,3,8,5,6;


spool off
start &tool_home/ppcmd
exit
