# Etapa 1: compila a aplicação
FROM maven:3.9-eclipse-temurin-21-alpine AS build

WORKDIR /workspace

# Copia primeiro o pom para aproveitar o cache das dependências
COPY pom.xml .

RUN mvn -B -DskipTests dependency:go-offline

# Copia o código-fonte
COPY src ./src

# Gera o JAR executável do Spring Boot
RUN mvn -B -DskipTests clean package


# Etapa 2: imagem final somente com o Java
FROM eclipse-temurin:21-jre-alpine AS runtime

WORKDIR /app

# Curl será utilizado pelo healthcheck do Compose
RUN apk add --no-cache curl \
    && addgroup -S gp \
    && adduser -S gp -G gp

# Copia somente o JAR gerado
COPY --from=build \
     --chown=gp:gp \
     /workspace/target/gp-api-core-*.jar \
     /app/app.jar

USER gp

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]