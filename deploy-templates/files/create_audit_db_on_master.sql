-- database
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

/* NB.
   - all ojects in audit db (extension uuid-ossp, table audit_event, views audit_event_user_action_v and audit_event_security_event_v)
   - all needed grants
   are created by LB from audit.xml

*/

