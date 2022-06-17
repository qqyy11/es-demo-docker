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
  # 查看是否有证书，没有则创建证书
  if [ ! -f "${cert_dir}/ca.zip" ] ; then
    echo "Creating CA";
    docker run --rm -it -v "${cert_dir}:/usr/share/elasticsearch/config/certs" elasticsearch:"${stack_version}" \
    bin/elasticsearch-certutil ca --silent --pem -out config/certs/ca.zip
    unzip "${cert_dir}/ca.zip" -d "${cert_dir}";
  fi;
  if [ ! -d "${cert_dir}/ca" ] ; then
    unzip "${cert_dir}/ca.zip" -d "${cert_dir}";
  fi;
}

create_certs() {
  docker run --rm -it -v "${cert_dir}:/usr/share/elasticsearch/config/certs" elasticsearch:"${stack_version}" \
      bin/elasticsearch-certutil cert --silent --pem -out config/certs/cert.zip --in config/certs/instances.yml \
      --ca-cert config/certs/ca/ca.crt --ca-key config/certs/ca/ca.key;
    unzip "${cert_dir}/cert.zip" -d "${cert_dir}";
}

create() {
  init_cert
  create_ca
  create_certs
}

base_path="$(cd "$(dirname "$0")"||exit;pwd)"
env_file="${base_path}/.env"
cert_dir="${base_path}/certs"
stack_version=$(get_config STACK_VERSION)

create