#!/bin/sh

docker-compose build --force-rm
docker-compose run --rm ember sh ember-new.sh
