#!/bin/bash

# 创建 cert 文件夹
init_cert(){
  if [ ! -d "${cert_dir}" ]; then
    mkdir "${cert_dir}"
  fi
}
# 获取 env 配置信息
get_config()
{
  param=$1
  value=$(sed -E '/^#.*|^ *$/d' "${env_file}" | awk -F "${param}=" "/${param}=/{print \$2}" | tail -n1)
  echo "$value"
}

# 创建根证书
create_ca() {
  # 查看是否有根证书，没有则创建证书
  if [ ! -f "${cert_config_dir}/ca.zip" ] ; then
    echo "Creating CA";
    docker run --rm -it -v "${cert_config_dir}:/usr/share/elasticsearch/config/certs" elasticsearch:"${stack_version}" \
    bin/elasticsearch-certutil ca --silent --pem -out config/certs/ca.zip
    unzip -o "${cert_config_dir}/ca.zip" -d "${cert_config_dir}";
  fi;
  if [ ! -d "${cert_config_dir}/ca" ] ; then
    unzip -o "${cert_config_dir}/ca.zip" -d "${cert_config_dir}";
  fi;
}

create_certs() {
  if [ -f "${cert_config_dir}/cert.zip" ]; then rm "${cert_config_dir}/cert.zip"; fi;
  docker run --rm -it -v "${cert_config_dir}:/usr/share/elasticsearch/config/certs" elasticsearch:"${stack_version}" \
      bin/elasticsearch-certutil cert --silent --pem -out config/certs/cert.zip --in config/certs/instances.yml \
      --ca-cert config/certs/ca/ca.crt --ca-key config/certs/ca/ca.key;
}

create() {
  init_cert
  create_ca
  create_certs
}

deploy() {
  unzip -o "${cert_config_dir}/ca.zip" -d "${cert_dir}";
  unzip -o "${cert_config_dir}/cert.zip" -d "${cert_dir}";
}

base_path="$(cd "$(dirname "$0")"||exit;pwd)"
env_file="${base_path}/.env"
cert_config_dir="${base_path}/cert_config"
cert_dir="${base_path}/certs"
stack_version=$(get_config STACK_VERSION)

# 生成 ca 和数字证书
create
# 将证书解压到 certs 文件夹
deploy
