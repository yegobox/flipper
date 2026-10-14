pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "flipper_sms_bridge"

// `core` is plain Kotlin (no Android SDK), so its tests run anywhere:
//   gradle -PcoreOnly :core:test
include(":core")
if (!providers.gradleProperty("coreOnly").isPresent) {
    include(":app")
}
