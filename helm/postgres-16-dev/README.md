# postgres-16-dev Helm Chart

Chart para implantar a imagem base `postgres-16-dev` (PostgreSQL 16) em ambientes de desenvolvimento. A imagem é publicada em `ghcr.io/cginfseges/postgres-16-dev` e mantém paridade com o Dockerfile localizado em `images/postgres-16-dev/`.

> ⚠️ O chart exige que uma senha seja informada via `auth.password` (ou `auth.existingSecret`). Não deixe o valor padrão em ambientes compartilhados.

## Instalação Rápida

```bash
helm repo add cginf-base-images https://example.org/helm-charts   # ajuste quando o repositório for publicado
helm install minha-release ./helm/postgres-16-dev \
  --set auth.password=SeuSenhaForte \
  --set image.repository=ghcr.io/<org>/postgres-16-dev \
  --set image.tag=edge
```

Para testes locais sem repositório Helm, utilize o diretório do chart:

```bash
helm install minha-release helm/postgres-16-dev \
  --set auth.password=SenhaTemporaria
```

## Principais Valores

| Chave                 | Descrição                                                                  | Default                              |
| --------------------- | -------------------------------------------------------------------------- | ------------------------------------ |
| `image.repository`    | Repositório da imagem                                                      | `ghcr.io/cginfseges/postgres-16-dev` |
| `image.tag`           | Tag da imagem                                                              | `edge`                               |
| `auth.username`       | Usuário inicial do banco                                                   | `postgres`                           |
| `auth.password`       | Senha inicial (obrigatório se `auth.existingSecret` vazio)                 | `postgres` _(substitua em produção)_ |
| `auth.existingSecret` | Nome de um Secret já existente com a senha (`key` definido em `secretKey`) | `""`                                 |
| `service.type`        | Tipo de serviço Kubernetes                                                 | `ClusterIP`                          |
| `service.port`        | Porta exposta pelo serviço                                                 | `5432`                               |
| `persistence.enabled` | Cria PVC para o volume de dados                                            | `true`                               |
| `persistence.size`    | Tamanho do PVC                                                             | `8Gi`                                |
| `resources`           | Requests/limits do container                                               | `{}`                                 |
| `extraEnv`            | Lista adicional de variáveis de ambiente                                   | `[]`                                 |
| `envFrom`             | Blocos `envFrom` extras (ConfigMaps/Secrets)                               | `[]`                                 |

Consulte `values.yaml` para ver todos os parâmetros suportados.

## Senha via Secret existente

Para reutilizar um Secret pré-criado:

```bash
kubectl create secret generic postgres-dev-secret \
  --from-literal=postgres-password=sua-senha

helm install minha-release helm/postgres-16-dev \
  --set auth.existingSecret=postgres-dev-secret
```

> Ao usar `auth.existingSecret`, garanta que a chave dentro do Secret corresponda a `auth.secretKey` (padrão `postgres-password`).

## Acesso e Teste

```bash
# Port-forward para acessar localmente
kubectl port-forward svc/minha-release-postgres-16-dev 5432:5432

# Recuperar a senha definida via Secret
kubectl get secret minha-release-postgres-16-dev-auth -o jsonpath='{.data.postgres-password}' | base64 -d
```

Em seguida conecte via `psql`, DBeaver ou ferramenta similar usando `localhost:5432`.

## Próximos Passos

- Publicar o chart em um repositório Helm (GitHub Pages, ChartMuseum, etc.).
- Integrar com pipelines (lint `helm lint`, testes com `helm template`, e2e com `kind`).
- Expandir o chart com opções adicionais (`initdb`, `networkPolicy`, métricas, backup).
