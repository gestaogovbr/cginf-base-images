FROM postgres:16-alpine3.20

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.opencontainers.image.title="postgres-16-dev" \
      org.opencontainers.image.description="Imagem base PostgreSQL 16 para ambientes de desenvolvimento" \
      org.opencontainers.image.source="https://github.com/${GITHUB_REPOSITORY}" \
      org.opencontainers.image.licenses="PostgreSQL" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.version="${VERSION}"

ENV POSTGRES_HOST_AUTH_METHOD=md5 \
    PGDATA=/var/lib/postgresql/data/pgdata

EXPOSE 5432
VOLUME ["/var/lib/postgresql/data"]

RUN set -eux; \
    apk add --no-cache dumb-init less nano iputils curl

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/local/bin/docker-entrypoint.sh"]
CMD ["postgres"]

