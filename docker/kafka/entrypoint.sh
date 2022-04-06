#!/bin/bash

set -e

# Rename the config if it exist
if [[ -f "$KAFKA_CONF_DIR/server.properties" ]]; then
    mv "$KAFKA_CONF_DIR/server.properties" "$KAFKA_CONF_DIR/server.properties_`date +%Y-%m-%d`"
    if [ $? -eq 0 ];then
      echo "Rename $KAFKA_CONF_DIR/server.properties to $KAFKA_CONF_DIR/server.properties_`date +%Y-%m-%d` success"
    else
      echo "Rename $KAFKA_CONF_DIR/server.properties to $KAFKA_CONF_DIR/server.properties_`date +%Y-%m-%d` faile"
      exit
    fi
fi

# Generate the config only if it doesn't exist
if [[ ! -f "$KAFKA_CONF_DIR/server.properties" ]]; then
    CONFIG="$KAFKA_CONF_DIR/server.properties"
    {
        echo "broker.id=$KAFKA_BROKER_ID"
        echo "port=$KAFKA_CLIENT_PORT"
        echo "log.dirs=$KAFKA_LOG_DIRS"
        echo "num.network.threads=$KAFKA_NUM_NETWORK_THREADS"
        echo "num.io.threads=$KAFKA_NUM_IO_NETWORKS"
        echo "socket.send.buffer.bytes=$KAFKA_SOCKET_SEND_BUFFER_BYTES"
        echo "socket.receive.buffer.bytes=$KAFKA_RECEIVER_BUFFER_BYTES"
        echo "socket.request.max.bytes=$KAFKA_REQUEST_MAX_BYTES"
        echo "log.flush.interval.messages=$KAFKA_LOG_FLUSH_INTERVAL_MESSAGE"
        echo "log.flush.interval.ms=$KAFKA_LOG_FLUSH_INTERVAL_MS"
        echo "num.recovery.threads.per.data.dir=$KAFKA_RECOVERY_THREADS_PER_DATA_DIR"
        echo "log.retention.hours=$KAFKA_LOG_RETENTION_HOURS"
        echo "log.roll.hours=$KAFKA_ROLL_HOURS"
        echo "log.segment.bytes=$KAFKA_LOG_SEGMENT_BYTES"
        echo "log.retention.check.interval.ms=$KAFKA_LOG_RETENTION_CHECK_INTERVAL_MS"
        echo "log.cleaner.enable=$KAFKA_CLEANER_ENABLE"
        echo "delete.topic.enable=$KAFKA_DELETE_TOPIC_ENABLE"
        echo "transaction.max.timeout.ms=$KFAFKA_TRANSACTION_MAX_TIMEOUT_MS"
        echo "offsets.topic.replication.factor=$KAFKA_OFFSET_TOPIC_REP_FACTOR"
        echo "offsets.topic.num.partitions=$KAFKA_OFFSET_TOPIC_NUM_PARTITIONS"
        echo "transaction.state.log.replication.factor=$KAFKA_TRANSACTION_STATE_LOG_REPL_FACTOR"
        echo "transaction.state.log.min.isr=$KAFKA_TRANSACTION_STATE_LOG_MIN_ISR"
        echo "zookeeper.connection.timeout.ms=$KAFKA_CONNECT_ZOOKEEPER_TIMEOUT"
        echo "zookeeper.session.timeout.ms=$KAFKA_SESSION_ZOOKEEPER_TIMEOUT"
        echo "zookeeper.set.acl=$KAFKA_CONNECT_ZOOKEEPER_ACL"
    } >> "$CONFIG"

    if [[ ! -z $KAFKA_CONNECT_ZOOKEEPER_ADDRESS ]]; then
        zookeeper_server=`echo "$KAFKA_CONNECT_ZOOKEEPER_ADDRESS" | sed -e 's/,$//g'`
        echo "zookeeper.connect=$zookeeper_server" &>> "$CONFIG"
      else
        echo "Connection Zookeeper Address Cannot Be Empty.."
        exit
    fi
fi
