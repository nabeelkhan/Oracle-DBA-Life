REM – As a Function
REM – Using 2200 for start_snap_id, 2205 for the end_snap_id and
REM – ‘Good Special Batch’ for the baseline_name.

select dbms_workload_repository.create_baseline(
                                2200, 2205, 'Good Special Batch')
from dual;









