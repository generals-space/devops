# docker部署文档(二)

> 文档内容请拷贝到[作业部落](https://www.zybuluo.com/mdeditor)以获得更好的排版格式和阅读效果.

将工程包单独挂载出来, 运行环境依然打成镜像.

## 1. etlloader

```
docker run -d --restart=always \
--net huoshu --ip 172.21.1.4 -p 8380:8380 \
-e ORACLE_ADDR=172.16.4.101 \
-v /opt/apps/etlloader:/opt/etlloader \
-v /var/log/etlloader:/opt/etlloader/consolelog \
reg01.sky-mobi.com/huoshu/etlloader-separate:1.0.0
```

`/opt/apps/etlloader`的目录结构

```
.
├── exe.jar
├── exe.sh
├── run.jar
└── run.sh
```

## 2. tomcat工程

由于webapps目录下的访问路径与工程包名不同, 所以需要事先将war包解压, 而不是选择在tomcat启动时自动解压.

...宿主机上不一定有jdk, `jar`命令不能用, 还是打成tar包再上传吧.

`hdc-manager`

war包解压后放在`/opt/apps`目录下, 即工程全路径为`/opt/apps/hdc-manager`

```
docker run -d --restart=always \
--net huoshu --ip=172.21.1.2 -p 8180:8080 \
-v /opt/apps/hdc-manager:/usr/local/apache-tomcat-8.5.4/webapps/se \
-v /var/log/hdc-manager:/usr/local/apache-tomcat-8.5.4/logs \
-e ORACLE_ADDR=172.16.4.101 \
reg01.sky-mobi.com/huoshu/tomcat:latest
```

`skydata-se`

war包解压后放在`/opt/apps`目录下, 即工程全路径为`/opt/apps/skydata-se`

```
docker run -d --restart=always \
--net huoshu --ip=172.21.1.3 -p 8280:8080 \
-v /opt/apps/skydata-se:/usr/local/apache-tomcat-8.5.4/webapps/skydata \
-v /var/log/skydata-se:/usr/local/apache-tomcat-8.5.4/logs \
-e ORACLE_ADDR=172.16.4.101 \
reg01.sky-mobi.com/huoshu/tomcat:latest
```

最终`/opt/apps`目录的成员如下

```
front
    ├── bi_FE
    ├── hdc_FE
    └── nginx.conf.d
        ├── bi.conf
        └── hdc.conf
hdc-manager
    ├── index.jsp
    ├── META-INF
    └── WEB-INF
skydata-se
    ├── index.jsp
    ├── execl
    ├── META-INF
    └── WEB-INF
etlloader
    ├── exe.jar
    ├── exe.sh
    ├── run.jar
    └── run.sh
```

## 脚本部署

```
docker run -d -v /opt/apps/hdc-manager:/usr/local/apache-tomcat/webapps/se tomcat:lates



## 删除
docker rm etlloader
## 移除旧工程包
rm -rf /opt/apps/etlloader
## 拷贝新工程包
cp -r ./etlloader /opt/apps
## 启动新工程
docker run -d xxxxxx reg01.xxx.com/etlloader-datax:latest
```