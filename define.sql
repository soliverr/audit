--
-- Package definitions
--

-- Schema owner to keep database objects
define ORA_SCHEMA_OWNER = &&ORADBA_SYS_OWNER

-- Audit role
define ORA_ROLE_NAME = ORADBA_AUDIT

-- Tablespace to keep tables
define ORA_TBSP_TBLS = &&ORADBA_TBSP_TBLS

-- Tablespace to keep indexes
define ORA_TBSP_INDX = &&ORADBA_TBSP_INDX

-- Schema owner for cleaning job
define ORA_SCHEMA_CLEANER = &&ORADBA_SCHEMA_CLEANER
