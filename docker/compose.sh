#!/bin/bash

ARGS=("$@")
ENV=${ARGS[0]:-development}
COMMAND=${ARGS[1]:-up}

export COMPOSE_ENV_FILE=.env.${ENV}
export COMPOSE_FILE=${ENV}.compose.yml

docker compose -f "${COMPOSE_FILE}" --env-file "${COMPOSE_ENV_FILE}" "${COMMAND}" "${ARGS[@]:2}"