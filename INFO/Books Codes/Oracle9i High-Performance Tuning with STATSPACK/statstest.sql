Rem
Rem $Header: statsauto.sql 06-dec-99.18:32:45 cdialeri Exp $
Rem
Rem statsauto.sql
Rem
Rem  Copyright (c) Oracle Corporation 1999. All Rights Reserved.
Rem
Rem    NAME
Rem      statsauto.sql
Rem
Rem    DESCRIPTION
Rem      SQL*PLUS command file to automate the collection of STATPACK
Rem      statistics.
Rem
Rem    NOTES
Rem      Should be run as the STATSPACK owner, PERFSTAT.
Rem      Requires job_queue_processes init.ora parameter to be
Rem      set to a number >0 before automatic statistics gathering
Rem      will run.
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    cdialeri    12/06/99 - 1059172, 1103031
Rem    cdialeri    08/13/99 - Created
Rem


spool statsauto.lis

--
--  Schedule a snapshot to be run on this instance every hour, on the hour

variable jobno number;
variable instno number;
begin
  select instance_number into :instno from v$instance;
  dbms_job.submit(:jobno, 'dbms_job.remove(1);', trunc(sysdate+1/24,'HH'), 'trunc(SYSDATE+1/24,''HH'')', TRUE);
  commit;
end;
/


prompt
prompt  Job number for automated statistics collection for this instance
prompt  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
prompt  Note that this job number is needed when modifying or removing
prompt  the job:
print jobno

prompt
prompt  Job queue process
prompt  ~~~~~~~~~~~~~~~~~
prompt  Below is the current setting of the job_queue_processes init.ora
prompt  parameter - the value for this parameter must be greater 
prompt  than 0 to use automatic statistics gathering:
select substr(name,1,30) "JOB QUEUE PROCESSES", substr(value,1,15) "VALUE"
from v$parameter
where name = 'job_queue_processes';
prompt

prompt
prompt  Next scheduled run
prompt  ~~~~~~~~~~~~~~~~~~
prompt  The next scheduled run for this job is:
select JOB, to_char(next_date) "NEXT_DATE", NEXT_SEC 
  from user_jobs
 where job = :jobno;

spool off;
