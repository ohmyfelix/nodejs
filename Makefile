DOCKER_IMAGE=dockette/nodejs
DEFAULT_VERSION=v18
VERSIONS=v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18

.PHONY: build build-all test test-all run $(addprefix build-,$(VERSIONS)) $(addprefix test-,$(VERSIONS))

build: build-$(DEFAULT_VERSION)

build-all: $(addprefix build-,$(VERSIONS))

test: test-$(DEFAULT_VERSION)

test-all: $(addprefix test-,$(VERSIONS))

run:
	docker run --rm -it ${DOCKER_IMAGE}:${DEFAULT_VERSION}

_docker-build-%: VERSION=$*
_docker-build-%:
	docker buildx \
		build \
		--platform linux/amd64,linux/arm64 \
		--pull \
		-t ${DOCKER_IMAGE}:${VERSION} \
		./${VERSION}

_docker-test-%: VERSION=$*
_docker-test-%:
	set -eu; \
		node_version="$$(docker run --rm ${DOCKER_IMAGE}:${VERSION} node -v)"; \
		case "$$node_version" in \
			${VERSION}*) printf 'Node version matched %s\n' "$$node_version" ;; \
			*) printf 'Invalid node version %s != ${VERSION}\n' "$$node_version"; exit 255 ;; \
		esac; \
		npm_version="$$(docker run --rm ${DOCKER_IMAGE}:${VERSION} npm -v)"; \
		test -n "$$npm_version"; \
		printf 'npm version %s\n' "$$npm_version"

build-v6: _docker-build-v6
build-v7: _docker-build-v7
build-v8: _docker-build-v8
build-v9: _docker-build-v9
build-v10: _docker-build-v10
build-v11: _docker-build-v11
build-v12: _docker-build-v12
build-v13: _docker-build-v13
build-v14: _docker-build-v14
build-v15: _docker-build-v15
build-v16: _docker-build-v16
build-v17: _docker-build-v17
build-v18: _docker-build-v18

test-v6: _docker-test-v6
test-v7: _docker-test-v7
test-v8: _docker-test-v8
test-v9: _docker-test-v9
test-v10: _docker-test-v10
test-v11: _docker-test-v11
test-v12: _docker-test-v12
test-v13: _docker-test-v13
test-v14: _docker-test-v14
test-v15: _docker-test-v15
test-v16: _docker-test-v16
test-v17: _docker-test-v17
test-v18: _docker-test-v18
