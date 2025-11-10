FROM cgr.dev/chainguard/postgres:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.opencontainers.image.title="postgres-16-chainguard" \
      org.opencontainers.image.description="Imagem base PostgreSQL 16 utilizando Chainguard Postgres" \
      org.opencontainers.image.source="https://github.com/${GITHUB_REPOSITORY}" \
      org.opencontainers.image.licenses="PostgreSQL" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.version="${VERSION}"

ENV PGDATA=/var/lib/postgresql/data/pgdata

EXPOSE 5432

# A imagem Chainguard já executa como usuário não-root (postgres)
# e disponibiliza o entrypoint padrão.
CMD ["postgres"]

