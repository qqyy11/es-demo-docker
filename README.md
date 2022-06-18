# elasticsearch-demo
### 生成 certs

1. 在 `.env` 中配置 `STACK_VERSION` （es 版本号）
2. 在 `cert_config/instances.yml` 将部署服务器的域名和 ip 填到配置中
3. 执行 `sh ca_maker.sh` 生成数字证书(如果需要生成新的证书，将 `cert_config/ca.zip` 文件删除即可)

### docker-compose.yml 示例

示例文件存在 `examples` 目录下

#### sigleCluster

单机 es 集群

#### sigleNode

单节点 es 服务, 也可作为节点加入集群

### 启动 elastic search

1. 在 `docket-compose.yml` 中，配好运行参数
2. 执行 `docker-compose up -d` 运行 es
