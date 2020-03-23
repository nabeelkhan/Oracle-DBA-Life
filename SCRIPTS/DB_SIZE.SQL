select a.bytes+b.bytes from
(select sum(bytes)/1024/1024 bytes from dba_data_files) a,
(select sum(bytes)/1024/1024 bytes from dba_temp_files) b ;
select sum(bytes)/1024/1024 "DB Size(MB)" from dba_segments;

