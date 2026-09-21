pluginManagement {
    repositories {
        google {
            content {
                includeGroupByRegex("com\\.android.*")
                includeGroupByRegex("com\\.google.*")
                includeGroupByRegex("androidx.*")
            }
        }
        // The ObjectBox plugin is available on Maven Central
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        // ObjectBox dependencies are available on Maven Central
        mavenCentral()

        // Temporary (mesh sync interop testing): internal ObjectBox repo to get snapshot versions
        // of dependencies. Requires gitlabUrl and gitlabPrivateToken (and optionally
        // gitlabPrivateTokenName) Gradle properties, e.g. in ~/.gradle/gradle.properties.
        val gitlabUrl = providers.gradleProperty("gitlabUrl")
        val gitlabPrivateTokenName = providers.gradleProperty("gitlabPrivateTokenName")
        val gitlabPrivateToken = providers.gradleProperty("gitlabPrivateToken")
        if (gitlabUrl.isPresent) {
            maven {
                name = "GitLab"
                url = uri("${gitlabUrl.get()}/api/v4/groups/objectbox/-/packages/maven")
                credentials(HttpHeaderCredentials::class) {
                    name = gitlabPrivateTokenName.orNull ?: "Private-Token"
                    value = gitlabPrivateToken.get()
                }
                authentication {
                    create<HttpHeaderAuthentication>("header")
                }
                println("Dependencies: added GitLab repository")
            }
        } else {
            println("Dependencies: GitLab repository NOT added, see settings file for required project properties")
        }
    }
}

include(":app")
