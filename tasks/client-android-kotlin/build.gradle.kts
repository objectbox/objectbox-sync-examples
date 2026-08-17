plugins {
    alias(libs.plugins.android.application) apply false
    // For ObjectBox: add the kapt and ObjectBox plugin
    alias(libs.plugins.android.kapt) apply false
    alias(libs.plugins.objectbox) apply false
}

// Use "all" Gradle distribution to get source code and API docs
tasks.wrapper {
    distributionType = Wrapper.DistributionType.ALL
}
