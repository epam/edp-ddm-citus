--liquibase formatted sql
--changeset platform:f_get_tables_to_replicate splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE FUNCTION f_get_tables_to_replicate(p_publication_name TEXT)
 RETURNS TEXT
 LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN (SELECT string_agg(table_name, ', ')
            FROM (
                    SELECT table_name
                    FROM information_schema.tables
                    WHERE table_type = 'BASE TABLE'
                        AND (
                            table_schema = 'registry'
                            OR (
                                table_schema = 'public'
                                and table_name like 'ddm_source%'
                            )
                        )
                    EXCEPT
                    SELECT tablename
                    FROM pg_catalog.pg_publication_tables
                    WHERE pubname = p_publication_name
                ) s
         );
END;
$function$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;
