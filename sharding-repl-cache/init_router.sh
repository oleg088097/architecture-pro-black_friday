#!/bin/bash

docker compose exec -T router1 mongosh --port 27017 --quiet <<EOF
sh.addShard( "shard1/shard1-1:27018,shard1-2:27018,shard1-3:27018");
sh.addShard( "shard2/shard2-1:27018,shard2-2:27018,shard2-3:27018");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "_id" : "hashed" } );
EOF

docker compose exec -T router2 mongosh --port 27017 --quiet <<EOF
sh.addShard( "shard1/shard1-1:27018,shard1-2:27018,shard1-3:27018");
sh.addShard( "shard2/shard2-1:27018,shard2-2:27018,shard2-3:27018");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "_id" : "hashed" } );
EOF

docker compose exec -T router3 mongosh --port 27017 --quiet <<EOF
sh.addShard( "shard1/shard1-1:27018,shard1-2:27018,shard1-3:27018");
sh.addShard( "shard2/shard2-1:27018,shard2-2:27018,shard2-3:27018");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "_id" : "hashed" } );
EOF
