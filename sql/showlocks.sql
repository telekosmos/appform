-- SELECT relation, transaction, pid, mode, granted, relname
select relation, transactionid, virtualtransaction, pid, mode, granted
FROM pg_locks
INNER JOIN pg_stat_user_tables
ON pg_locks.relation = pg_stat_user_tables.relid;

-- to get the proccess using dbName
-- select pg_terminate_backend(procpid) from pg_stat_activity where datname = 'dbName'; 
/*
-- even better
SELECT pg_terminate_backend( procpid )
FROM pg_stat_activity
WHERE procpid <> pg_backend_pid( )    -- 1. don't terminate your own session
    AND datname =                     -- 2. don't terminate connections to 
    (SELECT datname                   --    other databases in the cluster
       FROM pg_stat_activity
      WHERE procpid = pg_backend_pid( )
    );
*/