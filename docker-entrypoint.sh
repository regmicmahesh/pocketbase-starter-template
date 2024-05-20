#!/bin/bash
set -e

litestream restore -if-replica-exists -if-db-not-exists -o /data/data.db "${REPLICA_URL}"

exec litestream replicate -exec "api serve --dir /data --http 0.0.0.0:3000"