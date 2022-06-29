--liquibase formatted sql
--changeset platform:create-postgis-extension
create extension if not exists postgis;