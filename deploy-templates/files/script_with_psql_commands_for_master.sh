#!/bin/bash

psql_parameters="postgres -U $PSQL_USER --host=citus-master"

#Creating DB objects for excerpt db on master
psql $psql_parameters -f /etc/create_excerpt_db_on_master.sql -v excerptExporterUser="'$EXPORTER_USER'" -v excerptExporterPass="'$EXPORTER_PASSWORD'" -v excerptSvcUser="'$EXCERPT_SVC_USER'" -v excerptSvcPass="'$EXCERPT_SVC_PASS'" -v excerptWorkUser="'$EXCERPT_WORK_USER'" -v excerptWorkPass="'$EXCERPT_WORK_PASS'"

#Creating DB objects for settings db on master
psql $psql_parameters -f /etc/create_settings_db_on_master.sql -v settRoleName="'$SETT_ROLE'" -v settRolePass="'$SETT_PASS'"

#Creating DB objects for audit db on master
psql $psql_parameters -f /etc/create_audit_db_on_master.sql -v anSvcUser="'$AN_SVC_USER'" -v anSvcPass="'$AN_SVC_PASS'" -v anRoleName="'$AN_ROLE'" -v anRolePass="'$AN_PASS'" -v anAdmUser="'$AN_ADM_ROLE'" -v anAdmPass="'$AN_ADM_PASS'"

#Creating all other db objects on master
psql $psql_parameters -f /etc/create_all_others_on_master.sql -v regOwnerName="'$REG_OWNER'" -v regOwnerPass="'$REG_OWNER_PASS'" -v appRoleName="'$APP_ROLE'" -v appRolePass="'$APP_PASS'" -v admRoleName="'$ADM_ROLE'" -v admRolePass="'$ADM_PASS'"