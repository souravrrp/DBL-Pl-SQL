with err as (
   select distinct
      owner,
      name,
      type,
      line,
      position,
      sequence,
      text
   from
      dba_errors
   where
      sequence=1
)
select
   decode(n,-1,'* ',' ')||text text from (
      select
         sequence n,
         owner,name,
         type,line,
         lpad(' ',position-1,' ')||'^'||text text
      from
         err
union all
select distinct
   -1 n,
   owner,
   name,
   type,
   line,
   type||' '||owner||'.'||name||' line '||line
from
   err
union all
select
   0,
   owner,
   name,
   type,
   line,
   text
from
   dba_source
where
   (owner,name,type,line) in
      (select
         owner,
         name,
         type,
         line
       from
         err)
order by
   owner,name,
   type,line,
   n
);