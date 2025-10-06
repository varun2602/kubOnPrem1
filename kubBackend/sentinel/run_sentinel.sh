#!/bin/bash

CONTAINER_NAME=$1
echo "Starting Redis Sentinel ($CONTAINER_NAME) using standard server command..."

# --- BEGIN: Connection Check and Retry Loop ---
MASTER_HOST="redisMaster1"  # <--- FIX 3: Corrected Docker service name
MASTER_PORT="6379"
MAX_RETRIES=15
RETRY_COUNT=0

echo "Waiting for $MASTER_HOST:$MASTER_PORT to be available..."

# FIX 2: Use redis-cli PING instead of nc, which is not installed.
while ! redis-cli -h $MASTER_HOST -p $MASTER_PORT PING; do
  if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
    echo "Error: $MASTER_HOST:$MASTER_PORT not available after $MAX_RETRIES attempts. Exiting."
    exit 1
  fi
  echo "Retrying connection to $MASTER_HOST:$MASTER_PORT in 1 second..."
  sleep 1
  RETRY_COUNT=$((RETRY_COUNT + 1))
done

echo "$MASTER_HOST:$MASTER_PORT is available."

# --- DNS Settle Wait ---
echo "Waiting 5 seconds for DNS resolution to fully settle..."
sleep 20
# --- END DNS Settle Wait ---

echo "Starting Sentinel."
# --- END: Connection Check and Retry Loop ---

# EXEC replaces the shell process with the redis-server process.
exec redis-sentinel /sentinel/sentinel.conf --sentinel
