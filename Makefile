LOBSTER_VERSION := $(shell cat LOBSTER_VERSION)
DOCKER_TAG_PREFIX := rzuckerm/lobster:$(LOBSTER_VERSION)
DOCKER_TAG_SUFFIX ?= -dev

META_BUILD_TARGET := .meta-build

.PHONY: help
help:
	@echo "build         - Build docker image"
	@echo "clean         - Clean build output"
	@echo "test          - Test docker image"
	@echo "publish       - Publish docker image"
	@echo ""

.PHONY: build
build: $(META_BUILD_TARGET)
$(META_BUILD_TARGET): Dockerfile
	@echo "*** Building $(DOCKER_TAG_PREFIX)$(DOCKER_TAG_SUFFIX) ***"
	docker rmi -f $(DOCKER_TAG_PREFIX)$(DOCKER_TAG_SUFFIX)
	docker build -t $(DOCKER_TAG_PREFIX)$(DOCKER_TAG_SUFFIX) -f Dockerfile .
	touch $@
	@echo ""

.PHONY: clean
clean:
	rm -f $(META_BUILD_TARGET)

.PHONY: test
test: $(META_BUILD_TARGET)
	@echo "*** Testing $(DOCKER_TAG_PREFIX)$(DOCKER_TAG_SUFFIX) ***"
	./test.sh $(DOCKER_TAG_PREFIX)$(DOCKER_TAG_SUFFIX)
	@echo ""


.PHONY: publish
publish: $(META_BUILD_TARGET)
	@echo "*** Publishing $(DOCKER_TAG_PREFIX)$(DOCKER_TAG_SUFFIX) ***"
	docker push $(DOCKER_TAG_PREFIX)$(DOCKER_TAG_SUFFIX)
	@echo ""
