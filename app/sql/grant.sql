/* From postgres user (sudo -u postgres psql) */
ALTER ROLE federico WITH CREATEROLE;

GRANT ALL PRIVILEGES ON DATABASE federico TO federico WITH GRANT OPTION;

/**********/

CREATE ROLE basf WITH LOGIN PASSWORD 'libialeon';

REVOKE CONNECT ON DATABASE federico FROM PUBLIC;

GRANT CONNECT 
	ON DATABASE federico
	TO basf

REVOKE ALL
ON ALL TABLES IN SCHEMA public 
FROM PUBLIC;

GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA public 
TO basf;

GRANT SELECT ON ALL SEQUENCES IN SCHEMA public
TO basf;

ALTER DEFAULT PRIVILEGES FOR ROLE schma_admin
GRANT INSERT, UPDATE, DELETE, TRUNCATE ON TABLES TO schma_mgr;  -- + write, TRUNCATE optional

--https://dba.stackexchange.com/questions/117109/how-to-manage-default-privileges-for-users-on-a-database-vs-schema/117661#117661
ALTER DEFAULT PRIVILEGES FOR ROLE federico -- Note Alter default privileges for the role that creates objects (federico), which in turn grants privileges to another role (basf).
GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO basf;  
