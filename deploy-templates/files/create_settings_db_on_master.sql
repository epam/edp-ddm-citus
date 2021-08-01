-- database
select 'create database settings'
  where not exists (select from pg_database where datname = 'settings')
\gexec


-- role settings_role
select 'create role ' || :settRoleName || ' with password ' || :'settRolePass' || ' login'
  where not exists (select from pg_catalog.pg_roles where rolname = :settRoleName)
\gexec

select 'alter role ' || :settRoleName || ' with password ' || :'settRolePass' || ' login'
\gexec


-- settings db owner
select 'alter database settings owner to ' || :settRoleName
\gexec


-- connect to settings db
\c settings


-- extension uuid-ossp
create extension if not exists "uuid-ossp";


-- table settings
create table if not exists settings (
    settings_id uuid not null default uuid_generate_v4(),
    keycloak_id uuid not null,
    email text,
    phone text,
    communication_is_allowed boolean,
	constraint settings__settings_id__pk primary key (settings_id),
	constraint settings__keycloak_id__uk unique (keycloak_id)
);

select 'alter table settings owner to ' || :settRoleName
\gexec


-- revoke
revoke all on settings from public;


-- grants
-- role settings_role
--NB. grants not needed because settings_role is the owner of table settings
--select 'grant select, insert, update, delete on settings to ' || :settRoleName
--\gexec
