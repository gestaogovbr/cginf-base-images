FROM node:20-alpine

LABEL org.opencontainers.image.title="node-20" \
      org.opencontainers.image.description="Imagem base Node.js 20 (Alpine) padronizada" \
      org.opencontainers.image.source="https://github.com/${GITHUB_REPOSITORY}" \
      org.opencontainers.image.licenses="MIT"

# Instala ferramentas mínimas e dumb-init
RUN apk add --no-cache dumb-init bash ca-certificates && \
    addgroup -S app && adduser -S app -G app

ENV NODE_ENV=production \
    PNPM_HOME=/home/app/.local/share/pnpm \
    PATH=/home/app/.local/share/pnpm:/home/app/.npm-global/bin:$PATH

# Diretórios de cache e home do usuário
RUN mkdir -p /home/app/app /home/app/.npm-global && \
    chown -R app:app /home/app

USER app
WORKDIR /home/app/app

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["node", "--version"]


