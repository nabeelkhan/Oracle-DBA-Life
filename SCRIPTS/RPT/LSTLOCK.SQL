REM lstlock.sql checked out on 6/12/97 17:05:17 version 1.5
set termout off
REM ---- Var '&1' not used
 
REM ---- Var '&1' not used
 
REM ---- Enter the Title for the top of the report:?
define app_name = '&3'
 
REM ---- Var '&4' not used
 
REM ---- Var '&5' not used
 
REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'
 
REM ---- Var '&7' not used
 
REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

set termout on
prompt
prompt ******** Running DBA List Locked Processes Report
prompt
set termout off

/* This was modified from a distributed report from ORACLE so here's credit */
rem 
rem $Header: utllockt.sql 7001200.1 92/11/03 17:30:39 twang Generic<base> $ locktree.sql 
rem 
Rem Copyright (c) 1989 by Oracle Corporation
Rem NAME
REM    UTLLOCKT.SQL
Rem  FUNCTION   - Print out the lock wait-for graph in tree structured fashion.
Rem               This is useful for diagnosing systems that are hung on locks.
Rem  NOTES
Rem  MODIFIED
Rem     Marchioli  03/04/96 - Added references to process and usernames
Rem				The DataBase Group, Inc.
Rem				Dallas, Texas
Rem     glumpkin   10/20/92 -  Renamed from LOCKTREE.SQL 
Rem     jloaiza    05/24/91 - update for v7 
Rem     rlim       04/29/91 - change char to varchar2 
Rem     Loaiza     11/01/89 - Creation
Rem

/* Print out the lock wait-for graph in a tree structured fashion.
* This script  prints  the  sessions in   the system  that  are waiting for
* locks,  and the locks that they  are waiting for.   The  printout is tree
* structured.  If a sessionid is printed immediately below and to the right
* of another session, then it is waiting for that session.  The session ids
* printed at the left hand side of the page are  the ones  that everyone is
* waiting for.
*  
* For example, in the following printout session 9 is waiting for
* session 8, 7 is waiting for 9, and 10 is waiting for 9.
*  
* WAITING_SESSION   TYPE MODE REQUESTED    MODE HELD         LOCK ID1 LOCK ID2
* ----------------- ---- ----------------- ----------------- -------- --------
* 8                 NONE None              None              0         0
*    9              TX   Share (S)         Exclusive (X)     65547     16
*       7           RW   Exclusive (X)     S/Row-X (SSX)     33554440  2
*       10          RW   Exclusive (X)     S/Row-X (SSX)     33554440  2
* 
* The lock information to the right of the session id describes the lock
* that the session is waiting for (not the lock it is holding).
* Note that  this is a  script and not a  set  of view  definitions because
* connect-by is used in the implementation and therefore  a temporary table
* is created and dropped since you cannot do a join in a connect-by.
*  
* This script has two  small disadvantages.  One, a  table is created  when
* this  script is run.   To create  a table   a  number of   locks must  be
* acquired. This  might cause the session running  the script to get caught
* in the lock problem it is trying to diagnose.  Two, if a session waits on
* a lock held by more than one session (share lock) then the wait-for graph
* is no longer a tree  and the  conenct-by will show the session  (and  any
* sessions waiting on it) several times.
 */


/* Select all sids waiting for a lock, the lock they are waiting on, and the
 * sid of the session that holds the lock.
 *  UNION
 * The sids of all session holding locks that someone is waiting on that
 * are not themselves waiting for locks. These are included so that the roots
 * of the wait for graph (the sessions holding things up) will be displayed.
 */

 /* Modified to show process numbers and osuser with username from db 
    Marc E. Marchioli
    The DataBase Group, Inc.
    4011 Travis Street
    Dallas, TX 75204-7512
*/
drop table lock_holders;

create table LOCK_HOLDERS   /* temporary table */
(
  waiting_session   number,
  waiting_username  varchar2(30),
  waiting_process   number,
  waiting_osuser    varchar2(15),
  holding_session   number,
  holding_username  varchar2(30),
  holding_process    number,
  holding_osuser    varchar2(15),
  lock_type         varchar2(17),
  mode_held         varchar2(10),
  mode_requested    varchar2(10),
  lock_id1          varchar2(10),
  lock_id2          varchar2(10)
);


