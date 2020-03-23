REM – As a Procedure
begin
   dbms_workload_repository.create_baseline(
                            start_snap_id => 2305,
                            end_snap_id => 2310,
                            baseline_name => 'Good Nightly Batch');
end;
/









