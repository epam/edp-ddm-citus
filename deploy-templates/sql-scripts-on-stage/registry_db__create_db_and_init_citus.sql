-- command to invoke script from shell
-- psql -U ${context.citusdb.username} -f /etc/registry_db__create_db_and_init_citus.sql -v dbName="'${context.registry.name}'" -v regOwnerName="'${context.registry.ownerRole}'" -v regOwnerPass="'${context.registry.ownerPass}'" -v archiveSchema="'${archiveSchema}'"


-- database
select 'create database ' || :dbName
  where not exists (select from pg_database where datname = :dbName)
\gexec


-- role registry_owner_role
select 'create role ' || :regOwnerName || ' with password ' || :'regOwnerPass' || ' login'
  where not exists (select from pg_catalog.pg_roles where rolname = :regOwnerName)
\gexec

select 'alter role ' || :regOwnerName || ' with password ' || :'regOwnerPass' || ' login'
\gexec


-- set database owner
select 'alter database ' || :dbName || ' owner to ' || :regOwnerName
\gexec


-- connect to database
select :dbName as db
\gset
\c :db


-- extension citus
create extension if not exists citus;


-- schema archive
select 'create schema if not exists ' || :archiveSchema
\gexec

select 'alter schema ' || :archiveSchema || ' owner to ' || :regOwnerName
\gexec


-- revoke
select 'revoke connect on database ' || :dbName || ' from public'
\gexec

revoke all privileges on all tables in schema public from public;
revoke all privileges on all routines in schema public from public;


-- grants
-- role registry_owner_role
select 'grant connect on database ' || :dbName || ' to ' || :regOwnerName
\gexec

select 'grant all privileges on all tables in schema public to ' || :regOwnerName
\gexec

select 'grant all privileges on all routines in schema public to ' || :regOwnerName
\gexec