drop   table dba_locks_temp;
create table dba_locks_temp as select * from sys.dba_locks;
create index dba_locks_temp_idx on dba_locks_temp (session_id, mode_held, mode_requested, lock_type);

/* This is essentially a copy of the dba_waiters view but runs faster since
 *  it caches the result of selecting from dba_locks.
 */
insert into lock_holders 
  select w.session_id,
	ws.username,
	ws.process,
	ws.osuser,
        h.session_id,
	hs.username,
	hs.process,
	hs.osuser,
        w.lock_type,
        h.mode_held,
        w.mode_requested,
        w.lock_id1,
        w.lock_id2
  from dba_locks_temp w, dba_locks_temp h,
       v$session ws, v$session hs
 where h.mode_held      !=  'None'
  and  h.mode_held      !=  'Null'
  and  w.mode_requested !=  'None'
  and  w.lock_type       =  h.lock_type
  and  w.lock_id1        =  h.lock_id1
  and  w.lock_id2        =  h.lock_id2
  and  ws.sid            = w.session_id
  and  hs.sid            = h.session_id;

commit;

drop table dba_locks_temp;

insert into lock_holders 
  select holding_session, holding_username, holding_process, holding_osuser, null, null, null, 'None', null, null, null, null, null
    from lock_holders 
 minus
  select waiting_session, waiting_username, waiting_process, waiting_osuser, null, null, null, 'None', null, null, null, null, null
    from lock_holders;
commit;

column waiting_username heading 'Oracle|Username' format a17
column waiting_session heading 'Oracle SID' format a15
column waiting_process heading 'Operating|System|Process' format 9999999
column waiting_osuser heading 'Operating|System|User' format a9
column lock_type heading 'Lock Type' 
column mode_requested heading 'Mode|Requested'
column mode_held heading 'Mode|Held'
column lock_id1 heading 'Lock|ID #1'
column lock_id2 heading 'Lock|ID #2'

column buff fold_after 1

start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Locked Processes and Lock Holders' skip 2 -
center 'This script  prints  the  sessions in   the system  that  are waiting for' skip 1 -
center 'locks,  and the locks that they  are waiting for.   The  printout is tree' skip 1 -
center 'structured.  If a sessionid is printed immediately below and to the right' skip 1 -
center 'of another session, then it is waiting for that session.  The session ids' skip 1 -
center 'printed at the left hand side of the page are  the ones  that everyone is' skip 1 -
center 'waiting for.' skip 2 -
center 'For example, in the following printout session 9 is waiting for' skip 1 -
center 'session 8, 7 is waiting for 9, and 10 is waiting for 9.' skip 2 -
center 'WAITING_SESSION   TYPE MODE REQUESTED    MODE HELD         LOCK ID1 LOCK ID2' skip 1 -
center '----------------- ---- ----------------- ----------------- -------- --------' skip 1 -
center '8                 NONE None              None              0         0' skip 1 -
center '   9              TX   Share (S)         Exclusive (X)     65547     16' skip 1 -
center '      7           RW   Exclusive (X)     S/Row-X (SSX)     33554440  2' skip 1 -
center '      10          RW   Exclusive (X)     S/Row-X (SSX)     33554440  2' skip 2 -
center 'The lock information to the right of the session id describes the lock' skip 1 -
center 'that the session is waiting for (not the lock it is holding).' skip 3

btitle center 'Report: lstlock'


REM  Print out the result in a tree structured fashion 
set heading on
spool &output_file
select  lpad(' ',3*(level-1)) || waiting_session waiting_session,
	waiting_username,
	waiting_process,
	waiting_osuser,
	lock_type,
	mode_requested,
	mode_held,
	lock_id1,
	lock_id2
 from lock_holders
connect by  prior waiting_session = holding_session
  start with holding_session is null;
spool off
drop table lock_holders;
start &tool_home/ppcmd
exit
