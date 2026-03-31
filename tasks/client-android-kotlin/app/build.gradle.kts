import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
    // For ObjectBox: apply the kapt and ObjectBox plugin
    alias(libs.plugins.kotlin.kapt)
    alias(libs.plugins.objectbox)
}

android {
    namespace = "io.objectbox.example.sync"
    compileSdk = 35 // Android 15 (Vanilla Ice Cream)

    buildFeatures {
        buildConfig = true
        viewBinding = true
    }

    defaultConfig {
        applicationId = "io.objectbox.example.sync.kotlin"
        minSdk = 21 // For ObjectBox: requires at least Android 5.0 (LOLLIPOP)
        targetSdk = 33 // Android 13 (TIRAMISU)
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        // While ObjectBox only requires Java 8, this is deprecated and
        // new Android projects should use 11.
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
}

kotlin {
    compilerOptions {
        // While ObjectBox only requires Java 8, this is deprecated and
        // new Android projects should use 11.
        jvmTarget = JvmTarget.JVM_11
    }
}

dependencies {
    implementation(libs.androidx.activity.ktx)
    implementation(libs.androidx.appcompat)
    implementation(libs.material)
    implementation(libs.androidx.constraintlayout)
    implementation(libs.androidx.recyclerview)
    implementation(libs.androidx.lifecycle.livedata.ktx)
    implementation(libs.androidx.lifecycle.viewmodel.ktx)

    // For ObjectBox: optionally add Android database library with Admin (for debug builds only)
    // https://docs.objectbox.io/data-browser
    debugImplementation(libs.objectbox.android.admin)
    releaseImplementation(libs.objectbox.android)
}
