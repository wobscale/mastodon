TAG := $(shell git describe --tags --always)
SOURCE_COMMIT := $(shell git rev-parse HEAD)
WEB_IMAGE := euank/mastodon:$(TAG)
STREAMING_IMAGE := euank/mastodon-streaming:$(TAG)

.PHONY: image push

image:
	docker buildx build --platform linux/amd64 --load \
		--build-arg SOURCE_COMMIT=$(SOURCE_COMMIT) \
		-t $(WEB_IMAGE) .
	docker buildx build --platform linux/amd64 --load \
		-f streaming/Dockerfile \
		-t $(STREAMING_IMAGE) .

push:
	docker buildx build --platform linux/amd64 --push \
		--build-arg SOURCE_COMMIT=$(SOURCE_COMMIT) \
		-t $(WEB_IMAGE) .
	docker buildx build --platform linux/amd64 --push \
		-f streaming/Dockerfile \
		-t $(STREAMING_IMAGE) .
