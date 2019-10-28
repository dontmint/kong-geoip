This plugin use to allow/deny access by country base on luajit-geoip library. There is also an option to inject `country_code` using header to upstream request for MY use case.

## **INSTALL**

* **I. Dependencies**

**`geoip-devel >= 1.6.5`**
> For CentOS 7, you can use these packages form Atomic Repo
```
Download latest atomic-release rpm from
# http://www6.atomicorp.com/channels/atomic/centos/7/x86_64/RPMS/
Install atomic-release rpm:
# rpm -Uvh atomic-release*rpm
Install GeoIP-devel rpm package:
# yum install GeoIP-devel
```
> If Atomic Repo is unreachable, you can use **.rpm** file in **RPMS** folder that I downloaded.
```
yum install RPMS/*.rpm
```

**`luaJit-GeoIP`**
```
luarocks install --server=http://luarocks.org/manifests/leafo geoip
```
> OR use this **.rock** file
```
luarocks install ROCK/geoip-dev-1.all.rock
```

* **II. Install this Plugin**
```
git clone https://github.com/dontmint/kong-geoip.git
cd kong-geoip
luarocks make
```

## **CONFIG PLUGIN**

* **III. Enable in Kong and restart**

```conf
vim /etc/kong/kong.conf

...
plugins = bundled,geoip
```

```
kong restart
```

* **IV. Plugin configuration**

**mode**
+ `Whitelist` : Block all country but allow `whitelist_countries`
+ `Blacklist` : Allow all country but block `blacklist_countries`

```
http --form POST http://kong:8001/[services/routes]/[services-id/route-id]/plugins \
name=geoip \
config.mode=Whitelist \
config.Whitelist:=["VN","US"] \
```


