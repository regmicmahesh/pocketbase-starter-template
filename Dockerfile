# Use the Go image to build our application.
FROM --platform=linux/amd64 golang:1.22 as builder

WORKDIR /src/api

COPY . /src/api

RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg \
    CGO_ENABLED=0 go build -v -ldflags '-s -w -extldflags "-static"' -o /usr/local/bin/api . 

RUN curl -s -L https://github.com/benbjohnson/litestream/releases/download/v0.3.13/litestream-v0.3.13-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf -

FROM --platform=linux/amd64 alpine:3.19.1

WORKDIR /app

RUN apk add bash && mkdir /data

COPY ./etc/litestream.yml /etc/litestream.yml

COPY --from=builder /usr/local/bin/api /usr/local/bin/api
COPY --from=builder /usr/local/bin/litestream /usr/local/bin/litestream

COPY ./docker-entrypoint.sh /start

EXPOSE 3000

CMD [ "/start" ]