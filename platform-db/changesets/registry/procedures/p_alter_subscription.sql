--liquibase formatted sql
--changeset platform:p_alter_subscription splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE PROCEDURE p_alter_subscription()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
  EXECUTE 'ALTER SUBSCRIPTION operational_sub REFRESH PUBLICATION';
END;
$procedure$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;
