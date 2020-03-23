-------------------------------------------------------------------------------
--
-- Script:	next_prime.sql
-- Purpose:	to return the next prime number
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Note:	Unless you have an alternative local convention, persistent
--		database objects used for database administration should go
--		into the SYSTEM schema. That's what it is for.
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

@accept Owner "Schema to own the function" SYSTEM

set feedback on

create or replace function
  &Owner .next_prime(
    val in number
  )
return number
deterministic
is
  p number;
  non boolean;
begin
  p := abs(val);
  loop
    non := false;
    for f in 2..floor(sqrt(p)) loop
      non := (mod(p, f) = 0);
      exit when non;
    end loop;
    if (not non) then 
      return sign(val) * p; 
    end if;
    p := p + 1;
  end loop; 
end;
/
set termout off
create public synonym next_prime for &Owner .next_prime
/
@as &Owner 'grant execute on next_prime to public'

@restore_sqlplus_settings
