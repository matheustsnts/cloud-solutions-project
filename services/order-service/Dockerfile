# Estágio 1: Build
FROM maven:3.9.6-eclipse-temurin-17-alpine AS build
WORKDIR /app
# Copia apenas o pom.xml para baixar as dependências (cache eficiente)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copia o código e gera o jar
COPY src ./src
RUN mvn clean package -DskipTests

# Estágio 2: Runtime
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Cria um usuário não-root por segurança (Cybersecurity requirement)
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]