#!/bin/sh
set -e

# Executando db:create e db:migrate
echo "Executando db:create..."
bundle exec rails db:create
echo "Executando db:migrate..."
bundle exec rails db:migrate

# Continuando com a inicialização
echo "Finalizando entrypoint..."
exec "$@"
