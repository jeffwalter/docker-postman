#!/usr/bin/env bash

docker run \
	-d \
	-p 127.0.0.1:8080:80/tcp \
	-p 127.0.0.1:8025:25/tcp \
	-p 127.0.0.1:8110:110/tcp \
	-p 127.0.0.1:8143:143/tcp \
	-p 127.0.0.1:8465:465/tcp \
	-p 127.0.0.1:8587:587/tcp \
	-p 127.0.0.1:8993:993/tcp \
	-p 127.0.0.1:8995:995/tcp \
	-v /mnt/data/mail:/data \
	--name mail \
	jwalter/postman
