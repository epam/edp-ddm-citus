--liquibase formatted sql
--changeset platform:f_get_ref_record splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE FUNCTION f_get_ref_record(p_ref_path TEXT)
 RETURNS refs
 LANGUAGE plpgsql
AS $function$
DECLARE
  l_ret refs;
BEGIN
  l_ret.lookup_col := substring(p_ref_path,'lookup_col:(.*),ref_table:');
  l_ret.ref_table := substring(p_ref_path,'ref_table:(.*),ref_col:');
  l_ret.ref_col := substring(p_ref_path,'ref_col:(.*),ref_id:');
  l_ret.ref_id := coalesce(substring(p_ref_path,'ref_id:(.*),delim:'), substring(p_ref_path,'ref_id:(.*)\)'));
  l_ret.list_delim := coalesce(substring(p_ref_path,'delim:(.)\)'), ',')::char(1);
  --
  RETURN l_ret;
END;
$function$
SECURITY DEFINER
SET search_path = public, pg_temp;
