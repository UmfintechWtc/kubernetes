cluster.name: es
node.name: elasticsearch-0
network.host: 0.0.0.0
node.master: true
node.data: true
http.port: 9200
http.cors.allow-origin: "*"
http.cors.enabled: true
http.max_content_length: 200mb
cluster.initial_master_nodes: ["elasticsearch-0"]
discovery.seed_hosts: ["elasticsearch-0:9300"]
gateway.recover_after_nodes: 1

xpack.security.enabled: true
xpack.license.self_generated.type: basic
xpack.security.transport.ssl.enabled: true
xpack.security.transport.ssl.verification_mode: certificate
xpack.security.transport.ssl.keystore.path: elastic-certificates.p12
xpack.security.transport.ssl.truststore.path: elastic-certificates.p12

network.tcp.keep_alive: true
network.tcp.no_delay: true
transport.tcp.compress: true
cluster.routing.allocation.cluster_concurrent_rebalance: 16
cluster.routing.allocation.node_concurrent_recoveries: 16
