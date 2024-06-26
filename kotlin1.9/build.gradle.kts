import org.jetbrains.kotlin.gradle.plugin.KotlinPluginWrapper

plugins {
    kotlin("jvm") version "1.9.23"
}

repositories {
    mavenCentral()
}

dependencies {
    implementation(kotlin("stdlib"))
    testImplementation(kotlin("test"))
}

tasks.test {
    useJUnitPlatform()
}

tasks.register("kotlinCompilerVersion") {
    doLast {
        println("Kotlin plugin version: ${plugins.getPlugin(KotlinPluginWrapper::class.java).pluginVersion}")
    }
}

kotlin {
    jvmToolchain(17)
}
