#!/bin/bash

docker compose exec -T configSrv1 mongosh --port 27019 --quiet <<EOF
rs.initiate(
  {
    _id : "config_server",
    configsvr: true,
    members: [
      { _id : 0, host : "configSrv1:27019" },
      { _id : 1, host : "configSrv2:27019" },
      { _id : 2, host : "configSrv3:27019" }
    ]
  }
);
EOF
