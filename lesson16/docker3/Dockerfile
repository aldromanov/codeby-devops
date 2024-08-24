FROM openjdk:11-jdk AS build
WORKDIR /app
COPY multistage.java /app
RUN javac /app/multistage.java

FROM openjdk:11-jre AS run
COPY --from=build /app/Multistage.class .
CMD java Multistage