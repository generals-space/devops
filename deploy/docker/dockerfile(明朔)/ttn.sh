## docker build --no-cache=true -f ttn.sh -t generals/ttn:1.0.0 .
FROM generals/golang:latest

RUN source /etc/profile \
    && cd $GOPATH/src \
    ## && go install gopkg.in/redis.v5 \
    ## 注意redis.v5仓库的下载方式
    ## 手动下载ttn
    && mkdir -p $GOPATH/src/github.com/TheThingsNetwork \
    && cd $GOPATH/src/github.com/TheThingsNetwork \
    && git clone https://github.com/generals-space/ttn.git \
    && cd ttn \
    && git checkout master \
    && git clone https://github.com/generals-space/redis.v5.git vendor/gopkg.in/redis.v5 \
    && make dev-deps \
    && go run main.go -h

CMD tail -f /etc/profile