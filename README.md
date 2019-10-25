## INSTALL



* Require geoip-devel >= 1.6.5
* For CentOS 7, you can use these packages form Atomic Repo
Download latest atomic-release rpm from
http://www6.atomicorp.com/channels/atomic/centos/7/x86_64/RPMS/
Install atomic-release rpm:
# rpm -Uvh atomic-release*rpm
Install GeoIP-devel rpm package:
# yum install GeoIP-devel

https://github.com/leafo/luajit-geoip

## CONFIG WITH KONG

```
luarocks make 
```
