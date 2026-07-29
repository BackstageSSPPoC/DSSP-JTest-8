# ============================================================
# AI-Generated Dockerfile
# Language: java | Framework: spring-boot
# Builder: maven:3.9-eclipse-temurin-17 → Runtime: eclipse-temurin:17-jre-alpine
# ============================================================

FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests -B

FROM tomcat:10.1-jre17-temurin
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget -qO- http://localhost:8080/ || exit 1
CMD ["catalina.sh", "run"]