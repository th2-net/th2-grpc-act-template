plugins {
    `java-library`
    `maven-publish`
    alias(libs.plugins.th2.grpc)
    alias(libs.plugins.th2.publish)
}

group = "com.exactpro.th2"
version = project.property("release_version").toString()

repositories {
    mavenCentral()
}

th2Grpc {
    service.set(true)
}

dependencies {
    api(libs.th2.grpc.common)
}