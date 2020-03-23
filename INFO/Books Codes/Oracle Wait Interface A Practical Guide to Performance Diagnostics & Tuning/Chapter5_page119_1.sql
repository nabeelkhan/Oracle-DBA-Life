alter session set db_file_multiblock_read_count = 1000;
select /*+ full(a) */ count(*) from big_table a;
