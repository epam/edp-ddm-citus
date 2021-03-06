--liquibase formatted sql
--changeset platform:table-ddm_role_permission
CREATE TABLE public.ddm_role_permission (
    permission_id INTEGER GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    role_name TEXT NOT NULL,
    object_name TEXT NOT NULL,
    column_name TEXT,
    operation TYPE_OPERATION NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    CONSTRAINT pk_ddm_role_permission PRIMARY KEY (permission_id)
);

ALTER TABLE public.ddm_role_permission ADD CONSTRAINT iu_ddm_role_permission UNIQUE (role_name, object_name, operation, column_name);

CLUSTER ddm_role_permission USING iu_ddm_role_permission;



--changeset platform:table-ddm_liquibase_metadata
CREATE TABLE public.ddm_liquibase_metadata (
    metadata_id INTEGER GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    change_type TEXT NOT NULL,
    change_name TEXT NOT NULL,
    attribute_name TEXT NOT NULL,
    attribute_value TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    CONSTRAINT pk_ddm_liquibase_metadata PRIMARY KEY (metadata_id)
);

ALTER TABLE public.ddm_liquibase_metadata ADD CONSTRAINT iu_ddm_liquibase_metadata UNIQUE (change_name, change_type, attribute_name, attribute_value);

CLUSTER ddm_liquibase_metadata USING iu_ddm_liquibase_metadata;


--changeset platform:tables-ddm_source
CREATE TABLE public.ddm_source_system (
    system_id UUID NOT NULL,
    system_name TEXT NOT NULL,
    created_by TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    CONSTRAINT pk_ddm_source_system PRIMARY KEY (system_id),
    CONSTRAINT iu_ddm_source_system UNIQUE (system_name)
);

CREATE TABLE public.ddm_source_application (
    application_id UUID NOT NULL,
    application_name TEXT NOT NULL,
    created_by TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    CONSTRAINT pk_ddm_source_application PRIMARY KEY (application_id),
    CONSTRAINT iu_ddm_source_application UNIQUE (application_name)
);

CREATE TABLE public.ddm_source_business_process (
    business_process_id UUID NOT NULL,
    business_process_name TEXT NOT NULL,
    created_by TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    CONSTRAINT pk_ddm_source_business_process PRIMARY KEY (business_process_id),
    CONSTRAINT iu_ddm_source_business_process UNIQUE (business_process_name)
);