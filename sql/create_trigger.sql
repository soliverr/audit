--
-- Package: audit
--
-- Augit log for changes in schema objects
--   create database level audit trigger
--
--

create or replace trigger oradba_audit_ddl after ddl on database
  call oradba_audit_ddl_proc
/
