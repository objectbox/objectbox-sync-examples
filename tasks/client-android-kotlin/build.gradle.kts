plugins {
    // Plugin to help us find updated dependencies, not required to use ObjectBox
    alias(libs.plugins.versions)
    alias(libs.plugins.android.application) apply false
    alias(libs.plugins.kotlin.android) apply false
    // For ObjectBox: add the kapt and ObjectBox plugin
    alias(libs.plugins.kotlin.kapt) apply false
    alias(libs.plugins.objectbox) apply false
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
