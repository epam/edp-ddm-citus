--liquibase formatted sql
--changeset platform:create-registry-schema
create schema if not exists registry;
alter schema registry owner to ${regOwnerName};

alter database ${dbName} set search_path to "$user", registry, public;