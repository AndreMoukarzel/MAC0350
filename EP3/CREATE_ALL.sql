CREATE DATABASE pessoas;
CREATE DATABASE access;
CREATE DATABASE curriculum;
CREATE DATABASE inter_acc_peo;
CREATE DATABASE inter_peo_cur;

\c pessoas
\i MODULE_PEOPLE.sql

\c access
\i MODULE_ACCESS.sql

\c curriculum
\i MODULE_CURRICULUM.sql

\c inter_acc_peo
\i INTER_MOD_ACC_PEO.sql

\c inter_peo_cur
\i INTER_MOD_PEO_CUR.sql