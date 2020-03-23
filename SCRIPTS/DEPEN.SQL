/*********************************************************************/
/** This Script shows the dependency tree for a given object. **/
/** For tables, it shows the FKs (Foreign Keys that reference **/
/** the table. **/
/** NOTE: the user must have grant select on: **/
/** sys.cdef$, sys.obj$, sys.con$, sys.dependecy$ **/
/** It may be necessary to reduce ARRAYSIZE or increase MAXDATA **/
/*********************************************************************/
undef ObjName
accept ObjName prompt "Object Name ? "

column a heading "Object|Name" justify center format a35
column b heading "Constraint|Name" justify center format a35

select lpad(' ',(a.nivel-1)*2)||obj.name a,
lpad(' ',(a.nivel-1)*2)||cons.name b
from sys.obj$ obj,
sys.con$ cons,
(
select obj# obj#,
con#,
level nivel
from sys.cdef$
where rcon# is not null AND
robj# is not null
connect by robj# = prior obj# and
robj# != obj# and
prior robj# != prior obj#
start with robj# = (select obj#
from sys.obj$
where name = upper('&&ObjName') AND
type = 2 AND
owner# = userenv('SCHEMAID'))) a
where cons.con# = a.con# AND
obj.obj# = a.obj# AND
obj.type = 2
UNION ALL
select lpad(' ',(a.nivel-1)*2)||obj.name a,
to_char(null)
from sys.obj$ obj,
(
select d_obj# obj#,
level nivel
from sys.dependency$
connect by p_obj# = prior d_obj#
start with p_obj# = (select obj#
from sys.obj$
where name = upper('&&ObjName') AND
owner# = userenv('SCHEMAID'))) a
where obj.obj# = a.obj# AND
obj.type != 2
/ 
