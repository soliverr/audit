--
-- Package: audit
--
-- Augit log for changes in schema objects
--   drop cleaning job
--

variable jobno number;

begin
  select job into :jobno
    from dba_jobs
   where log_user = upper('&&ORA_SCHEMA_CLEANER')
     and what = '"&&ORA_SCHEMA_OWNER".oradba_audit_clean;';
  dbms_ijob.remove( :jobno );
  dbms_output.put_line( CHR(10) || 'I: Job &&ORA_SCHEMA_CLEANER..RIAS_AUDIT_CLEAN removed');
exception
  when NO_DATA_FOUND then
     NULL;
  when OTHERS then
     raise_application_error(-20101, CHR(10) || 'E: ' || SQLERRM(SQLCODE));
end;
/
