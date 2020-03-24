-------------------------------------------------------------------------------
--
-- Script:	restore_sqlplus_settings.sql
-- Purpose:	to reset sqlplus settings
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Nabeel Khan
--
-------------------------------------------------------------------------------

set termout off
@sqlplus_settings
clear breaks
clear columns
clear computes
set termout on
