--
-- Package: audit
--
-- Augit log for changes in schema objects
--   create autit log table
--
--

define L_TABLE_NAME = ORADBA$AUDIT_LOG

declare
  l$cnt integer := 0;

  l$sql varchar2(1024) := '
create table &&L_TABLE_NAME (
  sid        number not null,
  userid     varchar2(30),
  osuserid   varchar2(128),
  userhost   varchar2(128),
  userip     varchar2(16),
  userprog   varchar2(128),
  --
  action     varchar2(32),
  obj_type   varchar2(128),
  obj_owner  varchar2(30),
  obj_name   varchar2(128),
  --
  timestamp# date,
  extra      varchar2(4000)
)';

begin
  select count(1) into l$cnt
    from sys.all_tables
   where table_name = '&&L_TABLE_NAME'
     and owner = upper('&&ORA_SCHEMA_OWNER');

   if l$cnt = 0 then
     begin
       execute immediate l$sql || ' tablespace &&ORA_TBSP_TBLS';
       dbms_output.put_line('I: Table &&L_TABLE_NAME created' );
     end;
     -- Index for change time
     execute immediate '
     create index rias$audit_log_stmp on &&L_TABLE_NAME(
       timestamp#
     ) tablespace &&ORA_TBSP_INDX';
   else
       dbms_output.put_line('W: Table &&L_TABLE_NAME already exists' );
   end if;
end;
/

comment on table  &&L_TABLE_NAME is 'Audit log of database DDL events';
comment on column "&&L_TABLE_NAME".sid is 'Session ID';
comment on column "&&L_TABLE_NAME".userid is 'User login name';
comment on column "&&L_TABLE_NAME".userhost is 'User host';
comment on column "&&L_TABLE_NAME".userip is 'User IP address';
comment on column "&&L_TABLE_NAME".userprog is 'User programm';
comment on column "&&L_TABLE_NAME".action is 'Logged event of change';
comment on column "&&L_TABLE_NAME".obj_type is 'Database object type';
comment on column "&&L_TABLE_NAME".obj_owner is 'Database object owner';
comment on column "&&L_TABLE_NAME".obj_name is 'Database object name';
comment on column "&&L_TABLE_NAME".timestamp# is 'Change time';
comment on column "&&L_TABLE_NAME".extra is 'Additional event data';

undefine L_TABLE_NAME
