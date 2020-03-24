-------------------------------------------------------------------------------
--
-- Script:	suspend_process.sql
-- Purpose:	to suspend an Oracle process indefinitely
-- For:		8.1
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Nabeel Khan
--
-- Synopsis:	@set_sid
--		@suspend_process
--
-------------------------------------------------------------------------------
oradebug setorapid &Pid
oradebug suspend
