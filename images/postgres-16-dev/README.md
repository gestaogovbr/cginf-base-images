# postgres-16-dev

Imagem base para ambientes de desenvolvimento utilizando PostgreSQL 16 a partir da imagem oficial do Docker Hub.

## Características

- Base `postgres:16` (Debian).
- Inclusão de utilitários úteis em desenvolvimento (`less`, `nano`, `curl`, `iputils-ping`).
- `dumb-init` como wrapper do `docker-entrypoint.sh` padrão.
- Porta `5432` exposta e diretório de dados padrão `/var/lib/postgresql/data`.

## Variáveis de Ambiente

| Variável                    | Descrição                      | Valor padrão                                       |
| --------------------------- | ------------------------------ | -------------------------------------------------- |
| `POSTGRES_HOST_AUTH_METHOD` | Método de autenticação default | `md5`                                              |
| `PGDATA`                    | Caminho de dados do PostgreSQL | `/var/lib/postgresql/data/pgdata`                  |
| `POSTGRES_USER`             | Usuário inicial do banco       | `postgres`                                         |
| `POSTGRES_PASSWORD`         | Senha do usuário inicial       | _(obrigatório se `POSTGRES_HOST_AUTH_METHOD=md5`)_ |

Todas as demais variáveis suportadas pela imagem oficial (`POSTGRES_DB`, `POSTGRES_INITDB_ARGS`, etc.) continuam disponíveis.

## Exemplos de uso

```bash
docker build -t ghcr.io/<org>/postgres-16-dev:local images/postgres-16-dev
docker run --rm -e POSTGRES_PASSWORD=postgres -p 5432:5432 ghcr.io/<org>/postgres-16-dev:local
```

## Notas

- Utilize apenas em ambientes de desenvolvimento/teste.
- Para pipelines de QA/produção utilize a imagem `postgres-16-hardened`.
