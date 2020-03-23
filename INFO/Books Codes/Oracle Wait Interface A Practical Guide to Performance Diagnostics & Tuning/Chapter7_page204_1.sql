orcl> oradebug setospid 14883
Oracle pid: 5, Unix process pid: 14883, image: oracle@aoxn1000 (LGWR)
orcl> oradebug unlimit
Statement processed.
orcl> oradebug call kcrfw_dump_interesting_data
Function returned 90F42748
orcl> oradebug tracefile_name
/orahome/admin/orcl/bdump/orcl_lgwr_14883.trc
orcl> !grep kcrfswth /orahome/admin/orcl/bdump/orcl_lgwr_14883.trc
   kcrfswth = 1706

orcl> select value from v$parameter where name = 'log_buffer';
VALUE
---------------
5242880

orcl> select max(LEBSZ) from x$kccle;
MAX(LEBSZ)
----------
       512

orcl> select 5242880/512/1706 from dual; 
5242880/512/1706
----------------
      6.00234467
