-------------------------------------------------------------------------------
--
-- Script:	apt_format.sql
-- Purpose:	to do a few things that to_char does not
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Nabeel Khan
--
-- Synopsis:	apt_format(value, '9999K')
--		apt_format(value, '9999k')
--		apt_format(value, '999%')
--
-- Description:	If the format ends with K, the value is returned in kilobytes,
--		megabytes or gigabytes with K, M or G appended.
--		If the format ends with k, the value is returned in units,
--		thousands or millions with nothing, k or m appended.
--		If the format ends with %, the value is returned as a
--		percentage with % appended.
--
--		Only the last digit and the total length of the format string
--		are considered. The format string must be at least 5, 5 or 4
--		characters long respectively. Most values can be displayed in
--		that many characters. Longer formats are mainly for padding.
--
-- Examples:	apt_format(1024,    '9999K') => '   1K'
--		apt_format(262144,  '9999K') => ' 256K'
--		apt_format(1310720, '9999K') => '1.25M'
--		apt_format(500,     '9999k') => '  500'
--		apt_format(1000,    '9999k') => '   1k'
--		apt_format(262144,  '9999k') => ' 262k'
--		apt_format(1250000, '9999k') => '1.25m'
--		apt_format(100,      '999%') =>  '100%'
--		apt_format(75,       '999%') =>  ' 75%'
--		apt_format(35/4,     '999%') =>  '8.8%'
--		apt_format(1/7,      '999%') =>  '.14%'
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
  &Owner .apt_format(
    val in number,		-- the number to be formatted
    fmt in varchar2		-- the format mask
  )
return varchar2 is
  s  char(1);
  l  number;
  k  number;
  m  number;
  g  number;
  v  number;
begin
  s := substr(fmt, -1);
  l := length(fmt);
  if val is null then
    return null;
  elsif s = 'K' then
    k := 1024;
    m := 1024 * 1024;
    g := 1024 * 1024 * 1024;
    if    val < m then v := val / k; s := 'K';
    elsif val < g then v := val / m; s := 'M';
    else               v := val / g; s := 'G';
    end if;
    if    v > floor(v) and length(floor(v)) = 1 then
      return lpad(to_char(v, 'FM9.00') || s, l);
    elsif v > floor(v) and length(floor(v)) = 2 then
      return lpad(to_char(v, 'FM99.0') || s, l);
    else
      return lpad(to_char(v, substr('FM999999999999', 1, l+1)) || s, l);
    end if;
  elsif s = 'k' then
    k := 1000;
    m := 1000000;
    if    val < k then v := val    ; s := null;
    elsif val < m then v := val / k; s := 'k';
    else               v := val / m; s := 'm';
    end if;
    if    v > floor(v) and length(floor(v)) = 1 then
      return lpad(to_char(v, 'FM9.00') || s, l);
    elsif v > floor(v) and length(floor(v)) = 2 then
      return lpad(to_char(v, 'FM99.0') || s, l);
    else
      return lpad(to_char(v, substr('FM999999999999', 1, l + 1)) || s, l);
    end if;
  elsif s = '%' then
    if    floor(100 * val) = 0 then
      return lpad(to_char(100 * val, 'FM.00') || s, l);
    elsif length(floor(100 * val)) = 1 then
      return lpad(to_char(100 * val, 'FM9.0') || s, l);
    else
      return lpad(to_char(floor(100 * val), 'FM999') || s, l);
    end if;
  else
    return substr(to_char(val, fmt), 2);
  end if;
end;
/
set termout off
create public synonym apt_format for &Owner .apt_format
/
@as &Owner 'grant execute on apt_format to public'

@restore_sqlplus_settings
