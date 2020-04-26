# Server: CentOS 7.6

# 1. ModSecurity
# http://www.modsecurity.cn/practice/post/11.html
echo '---Start install ModSecurity---'

yum install -y git wget epel-release
yum install -y gcc-c++ flex bison yajl yajl-devel curl-devel curl GeoIP-devel doxygen zlib-devel pcre-devel lmdb-devel libxml2-devel ssdeep-devel lua-devel libtool autoconf automake

cd /usr/local
git clone https://github.com/SpiderLabs/ModSecurity
cd ModSecurity
git checkout -b v3/master origin/v3/master
git submodule init
git submodule update
sh build.sh
./configure
make
make install

echo '---End install ModSecurity---'

# 2. ModSecurity-nginx
echo '---Start install ModSecurity-nginx---'

cd /usr/local
git clone https://github.com/SpiderLabs/ModSecurity-nginx

echo '---End install ModSecurity-nginx---'

# 3. OpenResty
#https://openresty.org/cn/installation.html
echo '---Start install OpenResty---'

yum install -y pcre-devel openssl-devel gcc curl

cd /usr/local
wget https://openresty.org/download/openresty-1.15.8.3.tar.gz
tar -xzvf openresty-1.15.8.3.tar.gz

cd /usr/local/openresty-1.15.8.3
./configure --prefix=/usr/local/openresty \
            --with-luajit \
            --without-http_redis2_module \
            --add-module=/usr/local/ModSecurity-nginx
gmake
gmake install

mkdir -p /usr/local/openresty/nginx/conf/modsecurity
cp /usr/local/ModSecurity/modsecurity.conf-recommended /usr/local/openresty/nginx/conf/modsecurity/modsecurity.conf
cp /usr/local/ModSecurity/unicode.mapping /usr/local/openresty/nginx/conf/modsecurity/unicode.mapping
cd /usr/local
wget http://www.modsecurity.cn/download/corerule/owasp-modsecurity-crs-3.3-dev.zip
unzip owasp-modsecurity-crs-3.3-dev.zip
cp /usr/local/owasp-modsecurity-crs-3.3-dev/crs-setup.conf.example /usr/local/openresty/nginx/conf/modsecurity/crs-setup.conf
cp -r /usr/local/owasp-modsecurity-crs-3.3-dev/rules /usr/local/openresty/nginx/conf/modsecurity/rules
cd /usr/local/openresty/nginx/conf/modsecurity/rules
mv REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf
mv RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf.example RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf

echo '---End install OpenResty---'

# 4. NGX_LUA_WAF
# https://github.com/unixhot/waf
echo '---Start install ngx_lua_waf---'

cd /usr/local
git clone https://github.com/unixhot/waf
mkdir -p /usr/local/openresty/nginx/conf/ngx_lua_waf
cp -a /usr/local/waf/waf/* /usr/local/openresty/nginx/conf/ngx_lua_waf
mkdir -p /var/log/ngx_lua_waf
chown -R nobody /var/log/ngx_lua_waf
chgrp -R nobody /var/log/ngx_lua_waf
chmod -R 775 /var/log/ngx_lua_waf

echo '---End install ngx_lua_waf---'

# 5. Config
echo '---Start config---'

cd /usr/local
git clone https://github.com/sec-cactus/oswaf
cp /usr/local/oswaf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
cp /usr/local/oswaf/config.lua /usr/local/openresty/nginx/conf/ngx_lua_waf
cp /usr/local/oswaf/modsecurity.conf /usr/local/openresty/nginx/conf/modsecurity/modsecurity.conf
cp /usr/local/oswaf/openresty.service /usr/lib/systemd/system/openresty.service

ln -s /usr/local/openresty/lualib /usr/local/lib/lua
ln -s /usr/local/openresty/lualib/resty /usr/local/openresty/nginx/conf/ngx_lua_waf/resty

echo '---End config---'

# 6. Run and Test
echo '---Start Run and Test---'

/usr/local/openresty/nginx/sbin/nginx -t
systemctl start openresty
#/usr/local/openresty/nginx/sbin/nginx -s reload 
#systemctl restart openresty

curl 'http://localhost/?param=%22%3E%3Cscript%3Ealert(1);%3C/script%3E'
curl 'http://localhost/?id=../etc/passwd'
cat /var/log/modsec_audit.log
cat /var/log/ngx_lua_waf/XXX.log

echo '---Exit---'

