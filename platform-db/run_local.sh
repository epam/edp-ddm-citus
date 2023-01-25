#Liquibase changelog Property Substitution
export anAdmName="analytics_admin"
export anAdmPass="analytics_admin"
export anRoleName="analytics_auditor"
export anRolePass="analytics_auditor"
export anSvcName="audit_service_user"
export anSvcPass="audit_service_user"
export settRoleName="settings_role"
export settRolePass="settings_role"
export excerptExporterName="excerpt_exporter"
export excerptExporterPass="excerpt_exporter"
export excerptSvcName="excerpt_service_user"
export excerptSvcPass="excerpt_service_user"
export excerptWorkName="excerpt_worker_user"
export excerptWorkPass="excerpt_worker_user"
export notificationTemplatePublisherName="notification_template_publisher_user"
export notificationTemplatePublisherPass="notification_template_publisher_user"
export notificationServiceName="notification_service_user"
export notificationServicePass="notification_service_user"
export regOwnerName="registry_owner_role"
export regOwnerPass="registry_owner_role"
export regTemplateOwnerName="registry_template_owner_role"
export regTemplateOwnerPass="registry_template_owner_role"
export appRoleName="application_role"
export appRolePass="application_role"
export admRoleName="admin_role"
export admRolePass="admin_role"
export dbName="registry"
export archiveSchema="archive"
export pubHost="master"
export pubUser="postgres"
export pubPort="5432"
export histRoleName="historical_data_role"
export histRolePass="historical_data_role"
export processHistoryRoleName="process_history_role"
export processHistoryRolePass="process_history_role"
export geoserverRoleName="geoserver_role"
export geoserverRolePass="geoserver_role"
#DB
export DB_NAME="postgres"
export DB_PASS_OP="postgres"
export masterDBurl="jdbc:postgresql://master:5432"
export replicaDBurl="jdbc:postgresql://replica:5432"
export masterWorkers=""
#"jdbc:postgresql://worker-0:5432 jdbc:postgresql://worker-1:5432"
export replicaWorkers=""
#"jdbc:postgresql://worker-rep-0:5432 jdbc:postgresql://worker-rep-1:5432"
#run lb
./update.sh
