plugins {
    // Plugin to help find updated dependencies
    // https://github.com/ben-manes/gradle-versions-plugin/releases
    id("com.github.ben-manes.versions") version "0.51.0"
}

buildscript {
    // For ObjectBox: define common version for tools and dependencies
    val objectboxVersion by extra("4.2.0")

    dependencies {
        classpath("com.android.tools.build:gradle:8.7.3")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.8.22")

        // For ObjectBox: add the Gradle plugin (it is applied in the app build script)
        classpath("io.objectbox:objectbox-gradle-plugin:$objectboxVersion")
    }

    repositories {
        google()
        // For ObjectBox: dependencies are available on Central
        mavenCentral()
    }
}

allprojects {
    repositories {
        google()
        // For ObjectBox: dependencies are available on Central
        mavenCentral()
    }
}

// Use "all" Gradle distribution to get source code and API docs
tasks.wrapper {
    distributionType = Wrapper.DistributionType.ALL
}

// For the versions plugin, reject preview releases
fun isNonStable(version: String): Boolean {
    val stableKeyword = listOf("RELEASE", "FINAL", "GA").any { version.uppercase().contains(it) }
    val regex = "^[0-9,.v-]+(-r)?$".toRegex()
    val isStable = stableKeyword || regex.matches(version)
    return isStable.not()
}
tasks.withType<com.github.benmanes.gradle.versions.updates.DependencyUpdatesTask> {
    rejectVersionIf {
        isNonStable(candidate.version)
    }
}
