FROM docker.io/dhi/postgres:16

# Comentário temporário para forçar rebuild da imagem postgres-16-hardened

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.opencontainers.image.title="postgres-16-hardened" \
      org.opencontainers.image.description="Imagem base PostgreSQL 16 Hardened para ambientes produtivos" \
      org.opencontainers.image.source="https://github.com/${GITHUB_REPOSITORY}" \
      org.opencontainers.image.licenses="PostgreSQL" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.version="${VERSION}"

ENV PGDATA=/var/lib/postgresql/data/pgdata

EXPOSE 5432

# A imagem Hardened já executa como usuário não-root (postgres)
# e possui entrypoint próprio. Mantemos apenas o comando padrão.
CMD ["postgres"]

