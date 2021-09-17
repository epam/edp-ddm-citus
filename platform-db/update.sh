#!/bin/bash
lb_params="--logLevel=info --databaseChangeLogTableName=ddm_db_changelog --databaseChangeLogLockTableName=ddm_db_changelog_lock"
#Master platform
liquibase --contexts="pub" $lb_params --changeLogFile=changesets/postgres-changelog.xml --username=$DB_NAME --password=$DB_PASS --url=$masterDBurl/postgres update 
liquibase $lb_params --changeLogFile=changesets/audit-changelog.xml --username=$DB_NAME --password=$DB_PASS --url=$masterDBurl/audit update 
liquibase $lb_params --changeLogFile=changesets/settings-changelog.xml --username=$DB_NAME --password=$DB_PASS --url=$masterDBurl/settings update 
liquibase $lb_params --changeLogFile=changesets/excerpt-changelog.xml --username=$DB_NAME --password=$DB_PASS --url=$masterDBurl/excerpt update 
#Replica platform
liquibase --contexts="sub" $lb_params --changeLogFile=changesets/postgres-changelog.xml --username=$DB_NAME --password=$DB_PASS --url=$replicaDBurl/postgres update
#All Master Workers Registry
declare -a arrMaster=($masterWorkers)
for i in "${arrMaster[@]}"
do
    echo "$i"
    liquibase $lb_params --changeLogFile=changesets/worker-postgres-changelog.xml --username=$DB_NAME --password=$DB_PASS --url=$i/postgres update
    liquibase $lb_params --changeLogFile=changesets/worker-registry-changelog.xml --username=$DB_NAME --password=$DB_PASS --url=$i/$dbName update  
done
#All Replica Workers Registry
declare -a arrReplica=($replicaWorkers)
for i in "${arrReplica[@]}"
do
    echo "$i"
    liquibase $lb_params --changeLogFile=changesets/worker-postgres-changelog.xml --username=$DB_NAME --password=$DB_PASS --url=$i/postgres update
    liquibase $lb_params --changeLogFile=changesets/worker-registry-changelog.xml --username=$DB_NAME --password=$DB_PASS --url=$i/$dbName update  
done
#Master Registry
liquibase --contexts="pub" $lb_params --changeLogFile=changesets/registry-changelog.xml --username=$DB_NAME --password=$DB_PASS --url=$masterDBurl/$dbName update 
#Replica Registry
liquibase --contexts="sub" $lb_params --changeLogFile=changesets/registry-changelog.xml --username=$DB_NAME --password=$DB_PASS --url=$replicaDBurl/$dbName update