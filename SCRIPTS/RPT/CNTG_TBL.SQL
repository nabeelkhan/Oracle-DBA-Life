REM cntg_tbl.sql checked out on 7/10/96 17:05:12 version 1.5
set termout off
REM ---- Var '&1' not used

REM ---- Enter the tablespace name or wildcard to match:%
define prefix = '&2'

REM ---- Var '&3' not used

REM ---- Var '&4' not used

REM ---- Var '&5' not used

REM ---- Enter the Output file name for the report:?
define output_file='&6'

REM ---- Var '&7' not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Original author unknown,
rem typed in by Marc E. Marchioli
rem in 1990 For his personal use
rem
start &tool_home/pformat
start &tool_home/rptvars

drop table contig_space;
create table contig_space
  (tablespace_name	varchar2(30),
   file_id		number,
   block_id		number,
   starting_file_id	number,
   starting_block_id	number,
   blocks		number,
   bytes		number);

declare 
  cursor my_query is 
	select *
	from dba_free_space
	where tablespace_name like upper('&prefix')
	order by tablespace_name, file_id, block_id;


  this_row	my_query%ROWTYPE;
  previous_row	my_query%ROWTYPE;
  old_file_id	number(20,0);
  old_block_id	number(20,0);

begin

	open my_query;
	fetch my_query into this_row;
	previous_row := this_row;
	old_file_id := previous_row.file_id;
	old_block_id := previous_row.block_id;

	while my_query%found loop
		if this_row.file_id = previous_row.file_id and
		   this_row.block_id = previous_row.block_id + 
					previous_row.blocks
		then 
		    insert into CONTIG_SPACE
			(tablespace_name, file_id, block_id,
			 starting_file_id, starting_block_id,
			 blocks, bytes)
		    values (previous_row.tablespace_name, previous_row.file_id,
		    this_row.block_id, old_file_id, old_block_id,
		    this_row.blocks, this_row.bytes);
		else
		    insert into CONTIG_SPACE
			(tablespace_name, file_id, block_id,
			 starting_file_id, starting_block_id,
			 blocks, bytes)
                    values (this_row.tablespace_name, this_row.file_id,
                    this_row.block_id, this_row.file_id, this_row.block_id,
                     this_row.blocks, this_row.bytes);
		    old_file_id := this_row.file_id;
		    old_block_id := this_row.block_id;
		end if;

		previous_row := this_row;
		fetch my_query into this_row;
	end loop;
end;
.
/
commit;
drop view new_look;
create view new_look as
select tablespace_name,
	starting_file_id,
	starting_block_id,
	sum(blocks) sum_blocks,
	count(blocks) count_blocks,
	max(blocks) max_blocks,
	sum(bytes) sum_bytes
from contig_space
group by tablespace_name, starting_file_id,
	 starting_block_id;
set termout on
prompt
prompt ******** Finished Creating view new_look
prompt
exit
