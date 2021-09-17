--liquibase formatted sql
--changeset platform:p_alter_publicaton splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE PROCEDURE p_alter_publicaton(p_publication_name TEXT)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
  l_table_list TEXT;
BEGIN
  l_table_list := f_get_tables_to_replicate(p_publication_name);
  IF l_table_list IS NOT NULL THEN
    EXECUTE 'ALTER PUBLICATION ' || p_publication_name || ' ADD TABLE ' || l_table_list || ';';
  END IF;
END;
$procedure$
SECURITY DEFINER
SET search_path = public, pg_temp;

SELECT create_distributed_function('p_alter_publicaton(text)');