// provider running on :4432
CREATE DATABASE test2;

CREATE EXTENSION pglogical;

CREATE TABLE test(id INT PRIMARY KEY,name TEXT);

SELECT pglogical.create_node(
    node_name := 'provider',
    dsn := 'host=localhost port=4432 dbname=sample'
);

select pglogical.replication_set_add_table(set_name := 'default', relation := 'sample' , synchronize_data := 'true');

INSERT INTO test VALUES (1,'selva');

INSERT INTO test VALUES (2,'jill');

// Subscriber running on port:4433

CREATE EXTENSION pglogical;

CREATE TABLE tbl (id int primary key,name varchar);

SELECT pglogical.create_node (
    node_name := 'subscriber1',
    dsn := 'host=localhost port=4433dbname=sub1'
);

SELECT pglogical.create_subscription (
    subscription_name := 'subscription1',
    provider_dsn := 'host=localhost port=4433 dbname=prov'
);

SELECT * FROM sample;

