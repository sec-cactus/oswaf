# 简介
为了便于学习和定制化使用，本项目对多个开源waf进行了整合部署。<br/>
Web Server 采用OpenResty，即Nginx+Lua。<br/>
安装了ModSecurity，并使用ModSecurity-nginx将ModSecurity安装为OpenResty的模块，使用了owasp-modsecurity-crs防护规则。<br/>
部署了ngx_lua_waf，使用了unixhot/waf的防护规则。<br/>
相关项目：<br/>
https://github.com/SpiderLabs/ModSecurity<br/>
https://github.com/SpiderLabs/ModSecurity-nginx<br/>
https://openresty.org<br/>
https://github.com/unixhot/waf<br/>

# 安装
运行环境：CentOS 7.6
```
cd /usr/local
git clone https://github.com/sec-cactus/oswaf
cd oswaf
./install.sh
```
# 运行
默认启用了ModSecurity和ngx_lua_waf，且优先匹配ModSecurity。<br/>
通过调整/usr/local/openresty/nginx/conf/nginx/conf中对各waf的启用情况，调整具体的waf部署。
