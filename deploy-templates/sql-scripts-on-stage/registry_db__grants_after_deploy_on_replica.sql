-- command to invoke script from shell
-- psql -U ${context.citusdb.username} -f /etc/registry_db__grants_after_deploy_on_replica.sql -v dbName="'${context.registry.name}'" -v appRoleName="'${context.registry.appRole}'"


-- connect to database
select :dbName as db
\gset
\c :db


-- grants
-- role application_role
select 'grant select on all tables in schema public to ' || :appRoleName
\gexec

select 'grant execute on all routines in schema public to ' || :appRoleName
\gexec

select 'alter default privileges in schema public grant select on tables to ' || :appRoleName
\gexec

select 'revoke all privileges on table ddm_db_changelog from ' || :appRoleName
\gexec

select 'revoke all privileges on table ddm_db_changelog_lock from ' || :appRoleName
\gexec

select 'revoke all privileges on table ddm_liquibase_metadata from ' || :appRoleName
\gexec
