--liquibase formatted sql
--changeset platform:create-other-extensions
-- extension pg_stat_statements and postgis
create extension if not exists pg_stat_statements;