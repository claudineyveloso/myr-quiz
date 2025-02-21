#!/bin/bash
set -e

# Remove o arquivo pid do servidor caso exista
rm -f /app/tmp/pids/server.pid
chmod +x ./bin/rails

# Aguarda o banco de dados estar pronto
echo "Aguardando banco de dados..."
until nc -z -v -w30 db 3306; do
  echo "Aguardando MySQL..."
  sleep 5
done
echo "Banco de dados está pronto!"

# Executando db:migrate
echo "Executando db:migrate..."
bundle exec rails db:migrate || {
  echo "Falha ao rodar migrations"
  exit 1
}

# Continuando com a inicialização
echo "Finalizando entrypoint..."
exec "$@"
