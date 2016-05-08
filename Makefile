tag := registry.camderwin.us/site

.PHONY: build run debug kill release

build:
	docker-compose build

run:
	docker-compose up -d

kill:
	docker-compose down

test:
	docker run --rm -p 80:80 $(tag)

debug:
	docker-compose run --service-ports jekyll

release:
	docker build -t $(tag) . && \
	docker tag $(tag) $(tag):latest && \
	docker push $(tag)
