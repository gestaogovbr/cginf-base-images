FROM mysql:8.0

LABEL org.opencontainers.image.title="mysql-8.0" \
      org.opencontainers.image.description="Imagem base MySQL 8.0 padronizada" \
      org.opencontainers.image.source="https://github.com/${GITHUB_REPOSITORY}" \
      org.opencontainers.image.licenses="GPL-2.0"

# Instala dumb-init para melhor gerenciamento de sinais
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends dumb-init && \
    rm -rf /var/lib/apt/lists/*

# MySQL já vem com docker-entrypoint.sh
# Wrappeamos o entrypoint original com dumb-init para melhor gerenciamento de sinais
ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/local/bin/docker-entrypoint.sh"]

