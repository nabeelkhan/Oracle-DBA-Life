-------------------------------------------------------------------------------
--
-- Script:	post_event.sql
-- Purpose:	to set/unset an event in another session
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Synopsis:	@set_background  OR  @set_sid
--		@post_event
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

@accept Event "Event number" 10046
@accept Level "Level of event" 0

prompt
prompt execute sys.dbms_system.set_ev(&Sid, &Serial, &Event, &Level, '')
set feedback on
execute sys.dbms_system.set_ev(&Sid, &Serial, &Event, &Level, '')

@restore_sqlplus_settings
