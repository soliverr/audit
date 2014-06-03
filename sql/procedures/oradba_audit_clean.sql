create or replace procedure oradba_audit_clean( delta IN integer default 90 )  as
  --
  -- Package: audit
  --
  -- Augit log for changes in schema objects
  --   Cleaning procedure
  --
  --

  PRAGMA AUTONOMOUS_TRANSACTION;

begin
   -- Don't delete last records
   delete from oradba$audit_log
    where trunc(timestamp#, 'HH') < (select trunc(max(timestamp#)-delta, 'HH')
                                       from oradba$audit_log);
   commit;
end oradba_audit_clean;
/
