#!/bin/sh
set -e

# Remove o arquivo pid do servidor caso exista
rm -f /app/tmp/pids/server.pid

# Executando db:create e db:migrate
echo "Executando db:create..."
bundle exec rails db:create
echo "Executando db:migrate..."
bundle exec rails db:migrate

# Continuando com a inicialização
echo "Finalizando entrypoint..."
exec "$@"
