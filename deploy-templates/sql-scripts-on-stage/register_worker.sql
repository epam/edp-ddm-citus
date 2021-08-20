-- command to invoke script from shell
-- psql -U ${context.citusdb.username} -f /etc/register_worker.sql -v dbName="'${context.registry.name}'" -v workerName="'citus-worker-\$i.citus-workers'"


\set ON_ERROR_STOP


-- check workerName
select :workerName as wn
\gset
select case when :'wn' = '' then
              'do $$ begin raise exception ''%'', ''Parameter "workerName" is empty''; end; $$'
       end
\gexec


-- connect to database
select :dbName as db
\gset
\c :db


-- register worker
select 'select master_add_node(' || :'workerName' || ', 5432)'
\gexec
