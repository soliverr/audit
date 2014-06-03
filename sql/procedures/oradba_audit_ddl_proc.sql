create or replace procedure oradba_audit_ddl_proc as
  --
  -- Package: audit
  --
  -- Augit log for changes in schema objects
  --   Audit procedure
  --
  --

  PRAGMA AUTONOMOUS_TRANSACTION;

  l_sid         number;
  l_osuser      varchar2(30);
  l_prg         varchar2(128);
  l_machine     varchar2(128);
  l_sysevent    varchar2(25);
  l_objname     varchar2(128);
  l_extra       varchar2(4000) := NULL;
begin
  -- Get current session SID
  select sid into l_sid from v$mystat where rownum = 1;

  select osuser, program, machine into l_osuser, l_prg, l_machine
    from v$session
   where sid = l_sid;

  select ora_dict_obj_name into l_objname from dual;

  select ora_sysevent into l_sysevent from dual;
  if ( l_sysevent = 'ALTER' ) then
    begin 
      select c.sql_text into l_extra 
        from v$open_cursor c, v$session s
       where s.sid = l_sid
         --and s.prev_sql_addr = c.address;
         and upper(c.sql_text) like 'ALTER%'||l_objname||'%'
         and rownum = 1;
    exception
      when OTHERS then NULL;
    end;
  end if;

  -- Write data to log table
  insert into oradba$audit_log 
    select l_sid,
           ora_login_user,
           l_osuser,
           l_machine,
           ora_client_ip_address,
           l_prg,
           l_sysevent,
           ora_dict_obj_type,
           ora_dict_obj_owner,
           l_objname,
           sysdate,
           l_extra
      from dual;
  commit;

end oradba_audit_ddl_proc;
/
