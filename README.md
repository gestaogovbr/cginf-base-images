## cginf-base-images

Repositório monorepo de imagens base da organização. Aqui mantemos imagens padronizadas (atualmente as variantes `postgres-16-dev` e `postgres-16-hardened`) para acelerar e uniformizar os projetos.

### Objetivos

- Padronizar ambientes de execução dos serviços.
- Facilitar atualizações de segurança e dependências base.
- Automatizar build e publicação em registro de containers (GHCR).

### Estrutura

```
images/
  postgres-16-dev/
    Dockerfile
  postgres-16-hardened/
    Dockerfile
```

Cada pasta em `images/` representa uma imagem base. O nome da pasta será o nome do repositório de imagem publicado no registro.
No caso de variações (como `postgres-16-dev` e `postgres-16-hardened`), utilize tags distintas no registro para indicar o destino (desenvolvimento vs produção).

### Registro de imagens

- Padrão: GitHub Container Registry (GHCR)
- Namespace: `ghcr.io/<org ou usuário>/<nome-da-imagem>`

Exemplos após publicação:

- `ghcr.io/<org>/postgres-16-dev:edge`
- `ghcr.io/<org>/postgres-16-hardened:edge`

### Versionamento e tags

- Usamos semver nas tags git (`vX.Y.Z`).
  - Push de tag `vX.Y.Z` => publica `:X.Y.Z`, `:X.Y` e `:latest`.
- Push na branch `main` => publica `:edge`.
- Pull Requests => publica `:pr-<número>` (não recomendado para produção).

### Como adicionar uma nova imagem

1. Crie uma pasta em `images/<nome-da-imagem>/`.
2. Adicione um `Dockerfile` funcional e minimalista.
3. Opcional: adicione um `README.md` dentro da pasta explicando propósito e uso.
4. Abra um PR. O workflow irá detectar e construir automaticamente.

### Como testar localmente

No diretório da imagem:

```bash
docker build -t <nome-local>:dev images/<nome-da-imagem>
docker run --rm <nome-local>:dev --version
```

### Requisitos do CI

- Ação requer permissões para publicar pacotes (`packages: write`).
- O login no GHCR utiliza `GITHUB_TOKEN` padrão do GitHub Actions.

### Boas práticas para Dockerfile base

- Minimizar camadas e tamanho de imagem.
- Criar usuário não-root e definir `USER` ao final.
- Fixar versões quando possível e limpar caches (`rm -rf /var/lib/apt/lists/*`).
- Adicionar labels OCI (`org.opencontainers.image.*`).
