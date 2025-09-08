// For ObjectBox: see the root build script on how to add required plugins and repositories

plugins {
    id("application")
}

java {
    // Note: the ObjectBox Java SDK requires at least Java 8
    sourceCompatibility = JavaVersion.VERSION_1_8
    targetCompatibility = JavaVersion.VERSION_1_8
}

tasks.withType<JavaCompile> {
    // Gradle defaults to the platform default encoding, make sure to always use UTF-8
    options.encoding = "UTF-8"
}

tasks.named<JavaExec>("run") {
    // Support console input
    standardInput = System.`in`
}

application {
    mainClass.set("io.objectbox.example.Main")
}

// For ObjectBox: reference common version defined in root built script
val objectboxVersion: String by rootProject.extra

dependencies {
    // For ObjectBox: add the Java SDK
    implementation("io.objectbox:objectbox-java:$objectboxVersion")

    // For ObjectBox: add libraries for all platforms supported by your application.
    // Note that the ObjectBox Gradle plugin would automatically add the one matching your current machine.
    // Also, libraries for more platforms than added below are available, check Maven Central.
    implementation("io.objectbox:objectbox-sync-windows:$objectboxVersion")
    implementation("io.objectbox:objectbox-sync-linux:$objectboxVersion")
    implementation("io.objectbox:objectbox-sync-macos:$objectboxVersion")
}

// For ObjectBox: apply the Sync plugin.
// Note that the plugin is applied after the dependencies block so it can detect
// manually added ObjectBox dependencies.
apply(plugin = "io.objectbox.sync")
