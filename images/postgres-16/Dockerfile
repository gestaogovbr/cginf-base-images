# Imagem base PostgreSQL 16 padronizada para projetos da organização
FROM postgres:16

LABEL org.opencontainers.image.title="postgres-16" \
      org.opencontainers.image.description="Imagem base PostgreSQL 16 padronizada" \
      org.opencontainers.image.source="https://github.com/${GITHUB_REPOSITORY}" \
      org.opencontainers.image.licenses="PostgreSQL"

ENV POSTGRES_HOST_AUTH_METHOD=md5 \
    PGDATA=/var/lib/postgresql/data/pgdata

# Expõe a porta padrão do PostgreSQL
EXPOSE 5432

# Define volume para persistência de dados
VOLUME ["/var/lib/postgresql/data"]

# Instala dumb-init para melhor gerenciamento de sinais
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends dumb-init && \
    rm -rf /var/lib/apt/lists/*

# PostgreSQL já vem com usuário 'postgres' e docker-entrypoint.sh
# Wrappeamos o entrypoint original com dumb-init para melhor gerenciamento de sinais
ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/local/bin/docker-entrypoint.sh"]

