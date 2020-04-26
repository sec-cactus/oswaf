# 简介
为了便于学习和定制化使用，本项目对多个开源waf进行了整合部署。
Web Server 采用OpenResty，即Nginx+Lua。
安装了ModSecurity，并使用ModSecurity-nginx将ModSecurity安装为OpenResty的模块，使用了owasp-modsecurity-crs防护规则。
部署了ngx_lua_waf，使用了unixhot/waf的防护规则。
相关项目：
https://github.com/SpiderLabs/ModSecurity
https://github.com/SpiderLabs/ModSecurity-nginx
https://openresty.org
https://github.com/unixhot/waf

# 安装
运行环境：CentOS 7.6
```
git clone https://github.com/sec-cactus/oswaf
cd oswaf
./install.sh
```
# 运行
默认启用了ModSecurity和ngx_lua_waf，且优先匹配ModSecurity。
通过调整/usr/local/openresty/nginx/conf/nginx/conf中对各waf的启用情况，调整具体的waf部署。
