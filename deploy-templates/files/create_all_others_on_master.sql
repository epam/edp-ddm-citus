-- extension pg_stat_statements
create extension if not exists pg_stat_statements;


-- role registry_owner_role
select 'create role ' || :regOwnerName || ' with password ' || :'regOwnerPass' || ' login createdb'
  where not exists (select from pg_catalog.pg_roles where rolname = :regOwnerName)
\gexec

select 'alter role ' || :regOwnerName || ' with password ' || :'regOwnerPass' || ' login createdb'
\gexec


-- role application_role
select 'create role ' || :appRoleName || ' with password ' || :'appRolePass' || ' login'
  where not exists (select from pg_catalog.pg_roles where rolname = :appRoleName)
\gexec

select 'alter role ' || :appRoleName || ' with password ' || :'appRolePass' || ' login'
\gexec


-- role admin_role
select 'create role ' || :admRoleName || ' with password ' || :'admRolePass' || ' login'
  where not exists (select from pg_catalog.pg_roles where rolname = :admRoleName)
\gexec

select 'alter role ' || :admRoleName || ' with password ' || :'admRolePass' || ' login'
\gexec

