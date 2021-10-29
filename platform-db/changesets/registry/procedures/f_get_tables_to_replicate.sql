--liquibase formatted sql
--changeset platform:f_get_tables_to_replicate splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE FUNCTION f_get_tables_to_replicate(p_publication_name TEXT)
 RETURNS TEXT
 LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN (SELECT string_agg(table_name,', ') FROM (
            SELECT table_name FROM information_schema.tables
            WHERE table_schema = 'registry' AND table_type = 'BASE TABLE'
              AND (table_name NOT LIKE 'databasechangelog%' AND table_name NOT LIKE 'ddm%')
            EXCEPT
            SELECT tablename FROM pg_catalog.pg_publication_tables WHERE schemaname = 'registry' and pubname = p_publication_name
          ) s
         );
END;
$function$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;

SELECT create_distributed_function('f_get_tables_to_replicate(text)');