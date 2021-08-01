\c excerpt

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- table excerpt_template
CREATE TABLE public.excerpt_template (
	id uuid NOT NULL DEFAULT uuid_generate_v4(),
	template_name text NOT NULL,
	"template" text NOT NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	checksum text NOT NULL,
	CONSTRAINT pk_excerpt_template__id PRIMARY KEY (id),
	CONSTRAINT uk_excerpt_template__template_name UNIQUE (template_name)
);

-- table excerpt_record
CREATE TABLE public.excerpt_record (
	id uuid NOT NULL DEFAULT uuid_generate_v4(),
	status text NULL,
	status_details text NULL,
	keycloak_id text NULL,
	checksum text NULL,
	excerpt_key text NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	signature_required bool NULL,
	x_source_system text NULL,
	x_source_application text NULL,
	x_source_business_process text NULL,
	x_source_business_activity text NULL,
	CONSTRAINT pk_excerpt_record__id PRIMARY KEY (id)
);

-- revoke
revoke all on excerpt_template from public;
revoke all on excerpt_record from public;

-- grants
-- role excerpt_exporter
grant select, insert, update, delete on excerpt_template to excerpt_exporter;

-- role excerpt_service_user
grant select on excerpt_template to excerpt_service_user;
grant select, insert on excerpt_record to excerpt_service_user;

-- role excerpt_worker_user
grant select on excerpt_template to excerpt_worker_user;
grant select, update on excerpt_record to excerpt_worker_user;