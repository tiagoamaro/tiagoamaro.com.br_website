.PHONY: install build up

install:
	npm ci

build:
	npm run build:css

up:
	npm run watch:css & \
	python3 -m http.server 4000; \
	kill %1
