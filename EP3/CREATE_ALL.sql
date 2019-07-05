CREATE DATABASE pessoas;
CREATE DATABASE access;
CREATE DATABASE curriculum;

\c pessoas
\i MODULE_PEOPLE.sql

\c access
\i MODULE_ACCESS.sql

\c curriculum

CREATE EXTENSION postgres_fdw;

CREATE SERVER server_pessoas FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'localhost', dbname 'pessoas');

CREATE USER MAPPING FOR CURRENT_USER SERVER server_pessoas OPTIONS (user 'dba', password '123');

\i MODULE_CURRICULUM.sql