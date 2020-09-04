FROM golang:alpine as builder
WORKDIR /build
RUN apk update && apk add --no-cache git && \
    git clone https://github.com/wrfly/container-web-tty.git && \
    cd container-web-tty && \
    make

FROM alpine:edge
# for arm64
RUN [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf
COPY --from=builder /build/container-web-tty/bin/container-web-tty /app/container-web-tty
EXPOSE 8080
ENTRYPOINT [ "/app/container-web-tty" ]
# CMD [ "/app/container-web-tty" ]