FROM golang:1.11-alpine3.9 as builder
RUN mkdir -p /go/src/github.com/mendersoftware/deviceauth
WORKDIR /go/src/github.com/mendersoftware/deviceauth
ADD ./ .
RUN CGO_ENABLED=0 GOARCH=amd64 go build -o deviceauth .

FROM alpine:3.9
EXPOSE 8080
# mount your private key at /etc/deviceauth/rsa/private.pem
RUN mkdir -p /etc/deviceauth/rsa
COPY ./config.yaml /etc/deviceauth/
COPY --from=builder /go/src/github.com/mendersoftware/deviceauth/deviceauth /usr/bin/
RUN apk add --update ca-certificates && update-ca-certificates
ENTRYPOINT ["/usr/bin/deviceauth", "--config", "/etc/deviceauth/config.yaml"]


