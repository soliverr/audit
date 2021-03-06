--
-- Role to grant access right to audit log table.
--
--

set define on
set verify off

define L_ROLE_NAME = &&ORA_ROLE_NAME

declare
  l$cnt integer := 0;
  l$sql varchar2(1024) := 'create role &&L_ROLE_NAME not identified';
begin
  select count(1) into l$cnt
    from sys.dba_roles
   where role = '&&L_ROLE_NAME';

   if l$cnt = 0 then
     begin
       execute immediate l$sql;
       dbms_output.put_line( CHR(10) || 'I: Role &&L_ROLE_NAME created' );
     end;
   else
       dbms_output.put_line( CHR(10) || 'W: Role &&L_ROLE_NAME already exists' );
   end if;
end;
/
