#!/usr/bin/env bash

set -euo pipefail

TIMEOUT_SECONDS="${1:-600}"
START_TIME="$(date +%s)"

docker compose up -d oracle

while true; do
  CONTAINER_ID="$(docker compose ps -q oracle)"

  if [[ -z "${CONTAINER_ID}" ]]; then
    echo "Container Oracle não foi encontrado."
    exit 1
  fi

  STATUS="$(
    docker inspect \
      --format='{{if .State.Health}}{{.State.Health.Status}}{{else}}no-healthcheck{{end}}' \
      "${CONTAINER_ID}"
  )"

  if [[ "${STATUS}" == "healthy" ]]; then
    echo "Oracle está saudável."
    exit 0
  fi

  if [[ "${STATUS}" == "unhealthy" ]]; then
    echo "Oracle ficou unhealthy."
    docker compose logs --tail=200 oracle
    exit 1
  fi

  CURRENT_TIME="$(date +%s)"
  ELAPSED_SECONDS="$((CURRENT_TIME - START_TIME))"

  if (( ELAPSED_SECONDS >= TIMEOUT_SECONDS )); then
    echo "Timeout: Oracle não ficou saudável em ${TIMEOUT_SECONDS}s."
    docker compose logs --tail=200 oracle
    exit 1
  fi

  echo "Aguardando Oracle... status=${STATUS}, tempo=${ELAPSED_SECONDS}s"
  sleep 10
done