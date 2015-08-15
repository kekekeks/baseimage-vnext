#!/usr/bin/make

build:
	sudo docker build -t kekekeks/baseimage-vnext .

upload: build
	sudo docker push kekekeks/baseimage-vnext

mrproper:
	-sudo docker stop $$(docker ps -a -q)
	-sudo docker rm $$(docker ps -a -q)

.PHONY: build upload deps run create mrproper
