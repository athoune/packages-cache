ifeq ($(shell uname),Darwin)
	SERVER_IP=$(shell ifconfig -v en0 | grep "inet " | cut -w -f 3)
else
	SERVER_IP=$(shell ip -f inet addr show docker0 | grep "inet " | sed -E "s#.*inet (.*)/.*#\1#g" )
endif

cache: build-cache cache-server

cache-server:
	mkdir -p data
	docker run --rm \
		-v `pwd`/nginx.conf:/etc/nginx/nginx.conf:ro \
		-v `pwd`/data/cache:/data/cache \
		-p $(SERVER_IP):8082:80 \
		nginx-subs

build-cache:
	docker build \
	--build-arg ENABLED_MODULES="subs-filter" \
	-t nginx-subs  \
	https://raw.githubusercontent.com/nginx/docker-nginx/refs/heads/master/modules/Dockerfile.alpine

debian-with-cache:
	docker build \
		-f Dockerfile.debian-with-cache \
		-t debian-with-cache \
		.

debian-build-demo:
	docker build \
    -f Dockerfile.debian \
    -t debian-demo \
    --build-arg APT_CACHE=http://$(SERVER_IP):8082/ \
	.

debian-demo: debian-with-cache debian-build-demo
	docker run --rm debian-demo

ubuntu-with-cache:
	docker build \
		-f Dockerfile.ubuntu-with-cache \
		-t ubuntu-with-cache \
		.

ubuntu-build-demo:
	docker build \
    -f Dockerfile.ubuntu \
    -t ubuntu-demo \
    --build-arg APT_CACHE=http://$(SERVER_IP):8082/ \
	.

ubuntu-demo: ubuntu-with-cache ubuntu-build-demo
	docker run --rm ubuntu-demo

python-with-cache:
	docker build \
		-f Dockerfile.python-with-cache \
		-t python-with-cache \
		.

python-build-demo:
	docker build \
    -f Dockerfile.python \
    -t python-demo \
    --build-arg PYPI_CACHE=$(SERVER_IP):8082 \
	.

python-demo: python-with-cache python-build-demo
	docker run --rm python-demo

node-with-cache:
	docker build \
		-f Dockerfile.npm-with-cache \
		-t node-with-cache \
		.

node-build-demo:
	docker build \
    -f Dockerfile.node \
    -t node-demo \
    --build-arg NPM_CACHE=$(SERVER_IP):8082 \
	.

node-demo: node-with-cache node-build-demo
	docker run --rm node-demo

alpine-with-cache:
	docker build \
		-f Dockerfile.alpine-with-cache \
		-t alpine-with-cache \
		.

alpine-build-demo:
	docker build \
    -f Dockerfile.alpine \
    -t alpine-demo \
    --build-arg HTTP_PROXY=$(SERVER_IP):8082 \
	.

alpine-demo: alpine-with-cache alpine-build-demo
	docker run --rm alpine-demo

demo: debian-demo ubuntu-demo python-demo node-demo alpine-demo
