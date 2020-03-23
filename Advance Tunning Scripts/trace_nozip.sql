-------------------------------------------------------------------------------
--
-- Script:	trace_nozip.sql
-- Purpose:	to remove the named pipe created by trace_zip.sql
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Synopsis:	see trace_zip.sql
--
-------------------------------------------------------------------------------

disconnect
set define :
host [ -p :Trace_Name ] && rm -f :Trace_Name
exit
