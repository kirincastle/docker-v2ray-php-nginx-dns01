# 使用docker-compose以ws+tls方式快速部署科学上网利器v2ray

本文参考了一下网址

https://www.4spaces.org/docker-compose-install-v2ray-ws-tls/

https://github.com/aitlp/docker-v2ray

https://github.com/Jrohy/multi-v2ray

有些都已经是现成的，整合了一下

## 更新日志

* 2020年4月22日：增加了input.sh,用来快速更改需要的参数
* 2020年4月17日: 增加了bitwarden，speedtest测速时候的上传问题还是没有解决。
* 2020年4月9日：增加php7.2-fpm, 使用speedtest，使用 Jrohy/multi-v2ray
* 2020年3月3日：增加v2ray并使用ws+tls方式实现代理服务；
* 2020年3月1日：增加nginx服务并启用certbot证书；

## 使用步骤

1. 安装bbr plus

apt -y install git python3


git clone https://github.com/kirincastle/docker-v2ray-php-nginx.git

cd docker-v2ray-php-nginx \
chmod +x tcp.sh \
./tcp.sh

具体步骤参考下面链接，大同小异，记得在某个界面选“no". 不要问我是哪个界面。

https://www.v2rayssr.com/bbr4in1.html


2. 安装docker-ce并启动

以下操作我都是以root用户进行的。

* 安装

```
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sh get-docker.sh
```

**注：** 这一步如果是CENTOS 8，可能会出现 `requires containerd.io >= 1.2.2-3错误` -> [解决办法](https://www.4spaces.org/docker-ce-install-containerd-io-error/)。

* 添加用户到用户组

```
gpasswd -a $USER docker
```

* 启动

```
systemctl start docker
```

* 设置docker开机自启动

```
systemctl enable docker
```

3. 安装`docker-compose`

```
$  curl -L "https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

#如果vps在国内，可以用国内镜像
curl -L https://get.daocloud.io/docker/compose/releases/download/v2.2.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

$ chmod +x /usr/local/bin/docker-compose

$ ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```

4. 安装git并clone代码

```
apt install git curl jq moreutils net-tools -y


git clone https://github.com/kirincastle/docker-v2ray-php-nginx-dns01.git
```

或者你可以下载后在上传到你的VPS。

5. 修改v2ray配置

进入`v2ray`目录开始修改配置,也可以用input.sh来批量改。

**1) `init-letsencrypt.sh`**

将里面的`yourdomain`和`youremail`修改为自己的域名和邮箱。
注意staging=1的时候，出来的cert是测试用的，如果测试没有问题，就改为staging=0.

**2) `docker-compose.yml`**

可以不用动。

**3) `data/v2ray/config.json`**

修改ID，`"id": "bae399d4-13a4-46a3-b144-4af2c0004c2e"`，还是修改一下吧。

用这个网址来生成version 1 uuid
https://www.uuidgenerator.net/version1

**4) `data/nginx/conf.d/v2ray.conf`**

修改所有`yourdomain`为自己的域名，其他地方，如果上面可以修改的地方你没修改，那么除了域名之外的也不用修改了。

6. 一键部署v2ray

```
chmod +x ./init-letsencrypt.sh

./init-letsencrypt.sh
```

7. 查看v2ray配置:

docker exec v2ray bash -c "v2ray info"

因为用了tls, 所以出来的vmess链接，加入客户端软件之后，要修改端口为443, 底层传输安全为tls.

8. 进行v2ray客户端配置

现在你可以开始使用了。

9. run below cli to get vmess link

./data/v2ray/json2vmess.py -m port:443 -m tls:tls -a yourdomain -m ps:yourdomain --debug ./data/v2ray/config.json

#######

bitwarden 参考以下链接 

apt-get install apache2-utils -y # (for htpasswd)

htpasswd -c ./data/nginx/html/.htpasswd user1

 a. bitwarden's config.json will override env config in docker-compose.yml
 b. 如果要用bitwarden,将docker-compose_with_bitwarden.yml改名为docker-compose.yml，nginx的配置里面，关于bitwarden的也要删掉“#”，再做第6步。

https://github.com/dani-garcia/bitwarden_rs
