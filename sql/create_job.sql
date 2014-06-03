--
-- Package: audit
--
-- Augit log for changes in schema objects
--   create cleaning job
--
--

variable jobno number;

begin
  begin
    select job into :jobno
      from dba_jobs
     where log_user = upper('&&ORA_SCHEMA_CLEANER')
       and what = '"&&ORA_SCHEMA_OWNER".oradba_audit_clean;';
  exception
    when NO_DATA_FOUND then
      begin
        select sys.jobseq.nextval into :jobno from dual;
        dbms_ijob.submit( :jobno,
                         '&&ORA_SCHEMA_CLEANER',
                         '&&ORA_SCHEMA_CLEANER',
                         '&&ORA_SCHEMA_CLEANER',
                         trunc(sysdate,'DD') + 2/24,
                         'trunc(SYSDATE+1,''HH'')',
                         false,
                         '"&&ORA_SCHEMA_OWNER".rias_audit_clean;',
                         'NLS_LANGUAGE=''AMERICAN''',
                         '0102000200000000' );
        commit;
        dbms_output.put_line( CHR(10) || 'I: Job &&ORA_SCHEMA_CLEANER..RIAS_AUDIT_CLEAN installed');
      end;
    when OTHERS then
      raise_application_error(-20101, CHR(10) || 'E: ' || SQLERRM(SQLCODE));
  end;
end;
/
