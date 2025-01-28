FROM mysql:8.0

ENV MYSQL_ROOT_PASSWORD=05092004
ENV MYSQL_DATABASE=g_prod_development
ENV MYSQL_USER=rails_user
ENV MYSQL_PASSWORD=05092004

# Copiando o script de inicialização para configurar o banco de dados
COPY ./init /docker-entrypoint-initdb.d/

EXPOSE 3306
