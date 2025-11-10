# postgres-16-hardened

Imagem base Hardened para PostgreSQL 16, construída sobre o espelho interno `docker.io/cginfseges/dhi-postgres:16-alpine3.22` (mirror do catálogo Docker Hardened Images).

## Características

- Base Hardened com superfície mínima e foco em CVEs zero-day, espelhada em `cginfseges/dhi-postgres:16-alpine3.22` para facilitar o acesso via Docker Hub.
- Execução como usuário não-root (`postgres`) por padrão.
- Entrypoint original da imagem Hardened preservado.
- Porta `5432` exposta; diretório padrão de dados `/var/lib/postgresql/data`.
- Labels OCI prontos para enriquecimento via argumentos de build (`BUILD_DATE`, `VCS_REF`, `VERSION`).

## Requisitos

- Acesso ao catálogo Docker Hardened Images (pode exigir assinatura Docker Business).
- Configurar `POSTGRES_PASSWORD` ou mecanismos de secrets antes da subida do contêiner.
- Garantir que volumes montados concedam permissões ao usuário `postgres` (UID 26 na imagem Hardened).

## Variáveis de Ambiente suportadas

A imagem mantém compatibilidade com as variáveis do `docker-entrypoint.sh` oficial (`POSTGRES_USER`, `POSTGRES_DB`, `POSTGRES_INITDB_ARGS`, etc.). Recomenda-se declarar explicitamente:

- `POSTGRES_PASSWORD` (obrigatória na maioria dos cenários).
- `PGDATA` caso seja necessário alterar o caminho padrão.

## Exemplo de build e execução

```bash
docker build -t ghcr.io/<org>/postgres-16-hardened:local images/postgres-16-hardened
docker run --rm -e POSTGRES_PASSWORD=senha-forte -p 5432:5432 ghcr.io/<org>/postgres-16-hardened:local
```

## Boas práticas

- Utilize scanners (Trivy, Docker Scout) para validar ausência de CVEs após cada build.
- Combine com políticas de execução como `--read-only`, `--cap-drop=ALL` e secrets externos.
- Evite adicionar utilitários via `RUN`; prefira contêineres sidecars para troubleshooting.
