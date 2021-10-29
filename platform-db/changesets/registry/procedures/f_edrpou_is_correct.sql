--liquibase formatted sql
--changeset platform:f_edrpou_is_correct splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE FUNCTION f_edrpou_is_correct(char(10))
 RETURNS BOOLEAN
 LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN true;
END;
$function$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;
