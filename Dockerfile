# syntax=docker/dockerfile:1

##
## Build
##
FROM golang:1.18-alpine AS build

ENV CGO_ENABLED 0
ENV GOPROXY https://goproxy.cn,direct

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY . ./
RUN CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -a -o /main ./main.go

##
## Deploy
##
FROM alpine:latest

WORKDIR /

COPY --from=build /main /main
COPY . ./

ENTRYPOINT ["/main"]