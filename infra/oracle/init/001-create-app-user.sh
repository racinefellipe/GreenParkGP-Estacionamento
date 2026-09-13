#!/usr/bin/env bash

set -euo pipefail

: "${GP_APP_USER:?Variável GP_APP_USER não informada}"
: "${GP_APP_PASSWORD:?Variável GP_APP_PASSWORD não informada}"

GP_APP_PDB="${GP_APP_PDB:-FREEPDB1}"

echo "Criando usuário/schema ${GP_APP_USER} no PDB ${GP_APP_PDB}..."

createAppUser \
  "${GP_APP_USER}" \
  "${GP_APP_PASSWORD}" \
  "${GP_APP_PDB}"

echo "Usuário/schema ${GP_APP_USER} criado com sucesso."