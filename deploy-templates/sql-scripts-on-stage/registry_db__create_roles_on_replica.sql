-- command to invoke script from shell
-- psql -U ${context.citusdb.username} -f /etc/registry_db__create_roles_on_replica.sql -v dbName="'${context.registry.name}'" -v appRoleName="'${context.registry.appRole}'" -v appRolePass="'${context.registry.appRolePass}'"


-- role application_role
select 'create role ' || :appRoleName || ' with password ' || :'appRolePass' || ' login'
  where not exists (select from pg_catalog.pg_roles where rolname = :appRoleName)
\gexec

select 'alter role ' || :appRoleName || ' with password ' || :'appRolePass' || ' login'
\gexec

-- MDTUDDM-7279 Користувач з роллю appRole з секретів oc.db.citus-role.secrets не повинен мати до бази даних репліки
select 'revoke connect on database ' || :dbName || ' from ' || :appRoleName
\gexec
