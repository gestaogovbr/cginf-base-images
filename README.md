## cginf-base-images

Repositório monorepo de imagens base da organização. Aqui mantemos imagens padronizadas (atualmente `postgres-16-dev`, `postgres-16-hardened` e `postgres-latest-chainguard`) para acelerar e uniformizar os projetos.

### Objetivos

- Padronizar ambientes de execução dos serviços.
- Facilitar atualizações de segurança e dependências base.
- Automatizar build e publicação em registro de containers (GHCR).

### Estrutura

```
images/
  postgres-16-dev/
    Dockerfile
    README.md
  postgres-16-hardened/
    Dockerfile
    README.md
  postgres-latest-chainguard/
    Dockerfile
    README.md
```

Cada pasta em `images/` representa uma imagem base. O nome da pasta será o nome do repositório de imagem publicado no registro.
No caso de variações (como `postgres-16-dev` e `postgres-16-hardened`), utilize tags distintas no registro para indicar o destino (desenvolvimento vs produção).

### Registro de imagens

- Padrão: GitHub Container Registry (GHCR)
- Namespace: `ghcr.io/<org ou usuário>/<nome-da-imagem>`

Exemplos após publicação:

- `ghcr.io/<org>/postgres-16-dev:edge`
- `ghcr.io/<org>/postgres-16-hardened:edge`
- `ghcr.io/<org>/postgres-latest-chainguard:edge`

### Repositório Helm Central

- Os charts ficam versionados em `helm/<chart-name>/` e empacotados em `docs/charts/`.
- O índice público está em `docs/charts/index.yaml`, publicado via GitHub Pages em `https://gestaogovbr.github.io/cginf-base-images/charts`.
- Cada novo `.tgz` gerado deve ser commitado junto ao índice para manter o repositório Helm sincronizado.

#### Fluxo de empacotamento

```bash
# 1. Gere o pacote (ajuste a versão em helm/<chart>/Chart.yaml antes)
helm package helm/postgres-16-dev --destination docs/charts

# 2. Atualize o índice do repositório Helm
helm repo index docs/charts --url https://gestaogovbr.github.io/cginf-base-images/charts
```

- Os comandos acima sobrescrevem `docs/charts/index.yaml` mesclando o histórico existente com o novo pacote.
- Garanta que o arquivo `docs/charts/postgres-16-dev-<versão>.tgz` e o índice atualizados sejam versionados no Git.

#### Como consumir o repositório Helm

```bash
helm repo add cginf-base https://gestaogovbr.github.io/cginf-base-images/charts
helm repo update
helm search repo cginf-base
```

Instalação básica do chart `postgres-16-dev`:

```bash
helm install my-postgres-dev cginf-base/postgres-16-dev \
  --namespace dev-db --create-namespace \
  --set auth.password=super-segura \
  --set persistence.size=20Gi
```

- Para customizações complexas, utilize um arquivo `values-dev.yaml` e aplique com `-f values-dev.yaml`.

#### Principais atributos técnicos (`values.yaml`)

- `image.repository`, `image.tag`, `image.pullPolicy`: imagem padrão `ghcr.io/cginfseges/postgres-16-dev:edge`.
- `service.type`, `service.port`: expõem o PostgreSQL (default `ClusterIP:5432`).
- `auth.*`: credenciais padrão (`postgres/postgres`); recomenda-se sobrescrever ou usar `auth.existingSecret`.
- `persistence.enabled`, `persistence.size`, `persistence.storageClass`: volume persistente de 8Gi habilitado por padrão.
- `resources`: limites/requisições de CPU e memória (vazio por padrão).
- `livenessProbe` / `readinessProbe`: sondas ativadas com atrasos iniciais de 30s e 10s.
- `metrics.enabled`: desativado por padrão; habilite para expor métricas (exige exporter).
- `volumePermissions.enabled`: false por padrão; habilite em clusters que exigem ajuste de permissões ao montar PVCs.

> Consulte `helm/postgres-16-dev/values.yaml` para a lista completa e detalhes adicionais.

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
- Para imagens baseadas na Chainguard (`postgres-latest-chainguard`), configure também os secrets `CHAINGUARD_USERNAME` e `CHAINGUARD_PASSWORD` com credenciais do registry `cgr.dev`.

### Boas práticas para Dockerfile base

- Minimizar camadas e tamanho de imagem.
- Criar usuário não-root e definir `USER` ao final.
- Fixar versões quando possível e limpar caches (`rm -rf /var/lib/apt/lists/*`).
- Adicionar labels OCI (`org.opencontainers.image.*`).
