--liquibase formatted sql
--changeset platform:p_version_control splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE PROCEDURE p_version_control(p_version TEXT)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
  c_change_type TEXT := 'versioning';
  c_change_name TEXT := 'registry_version';
  c_attr_curr TEXT := 'current';
  c_attr_prev TEXT := 'previous';
  l_ver_curr TEXT;
  l_ver_prev TEXT;
  l_ret text;
BEGIN
  -- get current version
  SELECT attribute_value INTO l_ver_curr FROM ddm_liquibase_metadata 
  WHERE change_type = c_change_type AND change_name = c_change_name AND attribute_name = c_attr_curr;
  -- get previous version
  SELECT attribute_value INTO l_ver_prev FROM ddm_liquibase_metadata 
  WHERE change_type = c_change_type AND change_name = c_change_name AND attribute_name = c_attr_prev;
  --
  IF coalesce(l_ver_curr, 'N/A') = p_version THEN
    RAISE EXCEPTION 'ERROR: new registry version must differ from current version' USING ERRCODE = '20005';
  END IF;
  -- change current version
  UPDATE ddm_liquibase_metadata SET attribute_value = p_version
  WHERE change_type = c_change_type AND change_name = c_change_name AND attribute_name = c_attr_curr
  returning attribute_value into l_ret;
  --
  IF l_ret IS NULL THEN
    INSERT INTO ddm_liquibase_metadata (change_name, change_type, attribute_name, attribute_value) VALUES (c_change_name, c_change_type, c_attr_curr, p_version);
  END IF;
  -- change previous version
  UPDATE ddm_liquibase_metadata SET attribute_value = l_ver_curr
  WHERE change_type = c_change_type AND change_name = c_change_name AND attribute_name = c_attr_prev
  returning attribute_value into l_ret;
  --
  IF l_ret IS NULL THEN
    INSERT INTO ddm_liquibase_metadata (change_name, change_type, attribute_name, attribute_value) VALUES (c_change_name, c_change_type, c_attr_prev, coalesce(l_ver_curr,'N/A'));
  END IF;
END;
$procedure$
SECURITY DEFINER
SET search_path = public, pg_temp;
