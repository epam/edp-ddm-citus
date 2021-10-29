--liquibase formatted sql
--changeset platform:p_refresh_analytics_user splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE PROCEDURE p_refresh_analytics_user(p_user_name TEXT, p_user_pwd TEXT)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
  EXECUTE 'DROP ROLE IF EXISTS ' || p_user_name || ';';
  EXECUTE 'CREATE ROLE ' || p_user_name || ' LOGIN PASSWORD ''' || p_user_pwd || ''';';
  CALL p_grant_analytics_user(p_user_name);
 END;
$procedure$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;
