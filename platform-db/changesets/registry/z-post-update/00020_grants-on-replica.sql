--liquibase formatted sql
--changeset platform:hist-role-post-deploy-grants context:"sub"
grant usage on schema registry to ${histRoleName};
