FROM mysql:8.0

LABEL org.opencontainers.image.title="mysql-8.0" \
      org.opencontainers.image.description="Imagem base MySQL 8.0 padronizada" \
      org.opencontainers.image.source="https://github.com/${GITHUB_REPOSITORY}" \
      org.opencontainers.image.licenses="GPL-2.0"

# Instala dumb-init usando microdnf ou yum (Oracle Linux)
# A imagem MySQL 8.0 é baseada em Oracle Linux que usa microdnf/yum
RUN if command -v microdnf >/dev/null 2>&1; then \
        microdnf install -y dumb-init && microdnf clean all; \
    elif command -v yum >/dev/null 2>&1; then \
        yum install -y dumb-init && yum clean all; \
    else \
        echo "Erro: nenhum gerenciador de pacotes encontrado" && exit 1; \
    fi

# MySQL já vem com docker-entrypoint.sh
# Wrappeamos o entrypoint original com dumb-init para melhor gerenciamento de sinais
ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/local/bin/docker-entrypoint.sh"]

