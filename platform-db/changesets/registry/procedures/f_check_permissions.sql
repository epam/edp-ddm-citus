--liquibase formatted sql
--changeset platform:f_check_permissions splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE FUNCTION public.f_check_permissions(p_object_name text, p_roles_arr text[], p_operation type_operation DEFAULT 'S'::type_operation, p_columns_arr text[] DEFAULT NULL::text[])
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
DECLARE
  c_unit_name text := 'f_check_permissions';
  l_ret BOOLEAN;
BEGIN

  call p_raise_notice(format('%s: p_object_name [%s]', c_unit_name, p_object_name));
  call p_raise_notice(format('%s: p_roles_arr (list of user roles) [%s]', c_unit_name, p_roles_arr));
  call p_raise_notice(format('%s: p_operation [%s]', c_unit_name, p_operation));
  call p_raise_notice(format('%s: p_columns_arr (list of updated columns) [%s]', c_unit_name, p_columns_arr));

  -- checks if table is RBAC regulated
  SELECT count(1) = 0 INTO l_ret FROM (SELECT 1 FROM ddm_role_permission WHERE object_name = p_object_name LIMIT 1) s;
  IF l_ret THEN
    call p_raise_notice(format('%s: table [%s] is not RBAC regiulated => rbac check is skipped', c_unit_name, p_object_name));
    RETURN l_ret;
  END IF;
  -- checks permission for all columns
  call p_raise_notice(format('%s: list of user roles for check [%s]', c_unit_name, array_append(p_roles_arr,'isAuthenticated')));
  SELECT count(1) > 0 INTO l_ret FROM ddm_role_permission
  WHERE object_name = p_object_name AND operation = p_operation AND role_name = ANY(array_append(p_roles_arr,'isAuthenticated')) AND trim(coalesce(column_name, '')) = '';
  --
  if l_ret then
    call p_raise_notice(format('%s: table [%s], operation [%s], one of user roles found => access permitted', c_unit_name, p_object_name, p_operation));
    return l_ret;
  elsif not l_ret and p_operation in ('S', 'I', 'D') then
    call p_raise_notice(format('%s: table [%s], operation [%s], none of user roles found => access denied', c_unit_name, p_object_name, p_operation));
    return l_ret;
  end if;

  -- we are here, if operation = U and permission for all columns is not set

  -- check the list of updated columns
  if p_columns_arr is null or cardinality(p_columns_arr) = 0 then
    call p_raise_notice(format('%s: table [%s], operation [%s], none of user roles found, list of updated columns is empty => access denied', c_unit_name, p_object_name, p_operation));
    return false;
  end if;

  -- checks permissions per column
  SELECT count(DISTINCT column_name) = array_length(p_columns_arr, 1) INTO l_ret FROM ddm_role_permission
  WHERE object_name = p_object_name AND operation = p_operation AND role_name = ANY(array_append(p_roles_arr,'isAuthenticated')) AND column_name = ANY(p_columns_arr);
  --
  call p_raise_notice(format('%s: table [%s], operation [%s] => access ' || case when l_ret then 'permitted' else 'denied' end, c_unit_name, p_object_name, p_operation));
  RETURN l_ret;

END;
$function$
SECURITY DEFINER
SET search_path = public, pg_temp;
