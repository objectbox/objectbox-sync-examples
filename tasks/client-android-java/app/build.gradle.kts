// For ObjectBox: see the root build script on how to add required plugins and repositories

plugins {
    id("com.android.application")
    id("kotlin-android") // AndroidX libraries include Kotlin, use plugin to unify versions.
}

val objectboxVersion: String by rootProject.extra

android {
    namespace = "io.objectbox.example.sync"
    compileSdk = 34 // Android 14 (UPSIDE_DOWN_CAKE)

    buildFeatures {
        viewBinding = true
    }

    defaultConfig {
        applicationId = "io.objectbox.example.sync"
        minSdk = 21 // For ObjectBox: requires at least Android 5.0 (LOLLIPOP)
        targetSdk = 33 // Android 13 (TIRAMISU)
        versionCode = 1
        versionName = "1.0"
    }

    // For ObjectBox: the Java SDK requires at least Java 8
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }
}

// Since Kotlin 1.8 kapt not longer inherits the JVM target version from the Kotlin compile tasks
// https://youtrack.jetbrains.com/issue/KT-55947/Unable-to-set-kapt-jvm-target-version
tasks.withType(type = org.jetbrains.kotlin.gradle.internal.KaptGenerateStubsTask::class) {
    kotlinOptions.jvmTarget = JavaVersion.VERSION_1_8.toString()
}

dependencies {
    implementation("androidx.appcompat:appcompat:1.7.0")
    implementation("com.google.android.material:material:1.12.0")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")
    implementation("androidx.recyclerview:recyclerview:1.3.2")
    implementation("androidx.lifecycle:lifecycle-livedata-ktx:2.8.4")
    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:2.8.4")

    // For ObjectBox: optionally add Android library with Admin for debug builds only
    // https://docs.objectbox.io/data-browser
    debugImplementation("io.objectbox:objectbox-sync-android-objectbrowser:$objectboxVersion")
    releaseImplementation("io.objectbox:objectbox-sync-android:$objectboxVersion")
}

// For ObjectBox: apply the plugin.
// Note that the plugin is applied after the dependencies block so it can detect
// manually added ObjectBox dependencies.
apply(plugin = "io.objectbox.sync")
