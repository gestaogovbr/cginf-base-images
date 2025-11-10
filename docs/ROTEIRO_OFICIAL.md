# Roteiro para Criação e Customização de Imagens Base

Este guia orienta todo o ciclo de vida das imagens base mantidas no repositório, desde o planejamento até a entrega contínua. Ele consolida boas práticas internas e recomendações de segurança para Dockerfiles, ambientes de build e execução.

## 1. Planejamento Inicial

- Definir stack, versão e requisitos de hardening para a imagem.
- Mapear variáveis obrigatórias, opcionais e padrões seguros.
- Registrar decisões relevantes (por exemplo, em ADR) e atualizar o `CHANGELOG`.

### Catálogo atual

- `postgres-16-dev`: variante baseada na imagem oficial do PostgreSQL para desenvolvimento.
- `postgres-16-hardened`: variante Hardened (Docker Hardened Images) destinada a ambientes produtivos.
  - Base construída a partir do espelho privado/publicado em `cginfseges/dhi-postgres`, garantindo acesso sem depender do registry original.

## 2. Estrutura de Diretórios

- Criar `images/<nome-da-imagem>/` contendo ao menos `Dockerfile`.
- Para variantes (ex.: `postgres-16-dev`, `postgres-16-hardened`), prefira diretórios separados por público-alvo ou nível de hardening.
- Adicionar `README.md` específico da imagem com instruções de uso e variáveis.
- Incluir scripts auxiliares (entrypoint, healthchecks) e exemplos em subpastas dedicadas.

## 3. Base da Imagem e Build

- Preferir imagens minimalistas (Alpine, distroless) ou oficiais verificadas.
- Avaliar disponibilização em pares (ex.: oficial para dev e Hardened para produção) quando a segurança exigir.
- Utilizar multi-stage build quando houver toolchain na fase de build.
- Atualizar pacotes, remover caches temporários e fixar versões de dependências.
- Documentar motivação de dependências adicionais e revisar tamanho final.

## 4. Variáveis e Configuração

- Declarar `ARG` para dados de build (ex.: `BUILD_DATE`, `VCS_REF`) e `ENV` para runtime.
- Fornecer `.env.example` ou tabela no README com descrição e valores padrão.
- Validar variáveis críticas no entrypoint antes de iniciar o serviço.
- Evitar colocar segredos diretamente na imagem; consumir via secrets/volumes.

## 5. Usuários, Permissões e Capabilities

- Criar usuário/grupo não privilegiados específicos da imagem.
- Ajustar permissões com `chown`/`chmod` apenas onde necessário.
- Finalizar o Dockerfile com `USER <nome>` para impedir execução como root.
- Na execução, considerar `--cap-drop=ALL` e adicionar capacidades estritamente necessárias.

## 6. Volumes e Persistência

- Definir diretórios persistentes (ex.: `/var/lib/app/data`) e documentar seu uso.
- Declarar `VOLUME` somente quando inevitável; preferir instruções no README para composição via `docker-compose` ou orchestrators.
- Garantir que permissões nesses diretórios correspondam ao usuário não-root.

## 7. Configuração e Templates

- Armazenar configurações padrão em `/etc/<app>/` ou diretório equivalente.
- Permitir overrides com arquivos montados ou variáveis processadas (`envsubst`, scripts).
- Validar integridade de arquivos de configuração antes de iniciar o serviço.

## 8. Entrypoint e Comando

- Implementar `ENTRYPOINT` idempotente, com tratamento de sinais (`exec "$@"`).
- Usar `CMD` para definir o processo principal e oferecer override simples.
- Garantir que scripts sejam compatíveis com shell POSIX e executáveis (`chmod +x`).

## 9. Logs e Observabilidade

- Redirecionar logs para `stdout`/`stderr`.
- Expor configurações de log via variáveis (`LOG_LEVEL`, `LOG_FORMAT`).
- Documentar endpoints de métricas ou healthchecks.

## 10. Segurança e Hardening

- Remover ferramentas desnecessárias e pacotes temporários após uso.
- Adicionar labels OCI (`org.opencontainers.image.*`) com maintainer, commit e link para política de segurança.
- Preferir `COPY` em vez de `ADD`; realizar downloads dentro de `RUN` com validação (hash, TLS).
- Considerar filesystem read-only (`--read-only`) e `--security-opt no-new-privileges:true` nas execuções.
- Referências externas:
  - Boas práticas Snyk para imagens enxutas, usuário não-root e linters. [fonte](https://snyk.io/pt-BR/blog/10-docker-image-security-best-practices/)
  - Endurecimento do daemon/host, quotas e capacidades reduzidas. [fonte](https://spacelift.io/blog/docker-security)

## 11. Testes Locais

- Disponibilizar comandos `make build`, `make test` ou scripts equivalentes.
- Realizar smoke tests pós-build (`docker run --rm <imagem> --version` ou healthcheck).
- Validar permissões e mounts simulando cenários de produção.

## 12. Automação e CI/CD

- Assegurar cobertura do workflow de build multi-arquitetura e publicação no GHCR.
- Habilitar scanners (Trivy, Docker Scout) e linters (Hadolint) na pipeline.
- Planejar assinatura e verificação de imagens (Sigstore/Notary) para etapas futuras.
- Publicar resultados (ex.: relatórios SARIF/HTML) como artefatos e resumos do workflow.

## 13. Documentação

- Atualizar README da imagem com variáveis, exemplos de `docker run` e troubleshooting.
- Registrar notas de upgrade e breaking changes.
- Manter checklist de revisão antes de abrir PR (lint, testes, atualização de labels).

## 14. Governança e Manutenção Contínua

- Programar rebuild periódico das imagens para incorporar patches.
- Monitorar CVEs críticos e end-of-life da distribuição base.
- Revisar permissões de registry, políticas de deploy e dependências do pipeline.

---

Este roteiro deve ser revisado periodicamente para refletir novas práticas de segurança e lições aprendidas nos projetos que consomem as imagens base do repositório.
