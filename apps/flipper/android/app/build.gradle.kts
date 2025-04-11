import java.io.FileInputStream
import java.util.Properties
import org.gradle.api.GradleException

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")

if (localPropertiesFile.exists()) {
    localPropertiesFile.reader(Charsets.UTF_8).use { reader ->
        localProperties.load(reader)
    }
}

val flutterVersionCode: String = localProperties.getProperty("flutter.versionCode") ?: "1"
val flutterVersionName: String = localProperties.getProperty("flutter.versionName") ?: "1.0"

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}


android {
    namespace = "rw.flipper"
    compileSdk = 35

    defaultConfig {
        applicationId = "rw.flipper"
        minSdk = 24
        targetSdk = 34
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName

        testInstrumentationRunner = "pl.leancode.patrol.PatrolJUnitRunner"
        testInstrumentationRunnerArguments["clearPackageData"] = "true"
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as? String ?: run {
                println("ERROR: keyAlias not found in key.properties")
                throw GradleException("Missing keyAlias in key.properties for release signing.")
            }
            keyPassword = keystoreProperties["keyPassword"] as? String ?: run {
                println("ERROR: keyPassword not found in key.properties")
                throw GradleException("Missing keyPassword in key.properties for release signing.")
            }
            val storeFileValue = keystoreProperties["storeFile"] as? String
            storeFile = if (storeFileValue != null) {
                file(storeFileValue)
            } else {
                println("ERROR: storeFile not found in key.properties")
                throw GradleException("Missing storeFile in key.properties for release signing.")
            }
            storePassword = keystoreProperties["storePassword"] as? String ?: run {
                println("ERROR: storePassword not found in key.properties")
                throw GradleException("Missing storePassword in key.properties for release signing.")
            }


        }
    }


    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            // minifyEnabled = false // Or set to true if you configure ProGuard/R8
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    sourceSets {
        getByName("main") {
            java.srcDir("src/main/kotlin")
        }
    }
    testOptions {
        execution = "ANDROIDX_TEST_ORCHESTRATOR"
    }

    ndkVersion = "27.0.12077973"

}

flutter {
    source = "../../"
}

dependencies {
    implementation("com.google.android.gms:play-services-base:18.5.0")
    implementation("com.google.android.gms:play-services-auth:21.3.0")

    implementation(platform("com.google.firebase:firebase-bom:33.8.0"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-firestore")
    implementation("com.google.firebase:firebase-auth-ktx")

    androidTestUtil("androidx.test:orchestrator:1.4.2")

    implementation("androidx.window:window:1.0.0")
    implementation("androidx.window:window-java:1.0.0")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    // Example explicit versions (replace with actual versions)
    // implementation("com.google.firebase:firebase-analytics:22.0.0")
    // implementation("com.google.firebase:firebase-firestore:24.15.0")
    // implementation("com.google.firebase:firebase-auth-ktx:22.3.0")


}