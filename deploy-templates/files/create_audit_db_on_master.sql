-- command to invoke script from shell
--psql -U $PSQL_USER -f create_audit_db_on_master.sql -v anSvcUser="'$AN_SVC_USER'" -v anSvcPass="'$AN_SVC_PASS'" -v anRoleName="'$AN_ROLE'" -v anRolePass="'$AN_PASS'" -v anAdmUser="'$AN_ADM_ROLE'" -v anAdmPass="'$AN_ADM_PASS'"


-- database audit
select 'create database audit'
  where not exists (select from pg_database where datname = 'audit')
\gexec


-- role analytics_admin
select 'create role ' || :anAdmUser || ' with password ' || :'anAdmPass' || ' login'
  where not exists (select from pg_catalog.pg_roles where rolname = :anAdmUser)
\gexec

select 'alter role ' || :anAdmUser || ' with password ' || :'anAdmPass' || ' login'
\gexec


-- role analytics_auditor
select 'create role ' || :anRoleName || ' with password ' || :'anRolePass' || ' login'
  where not exists (select from pg_catalog.pg_roles where rolname = :anRoleName)
\gexec

select 'alter role ' || :anRoleName || ' with password ' || :'anRolePass' || ' login'
\gexec


-- role audit_service_user
select 'create role ' || :anSvcUser || ' with password ' || :'anSvcPass' || ' login'
  where not exists (select from pg_catalog.pg_roles where rolname = :anSvcUser)
\gexec

select 'alter role ' || :anSvcUser || ' with password ' || :'anSvcPass' || ' login'
\gexec


-- connect to audit db
\c audit


-- extension uuid-ossp
create extension if not exists "uuid-ossp";


-- table audit_event
drop table if exists audit_event cascade;

create table if not exists audit_event
  ( id                                    text not null default uuid_generate_v4()
  , request_id                            text not null
  , application_name                      text not null
  , name                                  text not null
  , type                                  text not null
  , timestamp                             timestamp without time zone not null
  , user_keycloak_id                      text
  , user_name                             text
  , user_drfo                             text
  , source_system                         text
  , source_application                    text
  , source_business_process               text
  , source_business_process_definition_id text
  , source_business_process_instance_id   text
  , source_business_activity              text
  , source_business_activity_id           text
  , context                               text
  , received                              timestamp without time zone not null default now()
  , constraint audit_event__id__pk primary key (id)
  , constraint audit_event__type__ck check (type in ('USER_ACTION', 'SECURITY_EVENT'))
  );

comment on column audit_event.id                                    is 'Ідентифікатор події в БД';
comment on column audit_event.request_id                            is 'Ідентифікатор запиту з MDC';
comment on column audit_event.application_name                      is 'Назва додатку, який генерує подію';
comment on column audit_event.name                                  is 'Назва події';
comment on column audit_event.type                                  is 'Тип події';
comment on column audit_event.timestamp                             is 'Час, коли сталась подія';
comment on column audit_event.user_keycloak_id                      is 'Ідентифікатор користувача';
comment on column audit_event.user_name                             is 'ПІБ користувача, з яким асоційована подія';
comment on column audit_event.user_drfo                             is 'ДРФО користувача';
comment on column audit_event.source_system                         is 'Назва системи';
comment on column audit_event.source_application                    is 'Назва додатку';
comment on column audit_event.source_business_process               is 'Назва бізнес процесу';
comment on column audit_event.source_business_process_definition_id is 'Ідентифікатор типу бізнес процесу';
comment on column audit_event.source_business_process_instance_id   is 'Ідентифікатор запущеного бізнес процесу';
comment on column audit_event.source_business_activity              is 'Назва кроку в бізнес процесі';
comment on column audit_event.source_business_activity_id           is 'Ідентифікатор кроку в бізнес процесі';
comment on column audit_event.context                               is 'JSON представлення деталей події';
comment on column audit_event.received                              is 'Час, коли повідомлення було записано в БД';


-- view audit_event_user_action_v
create or replace view audit_event_user_action_v as
select id
     , request_id
     , application_name
     , name
     , type
     , timestamp
     , user_keycloak_id
     , user_name
     , user_drfo
     , source_system
     , source_application
     , source_business_process
     , source_business_process_definition_id
     , source_business_process_instance_id
     , source_business_activity
     , source_business_activity_id
     , context::jsonb ->> 'action'::text    as action
     , context::jsonb ->> 'step'::text      as step
     , context::jsonb ->> 'tablename'::text as tablename
     , context::jsonb ->> 'row_id'::text    as row_id
     , context::jsonb ->> 'fields'::text    as fields
     , context::jsonb 						as cntx
  from audit_event
  where type = 'USER_ACTION'::text;


-- view audit_event_security_event_v
create or replace view audit_event_security_event_v as
select id
     , request_id
     , application_name
     , name
     , type
     , timestamp
     , user_keycloak_id
     , user_name
     , user_drfo
     , source_system
     , source_application
     , source_business_process
     , source_business_process_definition_id
     , source_business_process_instance_id
     , source_business_activity
     , source_business_activity_id
     , context::jsonb ->> 'action'::text    as action
     , context::jsonb 						as cntx
  from audit_event
  where type = 'SECURITY_EVENT'::text;


-- revoke
revoke connect on database audit from public;
revoke all on audit_event from public;
revoke all on audit_event_user_action_v from public;
revoke all on audit_event_security_event_v from public;


-- grants
-- role analytics_admin
select 'grant connect on database audit to ' || :anAdmUser
\gexec

-- role analytics_auditor
select 'grant connect on database audit to ' || :anRoleName
\gexec
select 'grant select on audit_event_user_action_v to ' || :anRoleName
\gexec
select 'grant select on audit_event_security_event_v to ' || :anRoleName
\gexec

-- role audit_service_user
select 'grant connect on database audit to ' || :anSvcUser
\gexec
select 'grant insert on audit_event to ' || :anSvcUser
\gexec

