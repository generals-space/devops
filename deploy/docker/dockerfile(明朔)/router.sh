## docker build --no-cache=true -f router.sh -t generals/router:1.0.0 .
FROM generals/ttn:latest

CMD source /etc/profile \
    && cd $GOPATH/src/github.com/TheThingsNetwork/ttn \
    && go run main.go router --config /etc/ttn/router/ttn.yml