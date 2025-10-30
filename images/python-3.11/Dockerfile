FROM python:3.11-slim

LABEL org.opencontainers.image.title="python-3.11" \
      org.opencontainers.image.description="Imagem base Python 3.11 (slim) padronizada" \
      org.opencontainers.image.source="https://github.com/${GITHUB_REPOSITORY}" \
      org.opencontainers.image.licenses="MIT"

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
      dumb-init bash ca-certificates curl && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd --system app && \
    useradd --system --create-home --gid app app

USER app
WORKDIR /home/app/app

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["python", "--version"]


