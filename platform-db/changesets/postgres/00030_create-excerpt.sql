--liquibase formatted sql
--changeset platform:create-excerpt-roles context:"pub"
--validCheckSum: ANY
-- role excerpt_exporter
create role ${excerptExporterUser} with password '${excerptExporterPass}' login;
-- role excerpt_service_user
create role ${excerptSvcUser} with password '${excerptSvcPass}' login;
-- role excerpt_worker_user
create role ${excerptWorkUser} with password '${excerptWorkPass}' login;

--changeset platform:create-excerpt-db runInTransaction:false context:"pub"
create database excerpt;