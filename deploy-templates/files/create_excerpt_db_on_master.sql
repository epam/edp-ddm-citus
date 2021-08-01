-- database
select 'create database excerpt'
  where not exists (select from pg_database where datname = 'excerpt')
\gexec


-- role excerpt_exporter
select 'create role ' || :excerptExporterUser || ' with password ' || :'excerptExporterPass' || ' login'
  where not exists (select from pg_catalog.pg_roles where rolname = :excerptExporterUser)
\gexec

select 'alter role ' || :excerptExporterUser || ' with password ' || :'excerptExporterPass' || ' login'
\gexec


-- role excerpt_service_user
select 'create role ' || :excerptSvcUser || ' with password ' || :'excerptSvcPass' || ' login'
  where not exists (select from pg_catalog.pg_roles where rolname = :excerptSvcUser)
\gexec

select 'alter role ' || :excerptSvcUser || ' with password ' || :'excerptSvcPass' || ' login'
\gexec


-- role excerpt_worker_user
select 'create role ' || :excerptWorkUser || ' with password ' || :'excerptWorkPass' || ' login'
  where not exists (select from pg_catalog.pg_roles where rolname = :excerptWorkUser)
\gexec

select 'alter role ' || :excerptWorkUser || ' with password ' || :'excerptWorkPass' || ' login'
\gexec


-- connect to excerpt db
\c excerpt


-- extension uuid-ossp
create extension if not exists "uuid-ossp";


-- table excerpt_template
create table if not exists excerpt_template (
	id uuid not null default uuid_generate_v4(),
	template_name text not null,
	"template" text not null,
	created_at timestamptz not null default now(),
	updated_at timestamptz not null default now(),
	checksum text not null,
	constraint excerpt_template__id__pk primary key (id),
	constraint excerpt_template__template_name__uk unique (template_name)
);


-- table excerpt_record
create table if not exists excerpt_record (
	id uuid not null default uuid_generate_v4(),
	status text null,
	status_details text null,
	keycloak_id text null,
	checksum text null,
	excerpt_key text null,
	created_at timestamptz not null default now(),
	updated_at timestamptz not null default now(),
	signature_required bool null,
	x_source_system text null,
	x_source_application text null,
	x_source_business_process text null,
	x_source_business_activity text null,
	constraint excerpt_record__id__pk primary key (id)
);


-- revoke
revoke all on excerpt_template from public;
revoke all on excerpt_record from public;


-- grants
-- role excerpt_exporter
select 'grant select, insert, update, delete on excerpt_template to ' || :excerptExporterUser
\gexec

-- role excerpt_service_user
select 'grant select on excerpt_template to ' || :excerptSvcUser
\gexec
select 'grant select, insert on excerpt_record to ' || :excerptSvcUser
\gexec

-- role excerpt_worker_user
select 'grant select on excerpt_template to ' || :excerptWorkUser
\gexec
select 'grant select, update on excerpt_record to ' || :excerptWorkUser
\gexec
