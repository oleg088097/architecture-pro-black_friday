#!/bin/bash

###
# Инициализируем бд
###

docker compose exec -T router1 mongosh --port 27017 --quiet <<EOF
use somedb;
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i});
db.helloDoc.countDocuments();
EOF
