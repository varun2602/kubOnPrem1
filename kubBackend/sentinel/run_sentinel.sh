#!/bin/bash

# Ensure the generic sentinel.conf file is used
cp /sentinel/sentinel.conf /sentinel/running.conf

# This command starts Redis Sentinel in the foreground,
# which keeps the container running indefinitely.
exec redis-sentinel /sentinel/running.conf