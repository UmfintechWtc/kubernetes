[mysqld]
port = 3306
server-id=1
log-bin=mysql-bin
binlog_format     = ROW
binlog-do-db= {{ environments['internal-mysql'].database }}  
default-time_zone='+00:00'
expire_logs_days=1
back_log=300
max_connections=2000
max_connect_errors=1000
#mysql 开启多线程
innodb_read_io_threads=8
innodb_write_io_threads=8
#解决mysql show tables 数据不同步的问题
information_schema_stats_expiry=0
innodb_buffer_pool_size=16G
symbolic-links=0
log-error=/var/log/mysqld.log

