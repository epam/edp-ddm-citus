--liquibase formatted sql
--changeset platform:p_init_new_hist_table splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE PROCEDURE p_init_new_hist_table(p_source_table TEXT, p_target_table TEXT)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
  l_col_lst TEXT;
  l_part_key TEXT;
  l_sql TEXT;
BEGIN
  SELECT string_agg(column_name,',') into l_col_lst
  FROM information_schema.columns
  WHERE table_schema = 'public'
    AND table_name   = p_source_table;
  --
  SELECT column_name INTO l_part_key
  FROM information_schema.constraint_column_usage
  WHERE table_schema = 'public' AND table_name = p_target_table AND constraint_name like 'ui%' LIMIT 1;
  --
  l_sql := 'WITH S AS (SELECT row_number() OVER (PARTITION BY ' || l_part_key || ' ORDER BY ddm_created_at DESC) rn,* FROM '|| p_source_table ||')
            INSERT INTO ' || p_target_table || '(' || l_col_lst || ')
            SELECT ' || l_col_lst || ' FROM s WHERE rn = 1';
  --
  CALL p_raise_notice(l_sql);
  EXECUTE l_sql;
END;
$procedure$
SECURITY DEFINER
SET search_path = public, pg_temp;
