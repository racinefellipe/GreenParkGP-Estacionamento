# Green Park — GP-Estacionamento

Sistema de estacionamento (operação de pátio, mensalidade e administração) com arquitetura:

**Angular (`gp-web`) → BFF (`gp-bff`) → API Core (`gp-api-core`) → Oracle**

## Estrutura

```text
apps/
  gp-web/        # Frontend Angular
  gp-bff/        # BFF Spring Boot (porta 8081)
  gp-api-core/   # API de domínio Spring Boot (porta 8080)
infra/
  oracle/        # scripts de init (F1.2+)
  proxy/         # proxy reverso opcional
docs/            # requisitos, domínio e arquitetura
```

## Pré-requisitos

| Ferramenta | Versão sugerida |
| --- | --- |
| JDK | 21+ |
| Maven | 3.9+ |
| Node.js | 18+ (LTS) |
| npm | 10+ |
| Docker | 24+ (Compose a partir de F1.2) |

## Configuração

```bash
cp .env.example .env
```

Ajuste `ORACLE_*`, `JWT_SECRET` e `CORE_BASE_URL` conforme o ambiente.

## Subir em desenvolvimento (esqueleto F1.1)

Em terminais separados:

```bash
# API Core — http://localhost:8080
cd apps/gp-api-core
mvn spring-boot:run

# BFF — http://localhost:8081
cd apps/gp-bff
mvn spring-boot:run

# Web — http://localhost:4200
cd apps/gp-web
npm start
```

Health placeholders (Actuator):

- Core: `GET http://localhost:8080/actuator/health`
- BFF: `GET http://localhost:8081/actuator/health`

## Smoke build

```bash
cd apps/gp-api-core && mvn -q -DskipTests package
cd ../gp-bff && mvn -q -DskipTests package
cd ../gp-web && npm run build
```

## Próximos passos

- **F1.2** — Docker Compose com Oracle + healthcheck
- **F1.3** — Dockerfiles multi-serviço (web/nginx, bff, core)

Documentação de planejamento em `.cursor/plans/`. Entregáveis formais em `docs/` serão consolidados nas fases seguintes.
