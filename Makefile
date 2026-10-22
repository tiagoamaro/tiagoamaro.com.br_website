.PHONY: install build up

install:
	npm ci

build:
	npm run build:css
	v=$$(shasum public/css/tailwind.css | cut -c1-8); \
	find . -name '*.html' -not -path './node_modules/*' -exec sed -i '' -E "s#/public/css/tailwind\.css(\?v=[0-9a-f]+)?\"#/public/css/tailwind.css?v=$$v\"#" {} +

up:
	npm run watch:css & \
	python3 -m http.server 4000; \
	kill %1
