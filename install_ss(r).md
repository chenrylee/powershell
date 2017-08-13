
> 本教程基于CentOS 7 x86_x64写的，没什么参考标准，就是对自己的操作做了流水帐记录。
# 安装Shadowsocks
## 1. 先更新系统版本
```bash
yum -y udate
```
## 2. 检查确认是否已经安装了python
```bash
python --version
```
如果输出了python的版本，由说明已经安装了；如果提示`python: command not found`，则需要安装，命令如下：
```bash
yum -y install python
```
## 3. 安装pip
如果确认已经安装了python，请再安装pip，命令如下
```bash
yum -y install python-setuptools && easy_install pip
```
## 4. 通过pip，安装shadowsocks
```bash
pip install shadowsocks
```
## 5. 运行shadowsocks
```bash
ssserver -p 8338 -m "aes-256-cfg" -k '123456'
```
在客户端配置即可
```json
{
	"server":"xx.xx.xx.xx",
	"port":8338,
	"password":"123456",
	"method":"aes-256-cfb"
}
```

# 安装Shadowsocksr
> 小姐姐已经停更ssr了，并且关了github，所以下载源最好是保存一份，本教程中的下载源目前可用，但不保证以后也是可以的。
## 1. 更新系统
```bash
yum -y udate
```
## 2. 安装wget
```bash
yum -y install wget
```
## 3. 下载源代码
```bash
mkdir /var/downloads
cd /var/downloads
wget https://github.com/shadowsocksrr/shadowsocksr/archive/3.1.2.tar.gz
```
## 4. 解压代码，放到指定位置
```bash
tar zxvf 3.1.2.tar.gz
mv shadowsocksr-3.1.2 /var/local/shadowsocksr
```
## 5. 启动服务
```bash
cd /var/local/shadowsocksr/shadowsocksr
python server.py -p 8338 -k "123456" -m aes-256-cfb -O auth_aes128_md5 -o tls1.2_ticket_auth_compatible
```
> 如果提示`python: command not found`，请参考第一部分第2步安装。

这样，就安装好了，客户端配置如下：
```json
{
	"server":"xx.xx.xx.xx",
	"port":8338,
	"password":"123456",
	"method":"aes-256-cfb",
	"protocol":"auth_aes128_md5",
	"obfs":"tls1.2_ticket_auth"
}
```

如有问题，请自行Google，本人不提供任何服务。
