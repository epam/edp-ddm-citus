-- command to invoke script from shell
-- psql -U ${context.citusdb.username} -f /etc/registry_db__create_roles_on_master.sql -v dbName="'${context.registry.name}'" -v appRoleName="'${context.registry.appRole}'" -v appRolePass="'${context.registry.appRolePass}'" -v admRoleName="'${context.registry.adminRole}'" -v admRolePass="'${context.registry.adminRolePass}'"


-- role application_role
select 'create role ' || :appRoleName || ' with password ' || :'appRolePass' || ' login'
  where not exists (select from pg_catalog.pg_roles where rolname = :appRoleName)
\gexec

select 'alter role ' || :appRoleName || ' with password ' || :'appRolePass' || ' login'
\gexec

select 'grant connect on database ' || :dbName || ' to ' || :appRoleName
\gexec


-- role admin_role
select 'create role ' || :admRoleName || ' with password ' || :'admRolePass' || ' login'
  where not exists (select from pg_catalog.pg_roles where rolname = :admRoleName)
\gexec

select 'alter role ' || :admRoleName || ' with password ' || :'admRolePass' || ' login'
\gexec

select 'grant connect on database ' || :dbName || ' to ' || :admRoleName
\gexec
