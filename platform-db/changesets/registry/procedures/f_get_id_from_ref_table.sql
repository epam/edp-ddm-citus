--liquibase formatted sql
--changeset platform:f_get_id_from_ref_table splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE FUNCTION f_get_id_from_ref_table(p_ref_table text, p_ref_col text, p_ref_id text, p_lookup_val text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
  l_sql TEXT;
  l_ret TEXT;
BEGIN
  IF p_lookup_val IS NULL THEN
    RETURN NULL;
  END IF;
  l_sql := format('SELECT %I::text FROM %I WHERE %I = ''%s''', p_ref_id, p_ref_table, p_ref_col, replace(p_lookup_val,'''',''''''));
  --
  CALL p_raise_notice(l_sql);
  EXECUTE l_sql INTO STRICT l_ret;
  --
  RETURN l_ret;
EXCEPTION WHEN OTHERS THEN
  RAISE EXCEPTION  '%: table [%] column [% = ''%'']', SQLERRM, p_ref_table, p_ref_col ,p_lookup_val USING ERRCODE = SQLSTATE;
END;
$function$
SECURITY DEFINER
SET search_path = public, pg_temp;
