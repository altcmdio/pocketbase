# syntax=docker/dockerfile:1


# Fetch a pre-built pocketbase binary.
FROM alpine:latest AS pocketbase
ARG PB_VERSION=0.21.1
ARG PB_ARCH=linux_arm64
RUN apk add --no-cache --purge \
    unzip \
    ca-certificates
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_${PB_ARCH}.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /pb/ 


# Generate a version of caddy with digitalocean dns support.
FROM alpine:latest AS caddy
RUN apk add --no-cache --purge --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing \
    ca-certificates\
    xcaddy
WORKDIR /tmp
RUN xcaddy build --with github.com/caddy-dns/digitalocean@master


# Generate the final pb-backend image.
FROM alpine:latest AS pb-backend
RUN apk add --no-cache --purge supervisor
ADD supervisord.conf /etc/
COPY --from=pocketbase /pb/pocketbase /usr/bin/
ADD pocketbase/ /pb
ADD pocketbase.conf /etc/supervisor.d/
COPY --from=caddy /tmp/caddy /usr/bin/
ADD Caddyfile /etc/caddy/
ADD caddy.conf /etc/supervisor.d/
EXPOSE 80
VOLUME ["/pb"]
ENTRYPOINT ["supervisord"]
CMD ["--configuration", "/etc/supervisord.conf"]
