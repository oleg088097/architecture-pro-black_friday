#!/bin/bash

docker compose exec -T router1 mongosh --port 27017 --quiet <<EOF
sh.addShard( "shard1/shard1:27018");
sh.addShard( "shard2/shard2:27018");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "_id" : "hashed" } );
EOF

docker compose exec -T router2 mongosh --port 27017 --quiet <<EOF
sh.addShard( "shard1/shard1:27018");
sh.addShard( "shard2/shard2:27018");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "_id" : "hashed" } );
EOF

docker compose exec -T router3 mongosh --port 27017 --quiet <<EOF
sh.addShard( "shard1/shard1:27018");
sh.addShard( "shard2/shard2:27018");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "_id" : "hashed" } );
EOF
