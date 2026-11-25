allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://jitpack.io") }
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// AGP 9 checks AAR metadata for every library: plugins still compiled against
// an old SDK (e.g. flutter_keyboard_visibility at 31) fail checkReleaseAarMetadata
// once a dependency needs 34+. Compile every plugin against the app's SDK, as
// apps/flipper already does.
subprojects {
    val pinCompileSdk = {
        val androidExt = extensions.findByName("android")
        if (androidExt is com.android.build.gradle.BaseExtension) {
            androidExt.compileSdkVersion(36)
        }
    }
    // :app is already evaluated here (evaluationDependsOn above), so
    // afterEvaluate would throw for it; pin straight away in that case.
    if (state.executed) pinCompileSdk() else afterEvaluate { pinCompileSdk() }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
