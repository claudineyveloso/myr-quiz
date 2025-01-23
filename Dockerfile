# Use a imagem Ruby oficial
FROM ruby:3.3.5

# Instale dependências do sistema
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs mysql-client

# Crie e defina o diretório de trabalho
WORKDIR /app

# Copie os arquivos da aplicação
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copie os arquivos restantes
COPY . .

# Configure o servidor para rodar no Docker
CMD ["rails", "server", "-b", "0.0.0.0"]
