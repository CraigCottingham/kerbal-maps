PROJECT_NAME=kerbal-maps
BUILD_NUMBER ?= DEV
BUILD_SHA ?= $(shell git rev-parse --verify HEAD)
SHORT_BUILD_SHA := $(shell echo $(BUILD_SHA) | head -c 7)
DATE := $(shell date -u "+%Y%m%d")
TAG_NAME := $(DATE)-$(BUILD_NUMBER)-$(SHORT_BUILD_SHA)
DOCKER_TAG := $(PROJECT_NAME):$(TAG_NAME)
DOCKER_TAG_LATEST := $(PROJECT_NAME):latest
FULL_DOCKER_TAG := finitemonkeys/$(DOCKER_TAG)
DATABASE_USER := postgres
DATABASE_PASSWORD := development
DATABASE_NAME := kerbal_maps
DATABASE_NAME_TEST := kerbal_maps_test
DATABASE_URL := postgres://$(DATABASE_USER):$(DATABASE_PASSWORD)@localhost:5432/$(DATABASE_NAME)
DATABASE_URL_TEST := postgres://$(DATABASE_USER):$(DATABASE_PASSWORD)@localhost:5432/$(DATABASE_NAME_TEST)

db_create:
	docker run --name=postgres-kerbal-maps -p 5432:5432 -e POSTGRES_USER=$(DATABASE_USER) -e POSTGRES_PASSWORD=$(DATABASE_PASSWORD) -d postgres:10.9-alpine
	script/wait-for-it localhost:5432 -- sleep 3
	psql -c "CREATE DATABASE $(DATABASE_NAME);" postgres://$(DATABASE_USER):$(DATABASE_PASSWORD)@localhost:5432/template1
	MIX_ENV=dev DATABASE_URL=$(DATABASE_URL) mix ecto.setup
	psql -c "CREATE DATABASE $(DATABASE_NAME_TEST);" postgres://$(DATABASE_USER):$(DATABASE_PASSWORD)@localhost:5432/template1
	MIX_ENV=test DATABASE_URL=$(DATABASE_URL_TEST) mix ecto.setup
	docker stop postgres-kerbal-maps

db_drop:
	docker stop postgres-kerbal-maps
	docker rm postgres-kerbal-maps

db_console:
	docker start postgres-kerbal-maps
	psql $(DATABASE_URL)

develop:
	docker start postgres-kerbal-maps
	script/wait-for-it localhost:5432 -- sleep 3
	DATABASE_URL=$(DATABASE_URL)                                                         \
		ERLANG_COOKIE=kerbal_maps                                                          \
		SECRET_KEY_BASE="iHKHiC1uLovaKtckLv5FhYl5lUpTYiONenuNWHZOLgvAEJwJavoBZ0sof5+TDfgc" \
	  TILE_CDN_URL=https://d3kmnwgldcmvsd.cloudfront.net                                 \
		mix phx.server
	docker stop postgres-kerbal-maps

test:
	docker start postgres-kerbal-maps
	script/wait-for-it localhost:5432 -- sleep 3
	DATABASE_URL=$(DATABASE_URL_TEST) mix test
	docker stop postgres-kerbal-maps

build: buildinfo_file version_file
	docker build -t $(DOCKER_TAG) -t $(DOCKER_TAG_LATEST) -t $(FULL_DOCKER_TAG) .

run:
	docker run -e DATABASE_URL=postgres://$(DATABASE_USER):$(DATABASE_PASSWORD)@host.docker.internal:5432/kerbal_maps \
	           -e ERLANG_COOKIE=kerbal_maps                                                          \
						 -e HOSTNAME=localhost PORT=8080                                                       \
						 -e SECRET_KEY_BASE="iHKHiC1uLovaKtckLv5FhYl5lUpTYiONenuNWHZOLgvAEJwJavoBZ0sof5+TDfgc" \
						 -e TILE_CDN_URL=https://d3kmnwgldcmvsd.cloudfront.net                                 \
	           -p 8080:8080 --rm -it --name kerbal_maps -d                                           \
				     $(DOCKER_TAG_LATEST)

push:
	docker push $(FULL_DOCKER_TAG)

deploy:
	heroku container:push web
	heroku container:release web

clean:
	docker image prune -f --filter 'label=project=$(PROJECT_NAME)' --filter 'until=72h'
	-docker images -qf "reference=$(PROJECT_NAME)*" | xargs docker rmi -f
	rm rel/BUILD-INFO
	rm VERSION

# create_github_release:

buildinfo_file:
	echo "---" > rel/BUILD-INFO
	echo "version: $(TAG_NAME)" >> rel/BUILD-INFO
	echo "build_number: $(BUILD_NUMBER)" >> rel/BUILD-INFO
	echo "git_commit: $(BUILD_SHA)" >> rel/BUILD-INFO
	BUILD_CONTEXT="BuildInfo" \
	BUILD_DESCRIPTION="Build $(TAG_NAME)" \
	test -e rel/BUILD-INFO

version_file:
	echo "$(TAG_NAME)" > VERSION

.PHONY: build buildinfo_file clean db_create db_drop deploy develop push run test version_file
