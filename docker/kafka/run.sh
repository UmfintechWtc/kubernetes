#!/bin/bash
set -e

source /etc/profile &>> /dev/null

"$KAFKA_CONF_DIR"/../bin/kafka-server-start.sh "$KAFKA_CONF_DIR"/server.properties