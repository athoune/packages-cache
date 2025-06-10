nginx:
	mkdir -p data
	docker run -ti --rm \
		-v `pwd`/nginx.conf:/etc/nginx/nginx.conf \
		-v `pwd`/data:/data \
		-p 3421:80 \
		nginx-subs

build-nginx:
	docker build --build-arg ENABLED_MODULES="subs-filter" -f Dockerfile.alpine -t nginx-subs .
