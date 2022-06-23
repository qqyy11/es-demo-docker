# elasticsearch-demo

## 依赖

- docker
- docker compose

## 生成 certs

1. 在 `.env` 中配置 `STACK_VERSION` （es 版本号）
2. 在 `cert_config/instances.yml` 将部署服务器的域名和 ip 填到配置中
3. 执行 `sh ca_maker.sh` 生成数字证书(如果需要生成新的证书，将 `cert_config/ca.zip` 文件删除即可)

## docker-compose.yml 示例

示例文件存在 `examples` 目录下

- `sigleCluster` 单机 es 集群
- `node` 单节点 es 服务, 也可作为节点加入集群
- `kibana` kibana 示例

## 启动 elastic search

1. 在 `docket-compose.yml` 中，配好节点信息, 主要是以下几个  
   - `node.name` 当前节点名称，集群中每一个节点都需要有不同的名称  
   - `cluster.name` 集群名称  
   - `cluster.initial_master_nodes` 可选举为 master 的节点  
   - `discovery.seed_hosts` 从哪些域名端口发现节点  
   - `network.publish_host` 本机ip，集群之间交互使用  
2. 将生成的 cert 文件配置到 xpack 的参数下
3. 执行 `docker-compose up -d` 运行 es
