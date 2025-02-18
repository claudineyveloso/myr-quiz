# Use a imagem Ruby oficial
FROM ruby:3.3.5

# Instale dependências do sistema
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    libxml2-dev \
    libffi-dev \
    default-libmysqlclient-dev \
    nodejs \
    yarn \
    netcat-traditional \
    && rm -rf /var/lib/apt/lists/*


# Crie e defina o diretório de trabalho
WORKDIR /app

# Copie os arquivos da aplicação
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copie os arquivos restantes
COPY . .

COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

# Configurando o entrypoint
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

# Configure o servidor para rodar no Docker
# CMD ["rails", "server", "-b", "0.0.0.0"]
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
