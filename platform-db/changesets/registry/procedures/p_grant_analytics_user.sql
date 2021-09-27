--liquibase formatted sql
--changeset platform:p_grant_analytics_user splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE PROCEDURE p_grant_analytics_user(p_user_name text)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
  c_obj_pattern TEXT := 'report%v';
  r RECORD;
  is_role_found integer;
BEGIN

  -- check if role exists
  select 1
    into is_role_found
    from pg_catalog.pg_roles
    where rolname = p_user_name;

  if is_role_found is null then
    return;
  end if;

  execute 'grant connect on database ' || current_database() || ' to "' || p_user_name || '";';

  FOR r IN SELECT * FROM information_schema.views WHERE table_name LIKE c_obj_pattern AND table_schema = 'public' LOOP
    EXECUTE 'GRANT SELECT ON ' || r.table_name || ' TO "' || p_user_name || '";';
  END LOOP;
 END;
$procedure$
SECURITY DEFINER
SET search_path = public, pg_temp;
