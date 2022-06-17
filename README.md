# elasticsearch-demo
### 生成 certs

1. 在 `.env` 中配置 `STACK_VERSION` （es 版本号）
2. 在 `certs/instances.yml` 文件中配置证书信息
3. 执行 `sh create_ca.sh`

### 启动 elastic search

1. 在 `docket-compose.yml` 中，配好运行参数
2. 执行 `docker-compose up -d` 运行 es