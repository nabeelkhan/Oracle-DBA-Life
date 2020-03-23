#!/bin/ksh
# Get the number of CPUs
num_cpu=`lsdev -C|grep mem|wc -l`
optimal_parallelism=`expr $num_cpu`-1

sqlplus system/manager<<!
select /*+ FULL(employee_table) PARALLEL(employee_table, $optimal_parallelism)*/
employee_name
from
employee_table;
exit
!

