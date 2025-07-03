
cache-server:
	mkdir -p data
	docker run --rm \
		-v `pwd`/nginx.conf:/etc/nginx/nginx.conf:ro \
		-v `pwd`/data/cache:/data/cache \
		-p 8082:80 \
		nginx-subs

build-nginx:
	docker build --build-arg ENABLED_MODULES="subs-filter" -f Dockerfile.alpine -t nginx-subs .

debian-with-cache:
	docker build \
		-f Dockerfile.debian-with-cache \
		-t debian-with-cache \
		.

debian-build-demo:
	docker build \
    -f Dockerfile.debian \
    -t debian-demo \
    --build-arg APT_CACHE=http://192.168.1.35:8082/ \
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
    --build-arg APT_CACHE=http://192.168.1.35:8082/ \
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
    --build-arg PYPI_CACHE=192.168.1.35:8082 \
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
    --build-arg NPM_CACHE=192.168.1.35:8082 \
	.

node-demo: node-with-cache node-build-demo
	docker run --rm node-demo
