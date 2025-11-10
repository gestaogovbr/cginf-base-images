# postgres-latest-chainguard

Imagem base PostgreSQL construída sobre `cgr.dev/chainguard/postgres:latest`, fornecida pela Chainguard. Ideal para cenários onde se deseja aderência às melhores práticas de supply chain (SBOMs assinadas, atualizações contínuas e imagem minimalista Wolfi).

> ℹ️ A tag `latest` da Chainguard acompanha a versão estável mais recente do PostgreSQL. Verifique periodicamente se a major version atende aos requisitos da sua aplicação.

## Características

- Base Chainguard Wolfi com segurança reforçada e foco em redução de CVEs.
- Publicação direta a partir do registry `cgr.dev`, garantindo acesso às atualizações contínuas da Chainguard.
- Execução como usuário não-root (`postgres`) por padrão.
- Entrypoint original mantido, facilitando compatibilidade com variáveis do `docker-entrypoint.sh` oficial.
- Labels OCI prontos para enriquecimento via argumentos de build (`BUILD_DATE`, `VCS_REF`, `VERSION`).

## Requisitos

- Conta gratuita na Chainguard.
- Token válido para o registry `cgr.dev` (defina como secrets `CHAINGUARD_USERNAME` e `CHAINGUARD_PASSWORD` no GitHub Actions para builds automatizados).
- Configurar `POSTGRES_PASSWORD` ou secrets equivalentes antes da subida do contêiner.
- Garantir que volumes montados concedam permissões ao usuário `postgres` (UID 26 na imagem Chainguard).

## Variáveis de Ambiente suportadas

A imagem mantém compatibilidade com as variáveis padrão do PostgreSQL (`POSTGRES_USER`, `POSTGRES_DB`, `POSTGRES_PASSWORD`, `POSTGRES_INITDB_ARGS`, etc.). Ajuste `PGDATA` caso precise alterar o diretório de dados.

## Exemplo de build e execução

```bash
docker login cgr.dev -u <username> -p <token>
docker build -t ghcr.io/<org>/postgres-latest-chainguard:local images/postgres-latest-chainguard
docker run --rm -e POSTGRES_PASSWORD=senha-forte -p 5432:5432 ghcr.io/<org>/postgres-latest-chainguard:local
```

## Boas práticas

- Utilize scanners (Trivy, Docker Scout) para validar ausência de CVEs após cada build.
- Combine com políticas de execução endurecidas (`--read-only`, `--cap-drop=ALL`, secrets externos).
- Atualize regularmente os tokens Chainguard para evitar falhas de autenticação durante o build.
- Consulte a documentação oficial para limites do plano gratuito e instruções detalhadas: `https://edu.chainguard.dev/chainguard/registries/`.
