Select
to_number(decode(SID, 65535, NULL, SID)) sid,
operation_type OPERATION,
trunc(WORK_AREA_SIZE/1024) WSIZE,
trunc(EXPECTED_SIZE/1024) ESIZE,
trunc(ACTUAL_MEM_USED/1024) MEM,
trunc(MAX_MEM_USED/1024) "MAX MEM",
number_passes PASS
from
v$sql_workarea_active
order by 1,2
/
