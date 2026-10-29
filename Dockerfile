# Etapa 1: Compilación con Maven Wrapper
FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /app
COPY mvnw mvnw.cmd pom.xml ./
COPY .mvn .mvn
RUN chmod +x mvnw
# Descargar dependencias para aprovechar la caché de capas
RUN ./mvnw dependency:go-offline -B

COPY src src
RUN ./mvnw clean package -DskipTests

# Etapa 2: Imagen final ligera de ejecución
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]