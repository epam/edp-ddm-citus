--liquibase formatted sql
/*
 * Copyright 2021 EPAM Systems.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    https://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
--changeset platform:p_grant_analytics_user splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE PROCEDURE p_grant_analytics_user(p_user_name text)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
  c_obj_pattern TEXT := 'report%v';
  r RECORD;
  is_role_found integer;
  v_user_name text := replace(p_user_name, '"', '');
BEGIN

  -- check if role exists
  select 1
    into is_role_found
    from pg_catalog.pg_roles
    where rolname = v_user_name;

  if is_role_found is null then
    raise exception 'Role [%] is not found', v_user_name;
  end if;

  execute 'grant connect on database ' || current_database() || ' to "' || v_user_name || '";';

  FOR r IN SELECT * FROM information_schema.views WHERE table_name LIKE c_obj_pattern AND table_schema = 'registry' LOOP
    EXECUTE 'GRANT SELECT ON "' || r.table_name || '" TO "' || v_user_name || '";';
  END LOOP;
 END;
$procedure$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;
