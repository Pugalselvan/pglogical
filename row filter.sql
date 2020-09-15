//provider port :4432
CREATE TABLE github_events
(
    event_id bigint,
    event_type text,
    event_public boolean,
    repo_id bigint,
    payload jsonb,
    repo jsonb,
    user_id bigint,
    org jsonb,
    created_at timestamp
);

SELECT pglogical.create_node (
    node_name := 'provider',
    dsn := 'host=localhost port=4432 dbname=provider'
);

SELECT pglogical.replication_set_add_table ( 
    set_name := 'default', relation := 'github_events', synchronize_data := true,
    row_filter := 'id >60'
);

//subscriber :4433

 CREATE TABLE github_events
(
    event_id bigint,
    event_type text,
    event_public boolean,
    repo_id bigint,
    payload jsonb,
    repo jsonb,
    user_id bigint,
    org jsonb,
    created_at timestamp
);

SELECT pglogical.create_node (
    node_name := 'subscriber',
    dsn := 'host=localhost port=4433 dbname=subscriber'
);

SELECT pglogical.create_subscription (
    subscription_name := 'subscription', 
    provider_dsn := 'host=localhost port=4433 dbname=provider'
);

\copy github_events from '/home/pugal/Documents/events.csv' with csv
 
//subscriber :4433
SELECT *FROM github_events;
select count(id) from car;

//prodvider :4432
SELECT *FROM github_events;

