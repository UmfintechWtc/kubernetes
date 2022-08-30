4lw.commands.whitelist=srvr, mntr, ruok
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/opt/app/data/zookeeper
dataLogDir=/opt/app/logs/zookeeper
clientPort=2181
autopurge.snapRetainCount=10
autopurge.purgeInterval=1
{% for address in environments['internal-zookeeper']['hosts']['zookeeper'] %}
{{ address }}
{% endfor %}