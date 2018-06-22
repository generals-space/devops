## docker build --no-cache=true -f gateway-bridge.sh -t generals/gateway-bridge:1.0.0 .
FROM generals/golang:latest

RUN source /etc/profile \
    && cd $GOPATH/src \
    ## && go install gopkg.in/redis.v5 \
    ## 注意redis.v5仓库的下载方式
    && git clone https://github.com/generals-space/redis.v5.git gopkg.in/redis.v5 \
    ## 手动下载ttn
    && mkdir -p $GOPATH/src/github.com/TheThingsNetwork \
    && cd $GOPATH/src/github.com/TheThingsNetwork \
    && git clone https://github.com/generals-space/ttn.git \
    && cd ttn \
    && rm -rf ./vendor/* \
    ## 下载gateway-bridge
    && cd $GOPATH/src/github.com/TheThingsNetwork \
    && git clone https://github.com/generals-space/gateway-connector-bridge.git \
    && cd gateway-connector-bridge \
    && git checkout feature \
    && go get -v

CMD source /etc/profile \
    && cd $GOPATH/src/github.com/TheThingsNetwork/gateway-connector-bridge \ 
    && go run main.go --debug > /tmp/