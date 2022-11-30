#!/bin/bash

sqlite3 ./arch.db <<EOF
create table eigen_sandwich (blockNumber varchar(20), profit FLOAT, date varchar(20), symbols varchar(20), address_1 varchar(70), address_2 varchar(70));
EOF