FROM mysql:8.0

LABEL org.opencontainers.image.title="mysql-8.0" \
      org.opencontainers.image.description="Imagem base MySQL 8.0 padronizada" \
      org.opencontainers.image.source="https://github.com/${GITHUB_REPOSITORY}" \
      org.opencontainers.image.licenses="GPL-2.0"

# Instala dumb-init baixando diretamente do GitHub
# Necessário porque Oracle Linux não tem dumb-init nos repositórios padrão
# Instala curl se necessário e baixa dumb-init
RUN if command -v microdnf >/dev/null 2>&1; then \
        microdnf install -y curl && microdnf clean all; \
    elif command -v yum >/dev/null 2>&1; then \
        yum install -y curl && yum clean all; \
    fi && \
    ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        ARCH="amd64"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        ARCH="arm64"; \
    fi && \
    curl -L -o /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_${ARCH} && \
    chmod +x /usr/bin/dumb-init && \
    rm -f /usr/bin/curl 2>/dev/null || true

# MySQL já vem com docker-entrypoint.sh
# Wrappeamos o entrypoint original com dumb-init para melhor gerenciamento de sinais
ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/local/bin/docker-entrypoint.sh"]

