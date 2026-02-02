#!/bin/bash

docker compose up -d
sleep 30;
echo "Initializing configs"
./init_config.sh
sleep 5;
echo "Initializing shards"
./init_shards.sh
sleep 5;
echo "Initializing routers"
./init_router.sh
sleep 5;
echo "Initializing data"
./init_data.sh
