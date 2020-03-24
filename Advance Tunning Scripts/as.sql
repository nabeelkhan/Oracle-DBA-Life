-------------------------------------------------------------------------------
--
-- Script:	as.sql
-- Purpose:	to execute a statement (normally a grant) as another user
--
-- Synopsis:	@as &Owner 'grant execute on &Object to public'
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Nabeel Khan
--
-- Notes:	termout is not set/unset, as this is for use by other scripts
--
--		To embed a quote in the SQL statement, it is necessary to use
--		four consecutive quotes. This is because quote interpretation
--		occurs twice - once on the @as command line; and once for the
--		exec call.
--
--		Of course, the user on whose behalf you are executing the
--		statement needs to have the required privileges inherently
--		or via a direct grant, not via a role.
--
-------------------------------------------------------------------------------

create or replace procedure
  &1 .execute_as(command in varchar2)
is
begin
  sys.dbms_sql.parse(sys.dbms_sql.open_cursor, command, sys.dbms_sql.native);
end;
/

exec &1 .execute_as('&2'); 

drop procedure &1 .execute_as
/

