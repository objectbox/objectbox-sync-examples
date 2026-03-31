pluginManagement {
    repositories {
        // The ObjectBox plugin is available on Maven Central
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        // ObjectBox dependencies are available on Maven Central
        mavenCentral()
    }
}

include(":app")
