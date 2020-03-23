REM FILE NAME:  status.sql
REM LOCATION:  
REM FUNCTION:   Run various database health scripts 
REM TESTED ON:  8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   grants.sql, crea_tab.sql and dbms_revealnet.sql have been run.
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


CLEAR columns
CLEAR computes
@do_calst
CLEAR columns
CLEAR computes
@libcache
CLEAR computes
CLEAR columns
@free_sp2
CLEAR columns
CLEAR computes
@db_ext
CLEAR columns
CLEAR computes
@rbk1
@rbk2
CLEAR columns
CLEAR computes
@log_stat
CLEAR columns
CLEAR computes
@inv_obj
CLEAR columns
CLEAR computes
@systabs
CLEAR columns
CLEAR computes
